clear all;close all;clc;
fittestCircuitIdx= 1;
numOfOutputs     = 2;
numOfInputs      = 2;
% %%
% % run('loadC_0.m') %example for redundancy and degeneracy being zero
% run('loadC_2a.m')
% figure
% connectionMat_a = drawCircuit_text(fittestStructure,fittestTextCircuit,numOfOutputs,1);
% %%
% [keepOutput_a,keepAllOutput_a] = solvePerturbedCircuit(1,fittestTextCircuit(:,2:3),fittestStructure,0);
% checkStatisticalIndependence(keepAllOutput_a,fittestStructure)
% [fitness_a,faultTolerance_a] = calculateFitnessAndFaultTolerance(fittestTextCircuit,fittestStructure,keepOutput_a,1);
% [degeneracy_a,degeneracy2_a,degeneracy3_a,degeneracyUB_a,redundancy_a,complexity_a,complexity2_a,circuitSize_a,IsubOne_a,IallFinal_a] = calculateDegeneracy(keepOutput_a,keepAllOutput_a,fittestStructure);
% % [degeneracy4,redundancyMean,degeneracyVec] = calculateDegeneracyIncSize(keepOutput,keepAllOutput,fittestTextCircuit,fittestStructure);
% truthTable_a=printTruthTable(fittestStructure,keepAllOutput_a,0);
% IsubOne_a
% IallFinal_a
% % how much each element contributes?
% [IsubOne_a./((redundancy_a+IallFinal_a)/(circuitSize_a-numOfOutputs))]
%%
run('loadC_2b.m')
figure
connectionMat_b = drawCircuit_text(fittestStructure,fittestTextCircuit,numOfOutputs,1);
%%
[keepOutput_b,keepAllOutput_b] = solvePerturbedCircuit(1,fittestTextCircuit(:,2:3),fittestStructure,0);
checkStatisticalIndependence(keepAllOutput_b,fittestStructure)
[fitness_b,faultTolerance_b] = calculateFitnessAndFaultTolerance(fittestTextCircuit,fittestStructure,keepOutput_b,1);
[degeneracy_b,degeneracy2_b,degeneracy3_b,degeneracyUB_b,redundancy_b,complexity_b,complexity2_b,circuitSize_b,IsubOne_b,IallFinal_b] = calculateDegeneracy(keepOutput_b,keepAllOutput_b,fittestStructure);
% [degeneracy4,redundancyMean,degeneracyVec] = calculateDegeneracyIncSize(keepOutput,keepAllOutput,fittestTextCircuit,fittestStructure);
truthTable_b=printTruthTable(fittestStructure,keepAllOutput_b,0);
IsubOne_b
IallFinal_b
% how much each element contributes?
[IsubOne_b./((redundancy_b+IallFinal_b)/(circuitSize_b-numOfOutputs))]
%%
run('loadC_2c.m')
figure
connectionMat_b = drawCircuit_text(fittestStructure,fittestTextCircuit,numOfOutputs,1);
%%
[keepOutput_c,keepAllOutput_c] = solvePerturbedCircuit(1,fittestTextCircuit(:,2:3),fittestStructure,0);
checkStatisticalIndependence(keepAllOutput_c,fittestStructure)
[fitness_c,faultTolerance_c] = calculateFitnessAndFaultTolerance(fittestTextCircuit,fittestStructure,keepOutput_c,1);
[degeneracy_c,degeneracy2_c,degeneracy3_c,degeneracyUB_c,redundancy_c,complexity_c,complexity2_c,circuitSize_c,IsubOne_c,IallFinal_c] = calculateDegeneracy(keepOutput_c,keepAllOutput_c,fittestStructure);
% [degeneracy4,redundancyMean,degeneracyVec] = calculateDegeneracyIncSize(keepOutput,keepAllOutput,fittestTextCircuit,fittestStructure);
truthTable_c=printTruthTable(fittestStructure,keepAllOutput_c,0);
IsubOne_c
IallFinal_c
% how much each element contributes?
[IsubOne_c./((redundancy_c+IallFinal_c)/(circuitSize_c-numOfOutputs))]
%%
[degeneracy_b/degeneracyUB_b degeneracy_c/degeneracyUB_c]
