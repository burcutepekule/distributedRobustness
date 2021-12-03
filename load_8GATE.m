clear all;close all;clc;
if(isfile('8_GATE_EXAMPLE.mat'))
    load('8_GATE_EXAMPLE.mat')
else
    numOfInputs    = 2; %number of inputs
    numOfOutputs   = 2; %number of outputs
    numOfGates     = 8; %number of NAND gates to start with, excludes the output gates
    numOfRuns      = 1000; %number of trials
    numOfCandidateSolutions = 100; %number of candidate solutions (generate here, this cannot be in a function since needs to be constant)
    [keepCircuits,keepStructure,keepNumOfLayers,textCircuits,strAllText] = generateRandomCircuits(numOfInputs,numOfOutputs,numOfGates,numOfRuns,numOfCandidateSolutions);
    %%
    degeneracyVals  = [];
    degeneracyUBVals= [];
    complexityVals  = [];
    redundancyVals  = [];
    IsubOneVals     = [];
    IallFinalVals   = [];
    IsubMatKeepVals = [];
    IsubsubHatMatKeepVals = [];
    IsubHatMatKeepVals    = [];
    for cIdx=1:numOfCandidateSolutions
        cIdx
        fittestStructure     = keepStructure{cIdx};
        fittestTextCircuit   = textCircuits(cell2mat(textCircuits(:,1))==cIdx,:);
        [keepOutput,keepAllOutput]   = solvePerturbedCircuit(1,fittestTextCircuit(:,2:3),fittestStructure,0);
        [degeneracy,degeneracy2,degeneracy3,degeneracyUB,redundancy,complexity,complexity2,circuitSize,IsubOne,IallFinal,IsubMatKeep,IsubsubHatMatKeep,IsubHatMatKeep] = calculateDegeneracy(keepOutput,keepAllOutput,fittestStructure);
        
        degeneracyVals   = [degeneracyVals (degeneracy)];
        degeneracyUBVals = [degeneracyUBVals (degeneracyUB)];
        complexityVals   = [complexityVals (complexity)];
        redundancyVals   = [redundancyVals (redundancy)];
        IsubOneVals      = [IsubOneVals;IsubOne];
        IallFinalVals    = [IallFinalVals;IallFinal];
        IsubMatKeepVals(:,:,cIdx)       = IsubMatKeep;
        IsubsubHatMatKeepVals(:,:,cIdx) = IsubsubHatMatKeep;
        IsubHatMatKeepVals(:,:,cIdx)    = IsubHatMatKeep;
        
    end
    save('8_GATE_EXAMPLE.mat')
end

