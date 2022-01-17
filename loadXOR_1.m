clear fittestTextCircuit fittestStructure
close all;clc;
if(isfile('XOR_1_EXAMPLE.mat'))
    load('XOR_1_EXAMPLE.mat')
else
    fittestTextCircuit{1,1} = 1;
    fittestTextCircuit{2,1} = 1;
    fittestTextCircuit{3,1} = 1;
    fittestTextCircuit{4,1} = 1;
    fittestTextCircuit{5,1} = 1;
    fittestTextCircuit{6,1} = 1;
    
    fittestTextCircuit{1,2} = 13;
    fittestTextCircuit{2,2} = 23;
    fittestTextCircuit{3,2} = 1013;
    fittestTextCircuit{4,2} = 1023;
    fittestTextCircuit{5,2} = 2013;
    fittestTextCircuit{6,2} = 2023;
    
    fittestTextCircuit{1,3} = [1011,1012,2021];
    fittestTextCircuit{2,3} = [1021,1022,2012];
    fittestTextCircuit{3,3} = [2011];
    fittestTextCircuit{4,3} = [2022];
    fittestTextCircuit{5,3} = [3011];
    fittestTextCircuit{6,3} = [3012];
    
    fittestStructure = [0 2;1 2;2 2;3 1];
    
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
    
    [keepOutput,keepAllOutput]   = solvePerturbedCircuit(1,fittestTextCircuit(:,2:3),fittestStructure,0);
    [degeneracy,degeneracy2,degeneracy3,degeneracyUB,redundancy,complexity,complexity2,circuitSize,IsubOne,IallFinal,IsubMatKeep,IsubsubHatMatKeep,IsubHatMatKeep,HsubsubHatMatKeep,HsubMatKeep,HsubHatMatKeep,HJointMatKeep,HJointHatMatKeep,HJointAllMatKeep,HOutputMatKeep] = calculateDegeneracy(keepOutput,keepAllOutput,fittestStructure);
    
    degeneracyVals   = [degeneracyVals (degeneracy)];
    degeneracyUBVals = [degeneracyUBVals (degeneracyUB)];
    complexityVals   = [complexityVals (complexity)];
    redundancyVals   = [redundancyVals (redundancy)];
    IsubOneVals      = [IsubOneVals;IsubOne];
    IallFinalVals    = [IallFinalVals;IallFinal];
    
    cIdx = 1;
    
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
    save('XOR_1_EXAMPLE.mat')
    
end