%% CMSC 426: Project 5 Helper Code
% Written by: Nitin J. Sanket (nitinsan@terpmail.umd.edu)
% PhD in CS Student at University of Maryland, College Park
% Acknowledgements: Bhoram Lee of University of Pennsylvania for help with depthToCloud function

clc
clear all
close all

%% Setup Paths and Read RGB and Depth Images
Path = '../Data/SingleObject/'; 
SceneNum = 1;
SceneName = sprintf('%0.3d', SceneNum);
FrameNum = num2str(0);

I = imread([Path,'scene_',SceneName,'/frames/image_',FrameNum,'_rgb.png']);
ID = imread([Path,'scene_',SceneName,'/frames/image_',FrameNum,'_depth.png']);

%% Extract 3D Point cloud
% Inputs:
% ID - the depth image
% I - the RGB image
% calib_file - calibration data path (.mat) 
%              ex) './param/calib_xtion.mat'
%              
% Outputs:
% pcx, pcy, pcz    - point cloud (valid points only, in RGB camera coordinate frame)
% r,g,b            - color of {pcx, pcy, pcz}
% D_               - registered z image (NaN for invalid pixel) 
% X,Y              - registered x and y image (NaN for invalid pixel)
% validInd	   - indices of pixels that are not NaN or zero
% NOTE:
% - pcz equals to D_(validInd)
% - pcx equals to X(validInd)
% - pcy equals to Y(validInd)

[pcx, pcy, pcz, r, g, b, D_, X, Y,validInd] = depthToCloud_full_RGB(ID, I, './params/calib_xtion.mat');
Pts = [pcx pcy pcz];

totalFrames = 35;
frameFeatures = cell(1,totalFrames+1);
frameValidPoints = cell(1,totalFrames+1);
fundamentalMatrices = cell(1,totalFrames);

% Make initial assignments at first index, the 0th image
corners = detectHarrisFeatures(rgb2gray(I));
[features, valid_corners] = extractFeatures(rgb2gray(I), corners);
frameFeatures{1,1} = features;
frameValidPoints{1,1} = valid_corners;

%% Loop to fill cell with x,y,z coords from point cloud

for i=1:totalFrames
    currentFrameNum = num2str(i);
    
    I = imread([Path,'scene_',SceneName,'/frames/image_',FrameNum,'_rgb.png']);
    ID = imread([Path,'scene_',SceneName,'/frames/image_',FrameNum,'_depth.png']);
    
    % Currently not using point cloud coords, which should change
    [pcx, pcy, pcz, r, g, b, D_, X, Y,validInd] = depthToCloud_full_RGB(ID, I, './params/calib_xtion.mat');
    Pts = [pcx pcy pcz];
    
    % Extract feature neighborhoods
    corners = detectHarrisFeatures(rgb2gray(I));
    [features, valid_corners] = extractFeatures(rgb2gray(I), corners);
    frameFeatures{1,i+1} = features;
    frameValidPoints{1,i+1} = valid_corners;
    
    valid_points1 = frameValidPoints{1,i};
    valid_points2 = frameValidPoints{1,i+1};
    
    % Match the features
    indexPairs = matchFeatures(frameFeatures{1,i},frameFeatures{1,i+1});
    
    matchedPoints1 = valid_points1(indexPairs(:,1),:);
    matchedPoints2 = valid_points2(indexPairs(:,2),:);
    
    % Compute fundamental matrix with RANSAC
    fundamentalMatrices{1,i} = estimateFundamentalMatrix(matchedPoints1,...
        matchedPoints2,'Method','RANSAC',...
        'NumTrials',2000,'DistanceThreshold',1e-4);
end

%% Display Images and 3D Points
% Note this needs the computer vision toolbox: you'll have to run this on
% the server
figure,
subplot 121
imshow(I);
title('RGB Input Image');
subplot 122
imagesc(ID);
title('Depth Input Image');

figure,
pcshow(Pts,[r g b]/255);
drawnow;
title('3D Point Cloud');
