function [ Obj_pc ] = segmentObject( scene, frames )

%% Collect point clouds
PC = cell(1, numel(frames));
for i = 1:numel(frames)
    fprintf('Frame: %i \n', frames(i));
    PC_i = getPointCloud(scene, frames(i));
    %PC_i = pcNormalize(PC_i);
    PC_i = pcTrim(PC_i, 270);
    [~, PC_i] = subSample(PC_i, 20000 );
    
    % Remove plane
    while (1)
        PIdx = findPlane(PC_i, 100, 10 );
        if size(PIdx, 1) < 3000
           break; 
        end
        fprintf('Remove %i points \n', size(PIdx, 1));
        PC_i.Points(PIdx, :) = [];
        PC_i.Colors(PIdx, :) = [];%repmat([1, 0, 0], [size(PIdx,1), 1]);
    end
    
    PC_i = pcDenoise(PC_i, 20, 3);
    PC_i.Normals = pcNormals(PC_i.Points, 4, PC_i.Points(1,:)); 
    [~, PC_i] = subSample(PC_i, 2000, 20, 'normal');
    
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

%% Draw model
%figure,
%pcshow(PC_main.Points,PC_main.Colors);
%drawnow;
%title('Merged Model 1');

end

