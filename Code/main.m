
[rgb1, d1] = readRgbd(6, 1);
[rgb2, d2] = readRgbd(6, 100);
[height, width, ~] = size(rgb1);

%[P1, P2] = getCorrespondingPoints(rgb1, rgb2);
%showCorrespondence(P1, P2, rgb1, rgb2);

%% Find the 3d location of the corresponding points
[P1, C1] = getPoints(rgb1, d1);
[P2, C2] = getPoints(rgb2, d2);

Pts = icp(P1, P2, 10, 0.1);

r = [C1(:, 1);C2(:, 1)];
g = [C1(:, 2);C2(:, 2)];
b = [C1(:, 3);C2(:, 3)];
Color = [r g b];

figure,
pcshow([P1;Pts],Color);
drawnow;
title('3D Point Cloud');

%idx1 = sub2ind([height, width], P1(:, 2), P1(:, 1));
%idx2 = sub2ind([height, width], P2(:, 2), P2(:, 1));

%PC1 = P3d1(idx1, :);
%PC2 = P3d2(idx2, :);