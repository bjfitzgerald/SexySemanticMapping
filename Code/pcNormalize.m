function [ PC ] = pcNormalize( PC )
% Scales the point cloud to fit in a unit cube

P = PC.Points;

maxCoord = max(P);
minCoord = min(P);
d = max(maxCoord-minCoord);
mu = mean(P);

P = bsxfun(@minus, P, mu);
P = bsxfun(@times, P, 1/d);

PC.Points = P;

end

