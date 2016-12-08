
[rgb1, d1] = readRgbd(6, 1);
[height, width, ~] = size(rgb1);
[MP, MC] = getPoints(rgb1, d1);

for i = 50:50:400
    [rgb, d] = readRgbd(6, i);
    [P, C] = getPoints(rgb, d);

    Pts = icp(MP, P, 30, 4000);

    [MP, MC] = mergePoints(MP, MC, Pts, C, 2.0);
    fprintf('Model size: %i', size(MP, 1));
    
    figure,
    pcshow(MP,MC);
    drawnow;
    title(num2str(i));
end

figure,
pcshow(MP,MC);
drawnow;
title('Merged Model');
