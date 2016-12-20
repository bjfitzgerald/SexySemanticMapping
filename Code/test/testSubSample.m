
addpath('../');

%% Geneate Sphere
ms = 3000; % number of points on the sphere
Xs = rand(ms, 3);
for i = 1:ms
   x = Xs(i, :) - [0.5, 0.5, 0.5];
   x = x/norm(x);
   Xs(i,:) = x;
end
N = pcNormals(Xs, 10);
PC = struct('Points', Xs, 'Colors', N, 'Normals', N);

drawModel(PC, 'Normals', 'normal');
figure,
pcshow(PC.Points,PC.Colors);

fprintf('Point subsample ');
tic;
[~, PCsubp] = subSample(PC, 100);
toc;

fprintf('Normal subsample ');
tic;
[~, PCsubn] = subSample(PC, 100);
toc;

figure,
pcshow(PCsubp.Points, PCsubp.Colors);
drawnow;
title('Point subsample');
figure,
pcshow(PCsubn.Points, PCsubn.Colors);
drawnow;
title('Normal subsample');