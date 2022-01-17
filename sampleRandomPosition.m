function [rcPick] = sampleRandomPosition(maskMat)
[r,c]  = find(maskMat);
rcMat  = [r,c];
rcPick = rcMat(randsample(size(rcMat,1),1),:);
end

