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

    P = ransac_icp(PC1, PC2, NItter, tol);
    %P = p2p_icp(PC1, PC2, NItter, tol);
    
end

function [ P ] = p2p_icp(PC1, PC2, NItter, tol)
    Np2 = size(PC2, 1);

    PC1_sub = mergePoints(PC1, PC1, 10);
    PC2_sub = mergePoints(PC2, PC2, 10);
    
    %% Find Nearest Neighbour
    KD = KDTreeSearcher(PC1_sub);
    R = eye(3);
    T = zeros(1, 3);
    
    for it = 1:NItter
        [Idx, MD] = KD.knnsearch(PC2_sub);
        MIdx = [Idx, (1:numel(Idx))'];
        
        %% Reject dublicates
        [~, IA, ~] = unique(Idx);
        MIdx = MIdx(IA, :);
        MD = MD(IA);
        
        %[MD, SIdx] = sort(MD);
        %MIdx = MIdx(SIdx, :); % Sorted points matches

        %% Reject points that are too far apart
        Sigma = std(MD);
        sel = MD < 3.5*Sigma;
        MIdx = MIdx(sel, :);

        PM1 = PC1_sub(MIdx(:,1), :);    % Corresponding points from point cloud 1
        PM2 = PC2_sub(MIdx(:,2), :);    % Corresponding points from point cloud 2    
        N = size(PM1, 1)
        
        pcshow(PM1,[1 0 0]); hold on;
        pcshow(PM2,[0 0 1]);
        drawnow;
        title('Match');
        hold off;
        pause
        
        [R, T] = icp_step(PM1, PM2);
        %Apply rotation and tranlation
        PM2 = ((R*PM2') + repmat(T', 1,N))';
        %Estimate error
        err = sum(sum((PM1 - PM2).^2, 2));
        fprintf('Itter: %i, Err: %1.5f \n', it, err);
        
        PC2 = ((R*PC2') + repmat(T', 1,Np2))';
    end

    P = PC2;
end

function [ P ] = ransac_icp(PC1, PC2, NItter, tol)
    Np1 = size(PC1, 1);
    Np2 = size(PC2, 1);
    %N = min([Np1, Np2, 2000]) %subsample size
    
    %% Find Nearest Neighbour
    KD = KDTreeSearcher(PC1);
    
    for it = 1:NItter
        [Idx, MD] = KD.knnsearch(PC2);
        MIdx = [Idx, (1:numel(Idx))'];

        %% Reject dublicates
        [~, IA, ~] = unique(Idx);
        MIdx = MIdx(IA, :);
        MD = MD(IA);
        
        N1 = size(MIdx, 1);
        N2 = 400;
        
        R_b = eye(3);
        T_b = zeros(1,3);
        E_b = 0;
        
        for k = 1:50
            sel = randperm(N1, N2);
            MIdx_k = MIdx(sel, :);

            PM1 = PC1(MIdx_k(:,1), :);    % Corresponding points from point cloud 1
            PM2 = PC2(MIdx_k(:,2), :);    % Corresponding points from point cloud 2              
            err1 = sum(sum((PM1 - PM2).^2, 2));
            
            [R, T] = icp_step(PM1, PM2);
            %Apply rotation and tranlation
            PM2 = ((R*PM2') + repmat(T', 1,N2))';

            %Estimate error
            err2 = sum(sum((PM1 - PM2).^2, 2));
            %fprintf('Ransac: %i, Err: %1.5f\n', k, err);
            imp = err1-err2/err1;
            
            if imp > E_b
               E_b = imp;
               R_b = R;
               T_b = T;
            end
        end
        
        fprintf('Itter: %i, Err: %1.5f \n', it, err2/N2);
        PC2 = ((R_b*PC2') + repmat(T_b', 1,Np2))';
        
        if err2 < 400
            break;
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
