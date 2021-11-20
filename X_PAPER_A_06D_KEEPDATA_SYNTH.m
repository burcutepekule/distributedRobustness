clear all;close all;clc;
% parpool('local')
keepData         = [];
plotOn           = 0;
fittestCircuitIdx= 1;
numOfOutputs     = 2;
numOfInputs      = 2;

% fittestTextCircuit{1,1} = 1;
% fittestTextCircuit{2,1} = 1;
% fittestTextCircuit{3,1} = 1;
% fittestTextCircuit{4,1} = 1;
% 
% fittestTextCircuit{1,2} = 13;
% fittestTextCircuit{2,2} = 23;
% fittestTextCircuit{3,2} = 1013;
% fittestTextCircuit{4,2} = 1023;
% 
% fittestTextCircuit{1,3} = [1011,1012];
% fittestTextCircuit{2,3} = [1021,1022];
% fittestTextCircuit{3,3} = [2011,2012];
% fittestTextCircuit{4,3} = [2021,2022];
% 
% fittestStructure = [0 2;1 2;2 2];
% drawCircuit_text(fittestStructure,fittestTextCircuit,numOfOutputs,1)

fittestTextCircuit{1,1} = 1;
fittestTextCircuit{2,1} = 1;

fittestTextCircuit{1,2} = 13;
fittestTextCircuit{2,2} = 23;

fittestTextCircuit{1,3} = [1011,1012];
fittestTextCircuit{2,3} = [1022,1021];

fittestStructure = [0 2;1 2;];
drawCircuit_text(fittestStructure,fittestTextCircuit,numOfOutputs,1)

%%
[keepOutput,keepAllOutput]   = solvePerturbedCircuit(numOfInputs,1,fittestTextCircuit(:,2:3),fittestStructure,0);
[degeneracy,degeneracy2,degeneracyUB,redundancy,complexity,circuitSize] = calculateDegeneracy(keepOutput,keepAllOutput,numOfInputs,numOfOutputs,fittestStructure);

