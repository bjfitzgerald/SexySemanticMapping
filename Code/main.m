
[rgb1, d1] = readRgbd(6, 1);
[rgb2, d2] = readRgbd(6, 2);
[height, width, ~] = size(rgb1);

%[P1, P2] = getCorrespondingPoints(rgb1, rgb2);
%showCorrespondence(P1, P2, rgb1, rgb2);

%% Find the 3d location of the corresponding points
P3d1 = getPoints(rgb1, d1);
P3d2 = getPoints(rgb2, d2);

icp(P3d1, P3d2);

%idx1 = sub2ind([height, width], P1(:, 2), P1(:, 1));
%idx2 = sub2ind([height, width], P2(:, 2), P2(:, 1));

%PC1 = P3d1(idx1, :);
%PC2 = P3d2(idx2, :);