function [ Weights ] = borderMetric( PC )

m = size(PC.Points, 1);
KD = KDTreeSearcher(PC.Points);

P = PC.Points;
N = PC.Normals;
Weights = zeros(m, 1);

for i = 1:m
    p = P(i, :);
    n = N(i, :);
    
    % Find neighborhood
    [I, ~] = KD.rangesearch(p, 10);
    %[Ki, ~]= KD.knnsearch(P, 'k', 5);
    Ki = I{1};
    Kp = P(Ki, :);    %Neighborhood points
    Kn = N(Ki, :);    %Neighborhood normals
    
    k = numel(Ki);
    W = 0;
    for j = 2:k
        w = weight(p, Kp(j,:), n, Kn(j, :));
        %W = W + w;
        W = max(W, w);
    end
    Weights(i) = W;%(W/(k-1));

end

end

function [ w ] = weight( p1, p2, n1, n2 )
    d = dot((p2-p1), n2);
    
    if d > 0
       w = (1 - dot(n1, n2))^2;
    else
        w = 1 - dot(n1, n2);
    end
end