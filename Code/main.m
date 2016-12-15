
scene = 6;
%frames = [1, 50, 100, 150, 200, 250, 300, 350, 400, 414];
%frames = [1, 25, 50, 75, 100, 120];
frames = [75, 100, 125, 150];

%% Collect point clouds
PC = cell(1, numel(frames));
for i = 1:numel(frames)
    fprintf('Frame: %i \n', frames(i));
    PC_i = getPointCloud(scene, frames(i));
    [~, PC_i] = subSample(PC_i, 4000);
    PC_i.Normals = pcNormals(PC_i.Points, 4, PC_i.Points(1,:)); 
    
    %{
    % Remove plane
    while (1)
        PIdx = findPlane(PC_i, 100, 10);
        if size(PIdx, 1) < 500
           break; 
        end
        fprintf('Remove %i points \n', size(PIdx, 1));
        PC_i.Points(PIdx, :) = [];
        PC_i.Colors(PIdx, :) = [];%repmat([1, 0, 0], [size(PIdx,1), 1]);
        PC_i.Normals(PIdx, :) = [];
    end
    %}
    
    PC{i} = PC_i;
end

%% Collect transformations
R = cell(1, numel(frames)); R{1} = eye(3);
T = cell(1, numel(frames)); T{1} = zeros(1, 3);
for i = 1:numel(PC)-1
    
    PC_a = PC{i};
    PC_b = PC{i+1};
    
    [~, R_i, T_i] = icp(PC_a, PC_b, 100, 4000);
    R{i+1} = R_i * R{i};
    T{i+1} = T_i + T{i};
end

%% Build Model
P = []; % Points of the final model
C = []; % Color of the final model
for i = 1:numel(R)
    R_i = R{i};
    T_i = T{i};
    
    P_i = PC{i}.Points;
    C_i = PC{i}.Colors;
    m = size(P_i, 1);
    
    P_i = ((R_i*P_i') + repmat(T_i', 1,m))';
    
    P = [P;P_i];
    C = [C;C_i];
end

%% Draw model
figure,
pcshow(P,C);
drawnow;
title('Merged Model');
