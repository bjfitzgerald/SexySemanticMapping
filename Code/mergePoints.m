function [ P ] = mergePointsColor( P1, P2, threshold )
% Merges two point clouds by removing duplicate points 
% and replases them with an average

Np1 = size(P1, 1);
Np2 = size(P2, 1);
KD = KDTreeSearcher(P2);
M = KD.rangesearch(P1, threshold);

P = zeros(Np1, 3);
rmIdx = zeros(Np2, 1);

k =1;
for i = 1:Np1
    p_i = P1(i,:);
    Idx = M{i};
    nIdx = numel(Idx);
    
    if nIdx == 0
        P(i, :) = p_i;
        continue;
    end

    % Add indexes to remove list
    rmIdx(k:k+nIdx-1) = Idx;
    k = k+nIdx;
    
    P(i, :) = p_i;
end

%% Remove merged points
rmIdx = rmIdx(rmIdx>0);
P2(rmIdx, :) = [];
fprintf('Removed %i points', numel(rmIdx));

P = [P;P2];
end

