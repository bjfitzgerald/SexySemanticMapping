addpath('../');

PC = s44.Model;
%[~,PC] = subSample(PC, 5000, 5, 'normal');
drawModel(PC, 'Before', 'normal');

PC = pcSmooth(PC, 10);

drawModel(PC, 'After', 'normal');