addpath('../');
PC = getPointCloud(0, 350);
%PC = pcNormalize(PC);

figure,
pcshow(PC.Points,PC.Colors);
drawnow;
title('Full Sample');

fprintf('Trim ');
tic;
PCtrim = pcTrim(PC, 250);
toc;

figure,
pcshow(PCtrim.Points, PCtrim.Colors);
drawnow;
title('Point subsample');