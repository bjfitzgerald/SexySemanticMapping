function [ PC ] = getPointCloud( scene, frame )

%% Setup Paths and Read RGB and Depth Images
Path = '../Data/SingleObject/'; 
SceneName = sprintf('%0.3d', scene);
FrameNum = num2str(frame);

I = imread([Path,'scene_',SceneName,'/frames/frame_',FrameNum,'_rgb.png']);
I = im2double(I);
ID = imread([Path,'scene_',SceneName,'/frames/frame_',FrameNum,'_depth.png']);
ID = double(ID);

RGB = I;
D = ID;

[pcx, pcy, pcz, r, g, b, ~, ~, ~,~] = depthToCloud_full_RGB(D, RGB, './params/calib_xtion.mat');

P = [pcx pcy pcz];
C = [r, g, b];

PC = struct('Points', P, 'Colors', C);

end

