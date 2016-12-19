
addpath('../');
PC = getPointCloud(6, 100);
fprintf('Get normals ');
tic;
PC.Normals = pcNormals(PC.Points, 4, PC.Points(1,:));
toc;

figure,
pcshow(PC.Points,PC.Colors);
drawnow;
title('Full Sample');

fprintf('Point subsample ');
tic;
[SIp, PCsubp] = subSample(PC, 4000);
toc;

fprintf('Normal subsample ');
tic;
[SIn, PCsubn] = subSample(PC, 4000);
toc;

figure,
pcshow(PCsubp.Points, PCsubp.Colors);
drawnow;
title('Point subsample');
figure,
pcshow(PCsubn.Points, PCsubn.Colors);
drawnow;
title('Normal subsample');