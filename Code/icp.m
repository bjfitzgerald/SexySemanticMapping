function [ P, R, T ] = icp( PC1, PC2, NItter )
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

    P = PC2;
    %P = ransac_icp(PC1, PC2, NItter, tol);
    %P = p2p_icp(PC1, PC2, NItter, tol);
    
    [P.Points, R, T] = icp_rejectDist(PC1, PC2, NItter);
    %[P.Points, R, T] = icp_useAll(PC1, PC2, NItter);
    
end

%% ICP using every point
function [ Pm, R, T ] = icp_useAll(PC1, PC2, NItter)

Ps = PC2.Points;
Pd = PC1.Points;
Nd = PC1.Normals;

m = size(Ps, 1);
Pm = Ps;

R = eye(3);
T = zeros(1, 3);

for it = 1:NItter
	[Ri, Ti] = point2plane_step(Pm, Pd, Nd);
   
    %{
    % display corresponding points
    scatter3(Pd(:, 1), Pd(:, 2), Pd(:, 3), '.', 'blue'); hold on;
    scatter3(Pm(:, 1), Pm(:, 2), Pm(:, 3), '.', 'red');
    hold off;
    pause    
    %}
    
	Pm = ((Ri*Pm') + repmat(Ti', 1,m))';
    
    err = point2plane_error(Pm, Pd, Nd);
    fprintf('Itter: %i, Err: %1.5f \n', it, err);
    
    R = R*Ri;
    T = T+Ti;
end

end

%% Point to Point
function [ P, R, T ] = icp_rejectDist(PC1, PC2, NItter)
    KD = KDTreeSearcher(PC1.Points);
    
    R = eye(3);
    T = zeros(1, 3);
    err_last = 0;
    err_last2 = 0;
    
    for it = 1:NItter
        [Idx, MD] = KD.knnsearch(PC2.Points);
        MIdx = [Idx, (1:numel(Idx))'];

        %% Reject points that are too far apart
        Sigma = std(MD);
        sel = MD < 1*Sigma;
        MIdx = MIdx(sel, :);

        Pd = PC1.Points(MIdx(:,1), :);    % Corresponding points from point cloud 1
        Nd = PC1.Normals(MIdx(:,1), :);
        Ps = PC2.Points(MIdx(:,2), :);    % Corresponding points from point cloud 2    
        N = size(Pd, 1);
        
        
        %{
        % display corresponding points
        scatter3(Pd(:, 1), Pd(:, 2), Pd(:, 3), '.', 'blue'); hold on;
        scatter3(Ps(:, 1), Ps(:, 2), Ps(:, 3), '.', 'red');
        hold off;
        pause
        %}
        
        
        [Ri, Ti] = point2plane_step(Ps, Pd, Nd);
        %Apply rotation and tranlation
        Ps = ((Ri*Ps') + repmat(Ti', 1,N))';
        %Estimate error
        err = point2plane_error(Ps, Pd, Nd);
        %fprintf('Itter: %i, Err: %1.5f \n', it, err);
        
        PC2.Points = ((Ri*PC2.Points') + repmat(Ti', 1,size(PC2.Points,1)))';
        
        R = R*Ri;
        T = T+Ti;
        
        if(abs(err-err_last) < 10^-5)
           break; 
        end
        if(abs(err-err_last2) < 10^-5) % avoid getting stuck in loop
           break; 
        end        
        err_last2 = err_last;
        err_last = err;
    end
    fprintf('ICP err: %1.5f \n', err);
    P = PC2.Points;
end


%% Point to Point step
function [R, T] = point2point_step(P1, P2)
    Mu1 = mean(P1);
    Mu2 = mean(P2);
    Q1 = bsxfun(@minus, P1, Mu1);
    Q2 = bsxfun(@minus, P2, Mu2);
    H = Q2'*Q1;

    [U, ~, V] = svd(H);
    R = V*diag([1 1 det(U*V')])*U';
    T = Mu1 - (R * Mu2')';

end

%% Point to Plane step
function [R, T] = point2plane_step(Ps, Pd, Nd)
% Ps = Source surface points
% Pd = Destination surface points
% Nd = Destination surface normals
N = size(Ps, 1);

b = zeros(6, 1);
C = zeros(6, 6);

for i = 1:N
    p = Ps(i, :);
    q = Pd(i, :);
    n = Nd(i, :);
    c = cross(p, n);
   
	C_i = [(c(1)*c(1)), (c(1)*c(2)), (c(1)*c(3)), (c(1)*n(1)), (c(1)*n(2)), (c(1)*n(3));...
          (c(2)*c(1)), (c(2)*c(2)), (c(2)*c(3)), (c(2)*n(1)), (c(2)*n(2)), (c(2)*n(3));...
          (c(3)*c(1)), (c(3)*c(2)), (c(3)*c(3)), (c(3)*n(1)), (c(3)*n(2)), (c(3)*n(3));...
          (n(1)*c(1)), (n(1)*c(2)), (n(1)*c(3)), (n(1)*n(1)), (n(1)*n(2)), (n(1)*n(3));...
          (n(2)*c(1)), (n(2)*c(2)), (n(2)*c(3)), (n(2)*n(1)), (n(2)*n(2)), (n(2)*n(3));...
          (n(3)*c(1)), (n(3)*c(2)), (n(3)*c(3)), (n(3)*n(1)), (n(3)*n(2)), (n(3)*n(3))...
       ];
	C = C+C_i;
    
    d = dot(p-q, n);
	b_i = [(c(1) * d);...
          (c(2) * d);...
          (c(3) * d);...
          (n(1) * d);...
          (n(2) * d);...
          (n(3) * d)...
    ];
    b = b+b_i;
end

X = C\-b;
rotX = vrrotvec2mat([1 0 0 X(1)]);
rotY = vrrotvec2mat([0 1 0 X(2)]);
rotZ = vrrotvec2mat([0 0 1 X(3)]);
R = rotZ*rotY*rotX;
T = X(4:6)';

end

function [ err ] = point2plane_error(Ps, Pd, Nd)

N = size(Ps, 1);
err = 0;

for i = 1:N
   p = Ps(i, :);
   q = Pd(i, :);
   n = Nd(i, :);
   c = cross(p, n);
   
   err = err + (dot((p-q), n) + dot([0 0 0], n) + dot([0 0 0], c))^2;
end

end