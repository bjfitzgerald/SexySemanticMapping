function [ Obj_pc ] = extractObjects( scene, frames, path )

%% Collect point clouds
PC = cell(1, numel(frames));
UP = zeros(numel(frames), 3);
for i = 1:numel(frames)
    fprintf('Frame: %i \n', frames(i));
    PC_i = getPointCloud(scene, frames(i), path);
    PC_i = pcTrim(PC_i, 400);
    [~, PC_i] = subSample(PC_i, 20000 );
    
    
    %Find and remove plane
    largestPlane = 0;
    while (1)
        [PIdx, N] = findPlane(PC_i, 100, 10 );
        np_plane = size(PIdx, 1);
        if np_plane < 2000 % threshold for plane removal
           break; 
        end
        if np_plane > largestPlane
           UP(i, :) = N;
           largestPlane = np_plane;
        end
        fprintf('Remove %i points \n', size(PIdx, 1));
        PC_i.Points(PIdx, :) = [];
        PC_i.Colors(PIdx, :) = [];%repmat([1, 0, 0], [size(PIdx,1), 1]);
    end
    
    
    % remove noise
    PC_i = pcDenoise(PC_i, 20, 3);
    PC_i.Normals = pcNormals(PC_i.Points, 4); 
    [~, PC_i] = subSample(PC_i, 4000, 20, 'normal');
    
    % Center model
    mu = mean(PC_i.Points);
    PC_i.Points = bsxfun(@minus, PC_i.Points, mu);
    
    PC{i} = PC_i;
end

%% Build Model
PC_main = PC{1};
for i = 2:numel(PC)
    PC_d = PC{i};
    
    [PC_s, R_i, T_i] = icp(PC_d, PC_main, 100 );
    
    P_i = [PC_s.Points; PC_d.Points];
    C_i = [PC_s.Colors; PC_d.Colors];
    N_i = [PC_s.Normals; PC_d.Normals];
    
    PC_main = struct('Points', P_i, 'Colors', C_i, 'Normals', N_i);
end

Obj_pc = pcDenoise(PC_main, 50, 3);

%% Orient model
sceneUp = mean(UP);
up = [0 1 0];

axis = cross(up, sceneUp);
angle = acos(dot(up, sceneUp));
R_up = vrrotvec2mat([axis angle]);
Obj_pc.Points = (R_up*Obj_pc.Points')';

end

