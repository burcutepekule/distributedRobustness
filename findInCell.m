function [allFoundRows,allFoundCols] = findInCell(C,inp)
    allFoundCols=[];
    allFoundRows=[];
    for rr=1:size(C,1)
        for cc=1:size(C,2)
            if(find(C{rr,cc}==inp))
            allFoundCols=[allFoundCols,cc];
            allFoundRows=[allFoundRows,rr];
            end
        end
    end
end

