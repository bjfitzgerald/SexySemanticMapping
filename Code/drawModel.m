function [ ] = drawModel( PC, Label )

%% Draw model
figure,
pcshow(PC.Points,PC.Colors);
drawnow;
title(Label);

xlabel('X'); ylabel('Y'); zlabel('Z');

end

