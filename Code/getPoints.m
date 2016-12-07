function [ P, C ] = getPoints( RGB, D )
%GETPOINTS Summary of this function goes here
%   Detailed explanation goes here

[pcx, pcy, pcz, r, g, b, D_, X, Y,validInd] = depthToCloud_full_RGB(D, RGB, './params/calib_xtion.mat');
P = [pcx pcy pcz];
C = [r, g, b];

end

