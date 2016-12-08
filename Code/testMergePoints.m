
P1 = [0.2 0.5 0.2; 0.1 0.1 0.1; 0.9 0.9 0.5];
C1 = [1 0 0; 0 1 0; 0 0 1];

Np = 10;
P2 = rand(Np, 3);
C2 = repmat([0.5 0.5 0.5], [Np,1]);

figure,
scatter3(P1(:,1), P1(:,2), P1(:,3), 20, C1, 'filled'); hold on;
scatter3(P2(:,1), P2(:,2), P2(:,3), 20, C2, 'filled');
hold off;

Cb = repmat([0.0 0.0 0.0], [Np,1]);

[P3, C3] = mergePoints(P1, C1, P2, C2, 0.4);

figure,
scatter3(P2(:,1), P2(:,2), P2(:,3), 10, Cb, 'filled'); hold on;
scatter3(P3(:,1), P3(:,2), P3(:,3), 20, C3, 'filled');
hold off;