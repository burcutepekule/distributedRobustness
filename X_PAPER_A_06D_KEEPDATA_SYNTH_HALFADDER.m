clear all;close all;clc;
fittestCircuitIdx= 1;
numOfOutputs     = 2;
numOfInputs      = 2;
%%
fittestTextCircuit = [];
run('loadHALFADDER')
fittestTextCircuit_1 = fittestTextCircuit;
fittestStructure_1   = fittestStructure;
figure
drawCircuit_text(fittestStructure_1,fittestTextCircuit_1,numOfOutputs,1)
[keepOutput_1,keepAllOutput_1] = solvePerturbedCircuit(numOfInputs,1,fittestTextCircuit_1(:,2:3),fittestStructure_1,0);
%%
[degeneracy_1,degeneracy2_1,degeneracyUB_1,redundancy_1,complexity_1,circuitSize_1] = calculateDegeneracyOption(keepOutput_1,keepAllOutput_1,numOfInputs,numOfOutputs,fittestStructure_1,0)

%%
