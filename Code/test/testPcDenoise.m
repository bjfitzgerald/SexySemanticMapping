addpath('../');

%% Generate Plane
mp = 500; % number of points on the plane
n = [0.5, 0.5, 1];
n = n/norm(n);
p = [0.5, 0.5, 0.5];

Xp = rand(mp, 3);
for i = 1:mp
   x = Xp(i, :);
   proj = dot(x-p, n) * n;
   Xp(i,:) = x-proj;
end

%% Geneate Sphere
ms = 500; % number of points on the sphere
c = [0.5, 0.3, 0.5];
r = 0.2;

Xs = rand(ms, 3);
for i = 1:ms
   x = Xs(i, :) - [0.5,0.5,0.5];
   x = x/norm(x);
   x = x*r;
   x = x + c;
   Xs(i,:) = x;
end

%% Geneate Noise
mn = 100; % number of noise points
Xn = rand(mn, 3);

Points = [Xp;Xs; Xn];
PC = struct('Points', Points);

fprintf('Denoise ');
tic;
PC = pcDenoise(PC, 10);
toc;

%% Draw Points
scatter3(Xp(:, 1), Xp(:, 2), Xp(:, 3), '.', 'blue'); hold on;
scatter3(Xs(:, 1), Xs(:, 2), Xs(:, 3), '.', 'blue');
scatter3(Xn(:, 1), Xn(:, 2), Xn(:, 3), '.', 'red');
scatter3(PC.Points(:, 1), PC.Points(:, 2), PC.Points(:, 3), '+', 'green');
hold off;