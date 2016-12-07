function [ P ] = icp( PC1, PC2, NItter, tol )
    % Iterative Closest Point
    % PC1 is the destination point cloud
    % PC2 is the source point cloud that should be fitted to destination
    % P is the combination of the two points clouds after alignment

    if nargin < 3
        NItter = 3;
    end
    if nargin < 4
       tol = 0.01;
    end
    Np1 = size(PC1, 1);
    Np2 = size(PC2, 1);

    %% Find Nearest Neighbour
    KD = KDTreeSearcher(PC1);
    R = eye(3);
    T = zeros(1, 3);
    
    for it = 1:NItter
        [Idx, MD] = KD.knnsearch(PC2);
        MIdx = [Idx, (1:numel(Idx))'];

        %% Reject points that are too far apart
        MuDist = mean(MD)
        sel = MD < MuDist/10;
        MIdx = MIdx(sel, :);

        PM1 = PC1(MIdx(:,1), :);    % Corresponding points from point cloud 1
        PM2 = PC2(MIdx(:,2), :);    % Corresponding points from point cloud 2    
        N = size(PM1, 1)
        
        [R, T] = icp_step(PM1, PM2);
        %Apply rotation and tranlation
        PM2 = ((R*PM2') + repmat(T', 1,N))';
        %Estimate error
        err = sum(sum((PM1 - PM2).^2, 2));
        fprintf('Itter: %i, Err: %1.5f\n', it, err);
        
        PC2 = ((R*PC2') + repmat(T', 1,Np2))';
        
        if err <= tol
           %break; 
        end
    end

    P = PC2;

end

function [R, T] = icp_step(P1, P2)
    Mu1 = mean(P1);
    Mu2 = mean(P2);
    Q1 = bsxfun(@minus, P1, Mu1);
    Q2 = bsxfun(@minus, P2, Mu2);
    H = Q2'*Q1;

    [U, ~, V] = svd(H);
    R = V*diag([1 1 det(U*V')])*U';
    T = Mu1 - (R * Mu2')';

end
