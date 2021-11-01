function [structure,allGates] = text2structure(textCircuits)
allGates = [];
for k=1:size(textCircuits,1)
    allGates = [allGates;cell2mat(textCircuits(k,3))'];
end
allGates = [allGates;cell2mat(textCircuits(:,2))];
allGates = sort(unique(allGates));

first_digits = floor(allGates/1000);
last_digits  = mod(allGates,10);
[first_digits_unique,f] = freq(first_digits);
structure = [];
for k=1:length(first_digits_unique)
    if(first_digits_unique(k)==0)
       structure = [structure; first_digits_unique(k) f(k)];
    else
        if(mod(f(k),3)==0)
            structure = [structure; first_digits_unique(k) f(k)/3];
        else %output layer
            structure = [structure; first_digits_unique(k) f(k)/2];
        end
    end
end

end

