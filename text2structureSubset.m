function [structure,allGates] = text2structureSubset(textCircuitsSubset)
allGates = [];
for k=1:size(textCircuitsSubset,1)
    allGates = [allGates;cell2mat(textCircuitsSubset(k,2))'];
end
allGates = sort(unique(allGates));

first_digits = floor(allGates/1000);
last_digits  = mod(allGates,10);
[first_digits_unique,f] = freq(first_digits);
structure = [];
for k=1:length(first_digits_unique)
    structure = [structure; first_digits_unique(k) f(k)];
end

end

