function [ PC ] = pcTransform( PC, R, T )

PC.Points = (R*PC.Points')';
PC.Points = bsxfun(@plus, PC.Points, T);

if(isfield(PC, 'Normals'))
    PC.Normals = (R*PC.Normals')';
end

end

