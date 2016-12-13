function [ P, C ] = mergePointsColor( P1, C1, P2, C2, threshold )
% Merges two point clouds by removing duplicate points 
% and replases them with an average

Np1 = size(P1, 1);
Np2 = size(P2, 1);
KD = KDTreeSearcher(P2);
M = KD.rangesearch(P1, threshold);

P = zeros(Np1, 3);
rmIdx = zeros(Np2, 1);
C = zeros(Np1, 3);

k =1;
for i = 1:Np1
    p_i = P1(i,:);
    c_i = C1(i,:);
    Idx = M{i};
    nIdx = numel(Idx);
    
    if nIdx == 0
        P(i, :) = p_i;
        C(i, :) = c_i;
        continue;
    end
    
    pts = P2(Idx, :);
    colors = C2(Idx, :);
    
    % Add indexes to remove list
    rmIdx(k:k+nIdx-1) = Idx;
    k = k+nIdx;
    
    P(i, :) = p_i;
    %P(i, :) = mean([pts;p_i]);
    C(i, :) = mean([colors;c_i]);
end

%% Remove merged points
rmIdx = rmIdx(rmIdx>0);
P2(rmIdx, :) = [];
C2(rmIdx, :) = [];
fprintf('Removed %i points', numel(rmIdx));

P = [P;P2];
C = [C;C2];
end

