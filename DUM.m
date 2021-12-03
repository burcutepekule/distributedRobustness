clear all;close all;clc;
runSeed(2);
%%
load('BEFORE_TOL_FITTEST_CIRCUIT_SEED_6_1.mat')
fittestCircuitIdx= 9;
numOfOutputs     = 2;
numOfInputs      = 3;
fittestTextCircuit = textCircuitsMutated(cell2mat(textCircuitsMutated(:,1))==fittestCircuitIdx,:);
fittestStructure   = structuresMutated{fittestCircuitIdx};
figure
drawCircuit_text(fittestStructure,fittestTextCircuit,numOfOutputs,1)
%%
textCircuitsTemp = fittestTextCircuit;
structureTemp    = fittestStructure;
[textCircuitsTemp_mutated,structureTemp_mutated] = mutation02(textCircuitsTemp,structureTemp)
%%
a=[   1   0   1   0
   1   0   1   1
   1   0   1   0
   0   1   0   1];
1-sum(sum(abs(a(:,1:2)-a(:,3:4))))/8
