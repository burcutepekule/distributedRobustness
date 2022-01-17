clear all;close all;clc;
if(isfile('4_GATE_EXAMPLE.mat'))
    load('4_GATE_EXAMPLE.mat')
else
    numOfInputs    = 2; %number of inputs
    numOfOutputs   = 2; %number of outputs
    numOfGates     = 4; %number of NAND gates to start with, excludes the output gates
    numOfRuns      = 5000; %number of trials
    numOfCandidateSolutions = 2500; %number of candidate solutions (generate here, this cannot be in a function since needs to be constant)
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
        [degeneracy,degeneracy2,degeneracy3,degeneracyUB,redundancy,complexity,complexity2,circuitSize,IsubOne,IallFinal,IsubMatKeep,IsubsubHatMatKeep,IsubHatMatKeep,HsubsubHatMatKeep,HsubMatKeep,HsubHatMatKeep,HJointMatKeep,HJointHatMatKeep,HJointAllMatKeep,HOutputMatKeep] = calculateDegeneracy(keepOutput,keepAllOutput,fittestStructure);
        
        degeneracyVals   = [degeneracyVals (degeneracy)];
        degeneracyUBVals = [degeneracyUBVals (degeneracyUB)];
        complexityVals   = [complexityVals (complexity)];
        redundancyVals   = [redundancyVals (redundancy)];
        IsubOneVals      = [IsubOneVals;IsubOne];
        IallFinalVals    = [IallFinalVals;IallFinal];
        
        IsubMatKeepVals(:,:,cIdx)       = IsubMatKeep;
        IsubsubHatMatKeepVals(:,:,cIdx) = IsubsubHatMatKeep;
        IsubHatMatKeepVals(:,:,cIdx)    = IsubHatMatKeep;
        HsubMatKeepVals(:,:,cIdx)       = HsubMatKeep;
        HsubsubHatMatKeepVals(:,:,cIdx) = HsubsubHatMatKeep;
        HsubHatMatKeepVals(:,:,cIdx)    = HsubHatMatKeep;
        HJointMatKeepVals(:,:,cIdx)     = HJointMatKeep;
        HJointHatMatKeepVals(:,:,cIdx)  = HJointHatMatKeep;
        HJointAllMatKeepVals(:,:,cIdx)  = HJointAllMatKeep;
        HOutputMatKeepVals(:,:,cIdx)    = HOutputMatKeep;
        
    end
    save('4_GATE_EXAMPLE.mat')
end

