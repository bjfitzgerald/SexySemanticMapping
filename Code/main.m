
[rgb1, d1] = readRgbd(6, 100);
[height, width, ~] = size(rgb1);
[MP, MC] = getPoints(rgb1, d1);

for i = 105:5:150
    [rgb, d] = readRgbd(6, i);
    [P, C] = getPoints(rgb, d);

    Pts = icp(P, MP, 20, 4000);

    [MP, MC] = mergePointsColor(Pts, MC, P, C, 2.0);
    fprintf('Model size: %i \n', size(MP, 1));
end

figure,
pcshow(MP,MC);
drawnow;
title('Merged Model');
