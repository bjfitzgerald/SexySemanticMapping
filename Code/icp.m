function [ P ] = icp( PC1, PC2 )
% Iterative Closest Point
% PC1 is the destination point cloud
% PC2 is the source point cloud that should be fitted to destination
% P is the combination of the two points clouds after alignment

numItter = 1;

%% Find Nearest Neighbour
KD = KDTreeSearcher(PC1);

for it = 1:numItter
    %{
    [Idx, MD] = KD.knnsearch(PC2);
    MIdx = [Idx, (1:numel(Idx))'];

    %% Reject points that are too far apart
    MuDist = mean(MD)
    sel = MD < MuDist/10;

    MIdx = MIdx(sel, :);

    PM1 = PC1(MIdx(:,1), :);    % Corresponding points from point cloud 1
    PM2 = PC2(MIdx(:,2), :);    % Corresponding points from point cloud 2
    %}
    
    %Idx1 = randperm(size(PC2, 1), 3);
    %[Idx2, D] = KD.knnsearch(PC2(Idx1,:));
    %PM1 = PC1(Idx1, :);    % Corresponding points from point cloud 1
    %PM2 = PC2(Idx2, :);    % Corresponding points from point cloud 2
    PM1 = PC1;
    PM2 = PC2;
    
    [R, T] = icp_step(PM1, PM2);
    
    for i = 1:size(PC2, 1)
       p = PC2(i, :);
       p = (R*p')';
       p = p+T;
       PC2(i, :) = p;
    end
    
    P = PC2;
end

end

function [R, T] = icp_step(PM1, PM2)
    %% Find Rotation
    n = size(PM1, 1);
    p1 = mean(PM1);
    p2 = mean(PM2);

    Q1 = PM1 - repmat(p1, [n 1]);
    Q2 = PM2 - repmat(p2, [n 1]);

    H = zeros(3);
    %H = Q1' * Q2;
    for i = 1:n
        h = Q1(i,:)' * Q2(i,:);
        H = H+h;
    end

    [U, ~, V] = svd(H);
    X = V'*U';

    x = det(X);
    if(x < 0) 
       error('FAIL');
    end
    R = X

    %% Find Translation
    pr = (R*p1')';
    T = p2-pr
    icp_error(PM1, PM2, R, T)
end

function [err] = icp_error(P1, P2, R, T)
    err = 0;
    for i = 1:size(P1,1)
       p = P2(i, :);
       p = (R*p')' + T;
       
       e = P1(1) - p;
       err = err + sum(e.^2);
    end
end