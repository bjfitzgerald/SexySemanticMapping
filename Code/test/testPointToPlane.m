
addpath('../');

m = 200; % Number of points to use
noise_sigma = 0.01;
alpha = deg2rad(0);
beta = deg2rad(0);
gamma = deg2rad(10);

rotX = vrrotvec2mat([1 0 0 alpha]);
rotY = vrrotvec2mat([0 1 0 beta]);
rotZ = vrrotvec2mat([0 0 1 gamma]);
R = rotZ*rotY*rotX;
T = [0.0, 0.0, 0.5];
Noise = normrnd(0, noise_sigma, [m, 3]);

% N random points
P = rand(m, 3);
P = bsxfun(@minus, P, [0.5 0.5 0.0]);

% Normalize points to place them on a unit sphere
Pn = sqrt(sum(P.^2, 2));
P = P./repmat(Pn, [1, 3]);
P = P .* 10;

Nd = pcNormals(P);
Pd = P;

Ps = ((R*P') + repmat(T', 1,m))';
Ns = pcNormals(Ps);
%Ps = Ps + Noise;

%[R, T] = point2plane(Ps, Pd, Nd)
%Pm = ((R*Ps') + repmat(T, 1,m))';
%rotation = vrrotmat2vec(R)
%deg = rad2deg(rotation(4))
PC1 = struct('Points', Pd, 'Normals', Nd);
PC2 = struct('Points', Ps);
PC_new = icp(PC1, PC2, 10, 0);
Pm = PC_new.Points;

% Draw points
scatter3(Pd(:, 1), Pd(:, 2), Pd(:, 3), 50, [1 0 0], '.'); hold on;
scatter3(Ps(:, 1), Ps(:, 2), Ps(:, 3), 50, [0 0 1], '.');
scatter3(Pm(:, 1), Pm(:, 2), Pm(:, 3), 25, [0 1 0], '+');
xlabel('X'); ylabel('Y'); zlabel('Z');

% Draw normals
for i = 1:m
   p1 = Pd(i, :);
   p2 = p1+Nd(i, :);
   
   plot3([p1(1);p2(1)], [p1(2);p2(2)], [p1(3);p2(3)]);
end
hold off;
