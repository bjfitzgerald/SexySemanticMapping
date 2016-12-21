function [ PC ] = pcSmooth( PC, ns )

m = size(PC.Points, 1);
KD = KDTreeSearcher(PC.Points);

for i = 1:m
    
    p = PC.Points(i, :);
    n = PC.Normals(i, :);
    
    % Find neighborhood
    [I, D] = KD.rangesearch(p, ns);
    Kd = D{1};
    Ki = I{1};
    Kn = PC.Normals(Ki, :);    %Neighborhood normals    
    Kp = PC.Points(Ki, :);    %Neighborhood points
    
    n_ = mean(Kn);
    n_ = n_ / norm(n_);
    PC.Normals(i, :) = n_;
    
    %{
    k = numel(Ki);
    % Find all points on this plane
    for j = 2:k
        ki = Ki(j);
        t = 1 - (Kd(j)/max(Kd));
        x = Kp(j, :);
        d = dot(x-p, n_); % distance to plane
        x = x + (n*d*0.1);
        PC.Points(ki, :) = x;
    end
    %}
end

end

