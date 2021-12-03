function [fitness,faultTolerance] = calculateFitnessAndFaultTolerance2(textCircuits,keepStructure,outputMat,keepAllOutput,calcFaultTol)
fitness                = [];
faultTolerance         = [];
candidateSolutions     = unique(cell2mat(textCircuits(:,1)))';
numOfCandidateSolutions= length(candidateSolutions);

numOfInputs   = keepStructure(1,2);
numOfGates    = sum(keepStructure(2:end-1,2));
numOfOutputs  = keepStructure(end,2);
outputMatText = keepAllOutput(:,2:4);
C             = outputMatText(:,2);
Cj            = cat(1, C{:});
allGates      = Cj(1:(numOfInputs+numOfGates+numOfOutputs));
allGates      = str2double(extractAfter(allGates,'i_'));


for tempCircuitIdx=candidateSolutions %for each circuit, calculate fitness and fault tolerance
    tempCircuit   = textCircuits(cell2mat(textCircuits(:,1))==tempCircuitIdx,:);
    tempCircuit   = tempCircuit(:,2:3);
    if(numOfCandidateSolutions>1)
        tempStructure = keepStructure{tempCircuitIdx};
    else
        tempStructure = keepStructure;
    end
    % fitness of the cth circuit
    disp(['Calculating fitness for circuit ' num2str(tempCircuitIdx)])
    [keepOutputNotPerturbed,~] = solvePerturbedCircuit(numOfInputs,tempCircuitIdx,tempCircuit,tempStructure,0);
    fitness(1,tempCircuitIdx)  = 1-reshape(mean(mean(abs(keepOutputNotPerturbed-outputMat),1),2),1,[]);
    % fault tolerance of the cth circuit
    if(calcFaultTol==1)
%         allOutputGates        = cell2mat(tempCircuit(:,1));
%         allOutputGatesPerturb = allOutputGates(floor(allOutputGates./1000)>0);
        allOutputGatesPerturb = allGates;
        keepPerturbedOutput   = [];
        for outputGate2Perturb = allOutputGatesPerturb'
            disp(['Calculating fault tolerance for circuit ' num2str(tempCircuitIdx) ', perturbing output ' num2str(outputGate2Perturb)])
            [keepOutputPerturbed,~]= solvePerturbedCircuit(numOfInputs,tempCircuitIdx,tempCircuit,tempStructure,outputGate2Perturb);
            keepPerturbedOutput    = [keepPerturbedOutput;keepOutputPerturbed];
        end
        faultTolerance(1,tempCircuitIdx) = 1-reshape(mean(mean(abs(repmat(keepOutputNotPerturbed,length(allOutputGatesPerturb),1)-keepPerturbedOutput),1),2),1,[]);
    end
end
end

