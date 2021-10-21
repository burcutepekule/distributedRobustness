function [strlookFor] = circuit2str(lookFor)
strlookFor = [];
for r=1:size(lookFor,1)
    for c=1:size(lookFor,2)
        strAdd  = strjoin(string(sort(lookFor{r,c})));
        strlookFor = strcat(strlookFor,strAdd);
    end
end
end

