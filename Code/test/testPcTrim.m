addpath('../');
PC = getPointCloud(6, 300);
PC = pcNormalize(PC);

figure,
pcshow(PC.Points,PC.Colors);
drawnow;
title('Full Sample');

fprintf('Trim ');
tic;
PCtrim = pcTrim(PC, 0.2);
toc;

figure,
pcshow(PCtrim.Points, PCtrim.Colors);
drawnow;
title('Point subsample');