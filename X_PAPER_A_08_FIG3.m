clear all;close all;clc;
fittestCircuitIdx= 1;
numOfOutputs     = 2;
numOfInputs      = 2;
run('loadFIG3A.m')
figure
connectionMat_3A = drawCircuit_text(fittestStructure,fittestTextCircuit,numOfOutputs,1);
[keepOutput,keepAllOutput] = solvePerturbedCircuit(numOfInputs,1,fittestTextCircuit(:,2:3),fittestStructure,0);
checkStatisticalIndependence(keepAllOutput,fittestStructure)
[fitness,faultTolerance] = calculateFitnessAndFaultTolerance(fittestTextCircuit,fittestStructure,numOfInputs,keepOutput,1);
[degeneracy,degeneracy2,degeneracyUB,redundancy,complexity,circuitSize] = calculateDegeneracy(keepOutput,keepAllOutput,fittestStructure);

%%
clear all;close all;clc;
fittestCircuitIdx= 1;
numOfOutputs     = 2;
numOfInputs      = 2;
run('loadFIG3B.m')
figure
connectionMat_3B = drawCircuit_text(fittestStructure,fittestTextCircuit,numOfOutputs,1);
[keepOutput,keepAllOutput] = solvePerturbedCircuit(numOfInputs,1,fittestTextCircuit(:,2:3),fittestStructure,0);
checkStatisticalIndependence(keepAllOutput,fittestStructure)
[fitness,faultTolerance] = calculateFitnessAndFaultTolerance(fittestTextCircuit,fittestStructure,numOfInputs,keepOutput,1);
%%
%%
[degeneracy,degeneracy2,degeneracyUB,redundancy,complexity,circuitSize] = calculateDegeneracy(keepOutput,keepAllOutput,fittestStructure);
[degeneracy3,redundancyMean] = calculateDegeneracyIncSize(keepOutput,keepAllOutput,fittestTextCircuit,fittestStructure);
% sanity check -> is redundancyMean(end) == redundancy?