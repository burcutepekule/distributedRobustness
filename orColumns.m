function [oredColumn] = orColumns(logicalArray)
oredColumn = zeros(size(logicalArray,1),1);
for k=1:size(logicalArray,2)
    oredColumn = or(oredColumn,logicalArray(:,k));
end
end

