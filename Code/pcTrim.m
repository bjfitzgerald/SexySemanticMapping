function [ PC ] = pcTrim( PC, r, p )
% Remove points that are out of range from some focal point
% Default point is center of mass

m = size(PC.Points, 1);

if nargin < 3
   p = mean(PC.Points);
end

D = PC.Points - repmat(p, [m, 1]);
D = sqrt(sum(D.^2, 2));

sel = D < r;
PC.Points = PC.Points(sel, :);

if(isfield(PC, 'Colors'))
   PC.Colors = PC.Colors(sel, :); 
end

if(isfield(PC, 'Normals'))
   PC.Normals = PC.Normals(sel, :); 
end

end

