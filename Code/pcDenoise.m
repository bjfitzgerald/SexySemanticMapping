function [ PC ] = pcDenoise( PC, k, s )
% Removes outlier points

if nargin < 2
   k = 10; 
end
if nargin < 3
   s = 1; 
end

m = size(PC.Points, 1);
KD = KDTreeSearcher(PC.Points);

[Pk_idx, ~]= KD.knnsearch(PC.Points, 'k', k);
muDist = zeros(m, 1);
for i = 1:m
   p = PC.Points(i, :);
   idx = Pk_idx(i, :);
   K = PC.Points(idx', :); % Neighborhood points
   
   D = K - repmat(p, [k, 1]);
   D = sum(D.^2, 2);
   muDist(i) = mean(D);
end

mu = mean(muDist);
sigma = std(muDist);

sel = muDist < s*sigma;
PC.Points = PC.Points(sel, :);

if(isfield(PC, 'Colors'))
   PC.Colors = PC.Colors(sel, :); 
end

if(isfield(PC, 'Normals'))
   PC.Normals = PC.Normals(sel, :); 
end

end

