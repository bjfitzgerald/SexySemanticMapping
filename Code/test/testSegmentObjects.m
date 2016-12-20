addpath('../');

%load('../sceneLib/s44');
%PC = extractObjects(44, [100, 200], '../Data/MultipleObjects/');
PC = s44.Model;
%PC.Normals = pcNormals(PC.Points, 10, [1 1 -1]);
%[~,PC] = subSample(PC, 5000, 5, 'normal');
PC = pcSmooth(PC, 10);
drawModel(PC, 'Test', 'normal');

W = borderMetric(PC);
%L = segmentObjects(PC);
m = size(PC.Points, 1);
P = PC.Points;
N = PC.Normals;
%imagesc(texton_map), colormap(jet);

%% Draw Points
scatter3(P(:, 1), P(:, 2), P(:, 3), 50, W(:), '.'); hold on;
%scatter3(P(:, 1), P(:, 2), P(:, 3), 50, L(:), '.'); hold on;
colormap(hot);
colorbar;
hold off;