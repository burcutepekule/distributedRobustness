clear all;close all;clc;
madness    = load(['./cluster/MADNESS_12.mat']);

fittestCircuitIdx    = 1;
fittestStructure     = madness.keepStructure_12{1};
fittestTextCircuit   = madness.textCircuits_12;
numOfOutputs         = madness.numOfOutputs;
connectionMatInitial = drawCircuit_text(fittestStructure,fittestTextCircuit,numOfOutputs,0);
numOfInputs          = madness.numOfInputs;

[keepOutput,keepAllOutput]   = solvePerturbedCircuit(numOfInputs,1,fittestTextCircuit(:,2:3),fittestStructure,0);
[degeneracy,degeneracy2,degeneracyUB,redundancy,complexity,circuitSize] = calculateDegeneracyOption(keepOutput,keepAllOutput,fittestStructure,0);
