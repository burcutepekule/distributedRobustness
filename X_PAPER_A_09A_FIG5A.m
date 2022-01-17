clear all;close all;clc;
fittestCircuitIdx= 1;
numOfOutputs     = 2;
numOfInputs      = 2;
run('loadFIG5A.m')
figure
connectionMat_2 = drawCircuit_text(fittestStructure,fittestTextCircuit,1);
%%
[keepOutput,keepAllOutput] = solvePerturbedCircuit(1,fittestTextCircuit(:,2:3),fittestStructure,0);
checkStatisticalIndependence(keepAllOutput,fittestStructure)
[fitness,faultTolerance] = calculateFitnessAndFaultTolerance(fittestTextCircuit,fittestStructure,keepOutput,0);
[degeneracy_a,degeneracy_b,degeneracy_c,degeneracyUB,redundancy,complexity_a,complexity_b,circuitSize] = calculateDegeneracy(keepOutput,keepAllOutput,fittestStructure);
truthTable_2=printTruthTable(fittestStructure,keepAllOutput,0);
