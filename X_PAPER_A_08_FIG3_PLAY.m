clear all;close all;clc;
fittestCircuitIdx= 1;
numOfOutputs     = 2;
numOfInputs      = 2;
run('loadFIG3B.m')
fittestTextCircuit_3B = fittestTextCircuit;
fittestStructure_3B   = fittestStructure;
figure(1)
connectionMat_3B = drawCircuit_text(fittestStructure_3B,fittestTextCircuit_3B,numOfOutputs,1);
run('loadFIG3A.m')
fittestTextCircuit_3A = fittestTextCircuit;
fittestStructure_3A   = fittestStructure;
figure(2)
connectionMat_3A = drawCircuit_text(fittestStructure_3A,fittestTextCircuit_3A,numOfOutputs,1);
%%
[textCircuitsTemp_3Bmut,structureTemp_3Bmut] = mutation03(fittestTextCircuit_3B,fittestStructure_3B);
figure 
connectionMat_3Bmut = drawCircuit_text(structureTemp_3Bmut,textCircuitsTemp_3Bmut,numOfOutputs,1);

%%
[keepOutput,keepAllOutput] = solvePerturbedCircuit(numOfInputs,1,fittestTextCircuit(:,2:3),fittestStructure,0);
checkStatisticalIndependence(keepAllOutput,fittestStructure)
[fitness,faultTolerance] = calculateFitnessAndFaultTolerance(fittestTextCircuit,fittestStructure,numOfInputs,keepOutput,1);
%%
%%
[degeneracy,degeneracy2,degeneracyUB,redundancy,complexity,circuitSize] = calculateDegeneracy(keepOutput,keepAllOutput,fittestStructure);
[degeneracy3,redundancyMean] = calculateDegeneracyIncSize(keepOutput,keepAllOutput,fittestTextCircuit,fittestStructure);
% sanity check -> is redundancyMean(end) == redundancy?
%% %%%
drawCircuit_text(structureTemp,textCircuitsTemp,2,1)
[textCircuitsTemp_3Bmut,structureTemp_3Bmut] = mutation03(fittestTextCircuit,fittestStructure,2,0);

textCircuitsMutated