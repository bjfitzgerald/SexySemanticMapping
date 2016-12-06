function [ RGB, D ] = readRgbd( scene, frame )
%retuns a 4 channel image red, green, blue and depth

%% Setup Paths and Read RGB and Depth Images
Path = '../Data/SingleObject/'; 
SceneNum = scene;
SceneName = sprintf('%0.3d', SceneNum);
FrameNum = num2str(frame);

I = imread([Path,'scene_',SceneName,'/frames/frame_',FrameNum,'_rgb.png']);
I = im2double(I);
ID = imread([Path,'scene_',SceneName,'/frames/frame_',FrameNum,'_depth.png']);
ID = double(ID);

RGB = I;
D = ID;


end

