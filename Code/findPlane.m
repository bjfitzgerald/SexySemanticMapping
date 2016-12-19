function [ PIdx, N, P ] = findPlane( PC, itt, tol )
% Find a large set of co-planar points in the given point cloud using
% RANSAC
% PC is the point cloud
% Itt is the number of RANSAC itterations to use
% tol is the tolerance for how close a point must be to a plane to be
% considdered on the plane
% Returns PIdx, a vector of indexes to points on the plane
% N and P are the normal and point of the plane

if nargin < 3
    tol = 10^-3;
end
if nargin < 2
    itt = 100;
end

m = size(PC.Points, 1);
mask = false(m, 1);
best_count = 0;
best_n = zeros(1,3);
best_p = zeros(1,3);

for i = 1:itt
    sel = randperm(m, 3); 
    P = PC.Points(sel, :); % 3 random points
    
    n = cross(P(1,:)-P(2,:), P(1,:)-P(3,:));
    n = n/norm(n); % normalized plane normal
    p = P(1,:); % one point on the plane
    n = n * sign(-dot(n, p)); % fix direction of normal
    
    % Find all points on this plane
    for k = 1:m
       x = PC.Points(k, :);
       d = abs(dot(x-p, n)); % distance to plane
       mask(k) = d<tol;
    end
    
    count = sum(mask);
    if count > best_count
        best_count = count;
        best_mask = mask;
        best_n = n;
        best_p = p;
    end     
end

PIdx = (1:m)';
PIdx = PIdx(best_mask);

N = best_n;
P = best_p;

end

