function [degeneracy,redundancyMean,degeneracyVec] = calculateDegeneracyIncSize(keepOutput,keepAllOutput,fittestTextCircuit,fittestStructure)

% calculates degeneracy according to Measures of degeneracy and redundancy in biological networks by GIULIO TONONI†, OLAF SPORNS, AND GERALD M. EDELMAN
% Equation 4
numOfInputs   = fittestStructure(1,2);
numOfGates    = sum(fittestStructure(2:end-1,2));
numOfOutputs  = fittestStructure(end,2);
outputMat     = keepAllOutput(:,2:4);
C             = outputMat(:,2);
Cj            = cat(1, C{:});
allGates      = Cj(1:(numOfInputs+numOfGates+numOfOutputs));
inputGates    = allGates(1:numOfInputs);
outputGates   = allGates(end-numOfOutputs+1:end);
middleGates   = setdiff(allGates,[outputGates;inputGates]);
circuitSize        = length(middleGates);
degeneracyVecMean  = [];
degeneracyVec2Mean = [];
IallVecMean        = [];
IsubsubHatVecMean  = [];
IsubVecKeep        = [];
for k=1:length(middleGates)
    disp(['Calculating for ' num2str(k) '-gate subcircuits...'])
    gates2use     = nchoosek(middleGates,k);
    degeneracyVec = [];
    degeneracyVec2= [];
    IallVec       = [];
    IsubsubHatVec = [];
    IsubVec       = [];
    redundancyAll = [];
    for i=1:size(gates2use,1)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if(size(gates2use,2)>1)
            gatesSubTemp    = gates2use(i,:);
        else
            gatesSubTemp    = gates2use(i);
        end
        gatesSubHatTemp = setdiff(middleGates,gatesSubTemp);
        
        idxSub          = reshape(find(ismember(Cj,gatesSubTemp)),length(gatesSubTemp),[])';
        idxOutput       = reshape(find(ismember(Cj,outputGates)),length(outputGates),[])';
        idxInput        = reshape(find(ismember(Cj,inputGates)),length(inputGates),[])';
        
        keepAllOutputSubset        = keepAllOutput(sort([idxInput(:);idxSub(:);idxOutput(:)]),:);
        fittestTextCircuitSubset   = fittestTextCircuit(sort([idxInput(1,:) idxSub(1,:)]),:); %calculate without output layer
        [fittestStructureSubset,~] = text2structureSubset(fittestTextCircuitSubset);
        fittestStructureSubset     = [fittestStructureSubset;fittestStructure(end,:)]; %add the output layer
        [degeneracy,degeneracy2,degeneracy3,degeneracyUB,redundancy,complexity,complexity2,circuitSize] =  calculateDegeneracy(keepOutput,keepAllOutputSubset,fittestStructureSubset);
        redundancyAll = [redundancyAll redundancy];
    end
    redundancyAll
    redundancyMean(k)=mean(redundancyAll);
end
degeneracyVec = [];
for k=1:length(middleGates)
    degeneracyVec(k) = (k/length(middleGates))*redundancyMean(end)-redundancyMean(k);
end
degeneracy = sum(degeneracyVec);
end
