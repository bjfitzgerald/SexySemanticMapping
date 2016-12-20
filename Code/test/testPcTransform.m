addpath('../');

%% Geneate Sphere
ms = 200; % number of points on the sphere
Xs = rand(ms, 3);
for i = 1:ms
   x = Xs(i, :) - [0.5, 0.5, 0.5];
   x = x/norm(x);
   Xs(i,:) = x;
end
N = pcNormals(Xs, 10);
PC = struct('Points', Xs, 'Colors', N, 'Normals', N);

drawModel(PC, '1', 'normal', 50);

R1 = vrrotvec2mat([0 0 1 deg2rad(90)]);
PC = pcTransform(PC, R1, [1 0 0]);
drawModel(PC, '2', 'normal', 50);

R2 = vrrotvec2mat([1 0 0 deg2rad(90)]);
PC = pcTransform(PC, R1, [0 0 0]);
drawModel(PC, '3', 'normal', 50);