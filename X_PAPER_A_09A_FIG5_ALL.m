clear all;close all;clc;
fittestCircuitIdx= 1;
%%
run('loadFIG5A.m')
fittestStructure_5a   = fittestStructure;
fittestTextCircuit_5a = fittestTextCircuit;
figure
connectionMat_5a = drawCircuit_text(fittestStructure_5a,fittestTextCircuit_5a,1);
[keepOutput_5a,keepAllOutput_5a] = solvePerturbedCircuit(1,fittestTextCircuit_5a(:,2:3),fittestStructure_5a,0);
[fitness_5a,faultTolerance_5a] = calculateFitnessAndFaultTolerance(fittestTextCircuit_5a,fittestStructure_5a,keepOutput_5a,0);
[degeneracy_5a,~,~,degeneracyUB_5a,redundancy_5a,complexity_5a] = calculateDegeneracy(keepOutput_5a,keepAllOutput_5a,fittestStructure_5a);
truthTable_5a=printTruthTable(fittestStructure_5a,keepAllOutput_5a,0);
%%
switchMod = 0;
run('loadFIG5B.m')
fittestStructure_5b0   = fittestStructure;
fittestTextCircuit_5b0 = fittestTextCircuit;
figure
connectionMat_5b0 = drawCircuit_text(fittestStructure_5b0,fittestTextCircuit_5b0,0);
[keepOutput_5b0,keepAllOutput_5b0] = solvePerturbedCircuit(1,fittestTextCircuit_5b0(:,2:3),fittestStructure_5b0,0);
[fitness_5b0,faultTolerance_5b0] = calculateFitnessAndFaultTolerance(fittestTextCircuit_5b0,fittestStructure_5b0,keepOutput_5b0,0);
[degeneracy_5b0,~,~,degeneracyUB_5b0,redundancy_5b0,complexity_5b0] = calculateDegeneracy(keepOutput_5b0,keepAllOutput_5b0,fittestStructure_5b0);
truthTable_5b0=printTruthTable(fittestStructure_5b0,keepAllOutput_5b0,0);
%%
switchMod = 1;
run('loadFIG5B.m')
fittestStructure_5b1   = fittestStructure;
fittestTextCircuit_5b1 = fittestTextCircuit;
figure
connectionMat_5b1 = drawCircuit_text(fittestStructure_5b1,fittestTextCircuit_5b1,1);
[keepOutput_5b1,keepAllOutput_5b1] = solvePerturbedCircuit(1,fittestTextCircuit_5b1(:,2:3),fittestStructure_5b1,0);
[fitness_5b1,faultTolerance_5b1] = calculateFitnessAndFaultTolerance(fittestTextCircuit_5b1,fittestStructure_5b1,keepOutput_5b1,0);
[degeneracy_5b1,~,~,degeneracyUB_5b1,redundancy_5b1,complexity_5b1] = calculateDegeneracy(keepOutput_5b1,keepAllOutput_5b1,fittestStructure_5b1);
truthTable_5b1=printTruthTable(fittestStructure_5b1,keepAllOutput_5b1,0);
%%

