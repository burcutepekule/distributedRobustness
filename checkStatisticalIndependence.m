function [SI] = checkStatisticalIndependence(keepAllOutput,fittestStructure)
numOfInputs   = fittestStructure(1,2);
numOfGates    = sum(fittestStructure(2:end-1,2));
numOfOutputs  = fittestStructure(end,2);
outputBinMat  = keepAllOutput(:,2:4);
C             = outputBinMat(:,2);
Cj            = cat(1, C{:});
allGates      = Cj(1:(numOfInputs+numOfGates+numOfOutputs));
inputGates    = allGates(1:numOfInputs);
outputGates   = allGates(end-numOfOutputs+1:end);
middleGates   = setdiff(allGates,[outputGates;inputGates]);

idxInput        = reshape(find(ismember(Cj,inputGates)),length(inputGates),[])';
idxMiddle       = reshape(find(ismember(Cj,middleGates)),length(middleGates),[])';
idxOutput       = reshape(find(ismember(Cj,outputGates)),length(outputGates),[])';

inputStates    = reshape(double(cell2mat(outputBinMat(idxInput,3))),[],length(inputGates));% [outputMat(idxSub(:,1),3) outputMat(idxSub(:,2),3)] %sanity check
middleStates   = reshape(double(cell2mat(outputBinMat(idxMiddle,3))),[],length(middleGates));
outputStates   = reshape(double(cell2mat(outputBinMat(idxOutput,3))),[],length(outputGates));

pGates    = probRows(middleStates);
pOutput   = probRows(outputStates);
pJointAll = probRows([middleStates outputStates]);


%check statistical independence for each element
holdsVec = [];
for i=1:size(middleStates,2)
    jointStates= [middleStates(:,i) outputStates];
    pGateTemp  = probRows(jointStates(:,1));
    pOutTemp   = probRows(jointStates(:,2:end));
    pJointTemp = probRows(jointStates);
    holdsVec = [holdsVec sum(abs(pGateTemp(:,end).*pOutTemp(:,end)-pJointTemp(:,end)))];
end

%check statistical independence for the whole circuit
jointStates= [middleStates outputStates];
pGateTemp  = probRows(jointStates(:,1:size(middleStates,2)));
pOutTemp   = probRows(jointStates(:,(size(middleStates,2)+1):end));
pJointTemp = probRows(jointStates);
holdsVec = [holdsVec sum(abs(pGateTemp(:,end).*pOutTemp(:,end)-pJointTemp(:,end)))];

if(any(holdsVec))
    SI = 0;
else
    SI = 1;
end

end

