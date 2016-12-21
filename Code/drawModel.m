function [ ] = drawModel( PC, Label, mode, ms )

if nargin < 3
    mode = 'color';
end
if nargin < 4
    ms = 30;
end
    
if strcmp(mode, 'color')
    C = PC.Colors;
elseif strcmp(mode, 'normal')
    C = ((PC.Normals +1) ./2);
end

%% Draw model
figure,
pcshow(PC.Points, C, 'MarkerSize', ms);
drawnow;
title(Label);

xlabel('X'); ylabel('Y'); zlabel('Z');

end

