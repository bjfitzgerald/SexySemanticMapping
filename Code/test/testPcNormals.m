addpath('../');

m = 500; % Number of points to use

% N random points
P = rand(m, 3);
P = bsxfun(@minus, P, [0.5 0.5 0]);

% Normalize points to place them on a unit sphere
%Pn = sqrt(sum(P.^2, 2));
%P = P./repmat(Pn, [1, 3]);
%P = P .* 10;

%load('../sceneLib/s44.mat');
PC = s44.Model;
P = PC.Points;
m = size(P, 1);

tic;
Norm = pcNormals(P, 15, [-1 0 -1]);
toc;

% Draw points
scatter3(P(:, 1), P(:, 2), P(:, 3), 50, Norm, '.'); hold on;

%{
% Draw normals
for i = 1:m
   p1 = P(i, :);
   p2 = p1+Norm(i, :)*5;
   
   plot3([p1(1);p2(1)], [p1(2);p2(2)], [p1(3);p2(3)]);
end
%}
hold off