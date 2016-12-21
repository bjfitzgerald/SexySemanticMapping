function [ Norm ] = pcNormals( P, k, v )
% Given a set of points P, this will return a set of Estimated surface
% normals Norm

if nargin < 2
    k = 5;
end

m = size(P, 1);
KD = KDTreeSearcher(P);
Norm = zeros(m, 3);

[Pk_idx, ~]= KD.knnsearch(P, 'k', k);

for i = 1:m
   idx = Pk_idx(i, :);
   p = P(i, :);
   K = P(idx', :); % Neighborhood points
   
	if nargin < 3
        v = p;
    end
   
   M = cov(K);
   [V, ~] = eig(M);
   norm_i = V(:, 1)';
   norm_i = norm_i/norm(norm_i);
   norm_i = norm_i * -sign(dot(norm_i, v));
   
   Norm(i, :) = norm_i;
end

end

