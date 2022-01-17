function [truthTable] = printTruthTable(fittestStructure,keepAllOutput,opt)
numOfInputs   = fittestStructure(1,2);
numOfGates    = sum(fittestStructure(2:end-1,2));
numOfOutputs  = fittestStructure(end,2);
outputBinMat  = keepAllOutput(:,2:4);
C             = outputBinMat(:,2);
% Cj            = cat(1, C{:});
Cj            = cat(1, C(:));
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

if(opt==1)
    inputStates    = [inputGates';inputStates];
    middleStates   = [middleGates';middleStates];
    outputStates   = [outputGates';outputStates];
else
    

truthTable    = table(inputStates,middleStates,outputStates);

end

