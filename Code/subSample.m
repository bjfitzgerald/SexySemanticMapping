function [ SI, PC_ ] = subSample( PC, N )

SI = zeros(N, 1);

nPts = size(PC.Points, 1);
nCluster = 10;
nSample = N/nCluster;

CIdx = kmeans(PC.Points, nCluster);
PIdx = (1:nPts)';

i_start = 0;
i_end = 0;
for i = 1:nCluster
    I_i = PIdx((CIdx==i));
    n_i = size(I_i, 1);
    n_s = min(n_i, nSample);
    
    sel = randperm(n_i, n_s)';
    i_start = i_end +1;
    i_end = i_start +n_s -1;
    
    SI(i_start:i_end, :) = I_i(sel);
end

SI = SI(1:i_end);
PC_ = struct('Points', PC.Points(SI, :));

if(isfield(PC, 'Colors'))
   PC_.Colors = PC.Colors(SI, :); 
end

if(isfield(PC, 'Normals'))
   PC_.Normals = PC.Normals(SI, :); 
end