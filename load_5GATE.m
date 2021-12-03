clear all;close all;clc;
if(isfile('5_GATE_EXAMPLE.mat'))
    load('5_GATE_EXAMPLE.mat')
else
    
    numOfInputs    = 2; %number of inputs
    numOfOutputs   = 2; %number of outputs
    rng(77) % gives the output in the papeer
    outputMat      = randn([2^numOfInputs,numOfOutputs])>0; %Random Input - Output truthtable
    numOfGates     = 5; %number of NAND gates to start with, excludes the output gates
    numOfRuns      = 5000; %number of trials
    numOfCandidateSolutions = 500; %number of candidate solutions (generate here, this cannot be in a function since needs to be constant)
    [keepCircuits,keepStructure,keepNumOfLayers,textCircuits,strAllText] = generateRandomCircuits(numOfInputs,numOfOutputs,numOfGates,numOfRuns,numOfCandidateSolutions);
    %%
    degeneracyVals = [];
    complexityVals = [];
    redundancyVals = [];
    IsubOneVals    = [];
    IallFinalVals  = [];
    
    for cIdx=1:numOfCandidateSolutions
        cIdx
        fittestStructure     = keepStructure{cIdx};
        fittestTextCircuit   = textCircuits(cell2mat(textCircuits(:,1))==cIdx,:);
        [keepOutput,keepAllOutput]   = solvePerturbedCircuit(1,fittestTextCircuit(:,2:3),fittestStructure,0);
        [degeneracy,degeneracy2,degeneracy3,degeneracyUB,redundancy,complexity,complexity2,circuitSize,IsubOne,IallFinal] = calculateDegeneracy(keepOutput,keepAllOutput,fittestStructure);
        
        degeneracyVals = [degeneracyVals (degeneracy)];
        complexityVals = [complexityVals (complexity)];
        redundancyVals = [redundancyVals (redundancy)];
        IsubOneVals    = [IsubOneVals;IsubOne];
        IallFinalVals  = [IallFinalVals;IallFinal];
    end
    save('5_GATE_EXAMPLE.mat')
end

