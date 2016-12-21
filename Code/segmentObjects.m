function [ LIdx ] = segmentObjects( PC, ns )
% Given a point cloud PC, will segment the model into multible labels
% If point PC_i has label 4, LIdx_i = 4

if nargin < 2
   ns = 20; % neighborhood size
end

m = size(PC.Points, 1);
KD = KDTreeSearcher(PC.Points);
LIdx = zeros(m, 1);
Idx = (1:m)';

P = PC.Points;
N = PC.Normals;

Label_count = 1;
while sum(LIdx==0) > 3000
    l = Label_count;
    Label_count = Label_count+1;
    fprintf('L: %i, P: %i \n', l, numel(Idx));
    
    i = randperm(numel(Idx), 1);
    i = Idx(i);
    n = N(i, :);
    
    LIdx(i) = l;
    Frontier = {i};
    %Frontier = num2cell(Idx);
    while numel(Frontier) > 0
        %fprintf('Frontier: %i \n', numel(Frontier));

        fi = Frontier{1};
        Frontier(1) = [];
        p = P(fi, :);
        % Find neighborhood
        [I, D] = KD.rangesearch(p, 10);
        %[Ki, ~]= KD.knnsearch(P, 'k', 3);
        Kd = D{1};
        Ki = I{1};
        Kp = P(Ki, :);    %Neighborhood points
        Kn = N(Ki, :);    %Neighborhood normals

        k = numel(Ki);
        sel = false(k, 1);
        for j = 1:k
            c = 1-((dot(n, Kn(j, :))+1)/2);
            w = weight(p, Kp(j, :), n, Kn(j, :));
            d = Kd(j)/max(Kd);
            sel(j) = w < 0.002;
        end
        
        Kfrontier = Ki(LIdx(Ki) == 0 & sel);
        if numel(Kfrontier) > 0
            LIdx(Kfrontier) = l;
            Frontier = [Frontier; num2cell(Kfrontier')];
        end
        
        Idx = find(LIdx==0);
    end
end
LIdx(Idx) = l+1;

end

function [ w ] = weight( p1, p2, n1, n2 )
    d = dot((p2-p1), n2);
    
    if d > 0
       w = (1 - dot(n1, n2))^2;
    else
        w = (1 - dot(n1, n2)) *2;
    end
end