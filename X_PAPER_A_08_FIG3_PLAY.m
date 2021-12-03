clear all;close all;clc;
fittestCircuitIdx= 1;
numOfOutputs     = 2;
numOfInputs      = 2;
run('loadFIG3A.m')
fittestTextCircuit_3A = fittestTextCircuit;
fittestStructure_3A   = fittestStructure;
figure(2)
connectionMat_3A = drawCircuit_text(fittestStructure_3A,fittestTextCircuit_3A,numOfOutputs,1);
[keepOutput_3A,keepAllOutput_3A] = solvePerturbedCircuit(1,fittestTextCircuit_3A(:,2:3),fittestStructure_3A,0);
truthTable_3A=printTruthTable(fittestStructure_3A,keepAllOutput_3A,0);
[degeneracy_3Aa,degeneracy_3Ab,degeneracy3Ac,degeneracy_3AUB,redundancy_3A,complexity_3Aa,complexity3Ab,circuitSize_3A] = calculateDegeneracy(keepOutput_3A,keepAllOutput_3A,fittestStructure_3A);
[fitness_3A,faultTolerance_3A] = calculateFitnessAndFaultTolerance(fittestTextCircuit_3A,fittestStructure_3A,keepOutput_3A,1);

%%
clear all;close all;clc;
fittestCircuitIdx= 1;
numOfOutputs     = 2;
numOfInputs      = 2;
run('loadFIG3B.m')
fittestTextCircuit_3B = fittestTextCircuit;
fittestStructure_3B   = fittestStructure;
figure(2)
connectionMat_3B = drawCircuit_text(fittestStructure_3B,fittestTextCircuit_3B,numOfOutputs,1);
[keepOutput_3B,keepAllOutput_3B] = solvePerturbedCircuit(1,fittestTextCircuit_3B(:,2:3),fittestStructure_3B,0);
truthTable_3B=printTruthTable(fittestStructure_3B,keepAllOutput_3B,0);
%%
[degeneracy_3Ba,degeneracy_3Bb,degeneracy3Bc,degeneracy_3BUB,redundancy_3B,complexity_3Ba,complexity3Bb,circuitSize_3B] = calculateDegeneracy(keepOutput_3B,keepAllOutput_3B,fittestStructure_3B);

%%
[degeneracy_3Aa2,degeneracy_3Ab2,degeneracy3Ac2,degeneracy_3AUB2,redundancy_3A2,complexity_3A2,circuitSize_3A2] = calculateDegeneracy2(keepOutput_3A,keepAllOutput_3A,fittestStructure_3A);
%%
% [degeneracy_3Ac,redundancyMean_3A] = calculateDegeneracyIncSize(keepOutput_3A,keepAllOutput_3A,fittestTextCircuit_3A,fittestStructure_3A);
[fitness_3A,faultTolerance_3A] = calculateFitnessAndFaultTolerance(fittestTextCircuit_3A,fittestStructure_3A,keepOutput_3A,1);
%%
run('loadFIG3B.m')
fittestTextCircuit_3B = fittestTextCircuit;
fittestStructure_3B   = fittestStructure;
figure(1)
connectionMat_3B = drawCircuit_text(fittestStructure_3B,fittestTextCircuit_3B,numOfOutputs,1);
[keepOutput_3B,keepAllOutput_3B] = solvePerturbedCircuit(1,fittestTextCircuit_3B(:,2:3),fittestStructure_3B,0);
[degeneracy_3Ba,degeneracy_3Bb,~,redundancy_3B,complexity_3B,circuitSize_3B] = calculateDegeneracy(keepOutput_3B,keepAllOutput_3B,fittestStructure_3B);
% [degeneracy_3Bc,redundancyMean_3B] = calculateDegeneracyIncSize(keepOutput_3B,keepAllOutput_3B,fittestTextCircuit_3B,fittestStructure_3B);
[fitness_3B,faultTolerance_3B] = calculateFitnessAndFaultTolerance(fittestTextCircuit_3B,fittestStructure_3B,keepOutput_3B,1);
%%
% [degeneracy_3Aa degeneracy_3Ab degeneracy_3Ac redundancy_3A circuitSize_3A]
% [degeneracy_3Ba degeneracy_3Bb degeneracy_3Bc redundancy_3B circuitSize_3B]
[degeneracy_3Aa degeneracy_3Ab  redundancy_3A circuitSize_3A]
[degeneracy_3Ba degeneracy_3Bb  redundancy_3B circuitSize_3B]

truthTable_3A=printTruthTable(fittestStructure_3A,keepAllOutput_3A,0)
truthTable_3B=printTruthTable(fittestStructure_3B,keepAllOutput_3B,0)

[degeneracy_3Aa,degeneracy_3Ab,degeneracy_3AUB,redundancy_3A,complexity_3A,circuitSize_3A] = calculateDegeneracy2(keepOutput_3A,keepAllOutput_3A,fittestStructure_3A);
[degeneracy_3Ba,degeneracy_3Bb,degeneracy_3BUB,redundancy_3B,complexity_3B,circuitSize_3B] = calculateDegeneracy2(keepOutput_3B,keepAllOutput_3B,fittestStructure_3B);

%%
[keepOutput_3A,keepAllOutput_3A] = solvePerturbedCircuit(1,fittestTextCircuit_3A(:,2:3),fittestStructure_3A,0);
SI_3A = checkStatisticalIndependence(keepAllOutput_3A,fittestStructure_3A);
[fitness_3A,faultTolerance_3A] = calculateFitnessAndFaultTolerance(fittestTextCircuit_3A,fittestStructure_3A,keepOutput_3A,1);

[keepOutput_3B,keepAllOutput_3B] = solvePerturbedCircuit(1,fittestTextCircuit_3B(:,2:3),fittestStructure_3B,0);
SI_3B = checkStatisticalIndependence(keepAllOutput_3B,fittestStructure_3B);
[fitness_3B,faultTolerance_3B] = calculateFitnessAndFaultTolerance(fittestTextCircuit_3B,fittestStructure_3B,keepOutput_3B,1);
%%
[textCircuitsTemp_3Bmut,structureTemp_3Bmut] = mutation03(fittestTextCircuit_3B,fittestStructure_3B);
figure 
connectionMat_3Bmut = drawCircuit_text(structureTemp_3Bmut,textCircuitsTemp_3Bmut,numOfOutputs,1);

%%

%%
%%
[degeneracy,degeneracy2,degeneracyUB,redundancy,complexity,circuitSize] = calculateDegeneracy(keepOutput,keepAllOutput,fittestStructure);
[degeneracy3,redundancyMean] = calculateDegeneracyIncSize(keepOutput,keepAllOutput,fittestTextCircuit,fittestStructure);
% sanity check -> is redundancyMean(end) == redundancy?
%% %%%
drawCircuit_text(structureTemp,textCircuitsTemp,2,1)
[textCircuitsTemp_3Bmut,structureTemp_3Bmut] = mutation03(fittestTextCircuit,fittestStructure,2,0);

textCircuitsMutated