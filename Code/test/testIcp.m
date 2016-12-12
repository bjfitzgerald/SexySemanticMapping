
addpath('../');

N = 20;
noise_sigma = 0.01;
alpha = deg2rad(0);
beta = deg2rad(10);
gamma = deg2rad(10);

rotX = vrrotvec2mat([1 0 0 alpha]);
rotY = vrrotvec2mat([0 1 0 beta]);
rotZ = vrrotvec2mat([0 0 1 gamma]);

R = rotZ*rotY*rotX;
T = [0.0, 0.0, 0.1];
Noise = normrnd(0, noise_sigma, [N, 3]);

X1 = rand(N, 3);
X2 = ((R*X1') + repmat(T', 1,N))';
X2 = X2 + Noise;

%{
Mu1 = mean(X1);
Mu2 = mean(X2);
X1 = bsxfun(@minus, X1, Mu1);
X2 = bsxfun(@minus, X2, Mu2);
W = X2'*X1;

[U, ~, V] = svd(W);
R_ = V*diag([1 1 det(U*V')])*U';
Mu2r = (R_ * Mu2')';
Mu1r = (R_ * Mu1')';
T_ = Mu1 - (R_ * Mu2')';

X3 = X2;
X3 = bsxfun(@plus, X3, Mu2);
X3 = ((R_*X3') + repmat(T_', 1,N))';

X1 = bsxfun(@plus, X1, Mu1);
X2 = bsxfun(@plus, X2, Mu2);

%}

X3 = icp(X1, X2);

%err1 = sum(sum((X1 - X2).^2, 2))
%err2 = sum(sum((X1 - X3).^2, 2))

%rotation = vrrotmat2vec(R_);
%deg = rad2deg(rotation(4));

scatter3(X1(:,1), X1(:,2), X1(:,3), '+', 'blue'); hold on;
scatter3(X2(:,1), X2(:,2), X2(:,3), '+', 'red');
%scatter3(Mu1(1), Mu1(2), Mu1(3), 'o', 'blue');
%scatter3(Mu2(1), Mu2(2), Mu2(3), 'o', 'red');
%scatter3(Mu1r(1), Mu1r(2), Mu1r(3), '.', 'blue');
%scatter3(Mu2r(1), Mu2r(2), Mu2r(3), '.', 'red');

scatter3(X3(:,1), X3(:,2), X3(:,3), '.', 'green');
xlabel('X'); ylabel('Y'); zlabel('Z');
%xlim([-1, 1]); ylim([-1, 1]); zlim([-1, 1]); 
hold off