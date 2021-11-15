function [pSubOtput] = probRows(subOutputMat)
[Mu,ia,ic] = unique(subOutputMat, 'rows', 'stable'); 
% Unique Values By Row, Retaining Original Order
h         = accumarray(ic, 1);  % Count Occurrences
maph      = h(ic); % Map Occurrences To ‘ic’ Values
pSubOtput = [subOutputMat, maph./length(maph)];
end

