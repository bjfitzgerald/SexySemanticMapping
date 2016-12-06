function [ P1, P2 ] = getCorrespondingPoints( I1, I2 )
    %Finds a set of matching points in images I1 and I2

    G1 = rgb2gray(I1);
    G2 = rgb2gray(I2);
    G1 = imgaussfilt(G1);
    G2 = imgaussfilt(G2);

    [F1, D1] = getCorners(G1, 100);
    [F2, D2] = getCorners(G2, 100);

    [P1, P2] = matchFeatures(F1, D1, F2, D2);

end

function [ P, D ] = getCorners( I, n )
    % I should be a grayscale image
    % n is maximum number of corners

    % P is a 2xn matrix with x y coordinates for each corner

    I = imgaussfilt(I);
    C = cornermetric(I);

    [c,r] = anms(C, n);
    D = fdescript(I, r, c);
    P = [c, r];
end

function [ x, y ] = anms( C, n )
    max = imregionalmax(C);

    [row, col] = find(max);
    num_points = numel(row);
    r = inf(num_points, 1);

    for i = 1:num_points
       for j = 1:num_points
           ed = inf;
          if(C(row(j), col(j)) > C(row(i), col(i)))
             ed = (col(j)-col(i))^2 + (row(j)-row(i))^2; 
          end
          if(ed < r(i))
             r(i) = ed; 
          end
       end
    end

    [~, idx] = sort(r, 1, 'descend');
    n = min(n, size(idx, 1));
    y = row(idx(1:n));
    x = col(idx(1:n));
end

function [ P1, P2 ] = matchFeatures( F1, D1, F2, D2 )

    num_points_1 = size(F1, 1);
    num_points_2 = size(F2, 1);
    threshold = 0.7;

    P1 = [];
    P2 = [];

    for i = 1:num_points_1
        p1 = F1(i,:);
        
        m1 = [0,0];     %best match
        c1 = inf;       %best correspondance
        c2 = inf;       %second best correspondance

        for j = 1:num_points_2
            p2 = F2(j, :);
            c = sum((D1(i,:)-D2(j,:)).^2);
            if(c < c1)
               c2 = c1;
               c1 = c;
               m1 = p2;
            end
        end

        if(c1/c2 < threshold)
           P1(end+1, :) = p1;
           P2(end+1, :) = m1;
        end
    end

end

function [ D ] = fdescript( I, r, c )
    %I is the image
    %r and c is the row/column coord of the points
    %Returns D where each row is a descrition of the point at the corisponding
    %index in r/c

    window_size = 40;

    n = numel(r);

    D = zeros(n, 64);
    I_pad = padarray(I, [window_size/2, window_size/2], 'replicate');

    for i = 1:n
        rows = r(i):(r(i)+window_size);
        cols = c(i):(c(i)+window_size);
        
        %rows
        %cols
        %size(I_pad)
        W = I_pad(rows, cols);
        
        W = imgaussfilt(W, 4); % Blur window
        d = W(1:5:window_size, 1:5:window_size);
        d = (d-mean(d(:))) ./ std(d(:));

        D(i, :) = d(:);
    end

end
