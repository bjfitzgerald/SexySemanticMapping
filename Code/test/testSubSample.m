
addpath('../');

[rgb1, d1] = readRgbd(6, 100);
[MP, MC] = getPoints(rgb1, d1);

figure,
pcshow(MP,MC);
drawnow;
title('Full Sample');

tic;
SI = subSample(MP, 3000);
toc;

figure,
pcshow(MP(SI, :), MC(SI, :));
drawnow;
title('Sub Sample');