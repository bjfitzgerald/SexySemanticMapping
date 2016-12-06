
N = 20;

alpha = deg2rad(0);
beta = deg2rad(0);
gamma = deg2rad(10);

rotX = vrrotvec2mat([1 0 0 alpha]);
rotY = vrrotvec2mat([0 1 0 beta]);
rotZ = vrrotvec2mat([0 0 1 gamma]);

%rotX = [1, 0, 0; 0 cos(alpha) sin(alpha); 0 -sin(alpha) cos(alpha)];
%rotY = [cos(beta), 0, -sin(beta); 0, 1, 0; sin(beta), 0, cos(beta)];
%rotZ = [cos(gamma), sin(gamma), 0; -sin(gamma), cos(gamma), 0; 0, 0, 1];

R = rotZ*rotY*rotX
T = [0.0, 0.0, 0.0];
Noise = normrnd(0, 0.01, [N, 3]);

%X = rand(N, 3);
X1 = X;
X1 = bsxfun(@times, X1, [1, 1, 0.0]);
%X1 = [0.5, 0, -0.1; -0.5, 0, -0.1; 0, 0.5, 0.1; 0, -0.5, 0.1]
%X1 = bsxfun(@minus, X1, [0.5, 0.5, 0]);

X2 = zeros(size(X1));
for i = 1:N
   p = X1(i, :);
   p = (R*p')' + T;
   X2(i, :) = p;
end
%X2 = X2 + Noise;

%scatter3(X1(:,1), X1(:,2), X1(:,3), '.', 'magenta'); hold on;

Mu1 = mean(X1);
Mu2 = mean(X2);
X1 = bsxfun(@minus, X1, Mu1);
X2 = bsxfun(@minus, X2, Mu2);
W = X1'*X2;

[U, S, V] = svd(W)
R_ = U*V
%R_ = V'*U'
Mu2r = (R_ * Mu2')';
Mu1r = (R_ * Mu1')';
T_ = Mu1 - (R_ * Mu2')'
%T_ = Mu1r - Mu2r
%T_ = Mu1 - Mu2

X3 = zeros(size(X2));
for i = 1:N
   p = X2(i, :);
   p = (R_*p')';
   X3(i, :) = p;
end
%X3 = bsxfun(@plus, X3, Mu1);
%X3 = bsxfun(@plus, X3, T_);

rotation = vrrotmat2vec(R_)
deg = rad2deg(rotation(4))

%X1 = bsxfun(@plus, X1, Mu1);
%X2 = bsxfun(@plus, X2, Mu2);
scatter3(X1(:,1), X1(:,2), X1(:,3), '+', 'blue'); hold on;
scatter3(X2(:,1), X2(:,2), X2(:,3), '+', 'red');
scatter3(Mu1(1), Mu1(2), Mu1(3), 'o', 'blue');
scatter3(Mu2(1), Mu2(2), Mu2(3), 'o', 'red');
scatter3(Mu1r(1), Mu1r(2), Mu1r(3), '.', 'blue');
scatter3(Mu2r(1), Mu2r(2), Mu2r(3), '.', 'red');

scatter3(X3(:,1), X3(:,2), X3(:,3), '.', 'green');
xlim([-1, 1]); xlabel('X');
ylim([-1, 1]); ylabel('Y');
zlim([-1, 1]); zlabel('Z');
hold off