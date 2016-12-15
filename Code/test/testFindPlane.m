addpath('../');

%% Generate Plane
mp = 100; % number of points on the plane
n = [0.5, 0.5, 1];
n = n/norm(n);
p = [0.5, 0.1, 0];

Xp = rand(mp, 3);
for i = 1:mp
   x = Xp(i, :);
   proj = dot(x-p, n) * n;
   Xp(i,:) = x-proj;
end

%% Geneate Sphere
ms = 100; % number of points on the sphere
c = [0.5, 0.1, 0];
r = 0.2;

Xs = rand(ms, 3);
for i = 1:ms
   x = Xs(i, :) - [0.5,0.5,0.5];
   x = x/norm(x);
   x = x*r;
   x = x + c;
   Xs(i,:) = x;
end

Points = [Xp;Xs];
PC = struct('Points', Points);
Idx = findPlane(PC, 10, 0.05);

Pp = Points(Idx, :);

%% Draw Points
scatter3(Xp(:, 1), Xp(:, 2), Xp(:, 3), '.', 'red'); hold on;
scatter3(Xs(:, 1), Xs(:, 2), Xs(:, 3), '.', 'blue');
scatter3(Pp(:, 1), Pp(:, 2), Pp(:, 3), '+', 'green');
hold off;