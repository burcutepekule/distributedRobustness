clear all;close all;clc;
% parpool('local')
keepData         = [];
plotOn           = 0;
fittestCircuitIdx= 1;
numOfInputs      = 2;

% numOfOutputs     = 2;
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

% numOfOutputs     = 3;
% fittestTextCircuit{1,1} = 1;
% fittestTextCircuit{2,1} = 1;
% fittestTextCircuit{3,1} = 1;
% fittestTextCircuit{4,1} = 1;
% 
% 
% fittestTextCircuit{1,2} = 13;
% fittestTextCircuit{2,2} = 23;
% 
% 
% fittestTextCircuit{1,3} = [1011,1012,1021];
% fittestTextCircuit{2,3} = [1032,1031,1022];
% 
% 
% fittestStructure = [0 2;1 3];
% drawCircuit_text(fittestStructure,fittestTextCircuit,numOfOutputs,1)

% numOfOutputs     = 1;
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
% fittestTextCircuit{3,3} = [2011];
% fittestTextCircuit{4,3} = [2012];
% 
% fittestStructure = [0 2;1 2;2 1];
% drawCircuit_text(fittestStructure,fittestTextCircuit,numOfOutputs,1)


numOfOutputs     = 2;
fittestTextCircuit{1,1} = 1;
fittestTextCircuit{2,1} = 1;
fittestTextCircuit{3,1} = 1;
fittestTextCircuit{4,1} = 1;

fittestTextCircuit{1,2} = 13;
fittestTextCircuit{2,2} = 23;
fittestTextCircuit{3,2} = 1013;
fittestTextCircuit{4,2} = 1023;

fittestTextCircuit{1,3} = [1011,1012];
fittestTextCircuit{2,3} = [1021,1022];
% fittestTextCircuit{3,3} = [2011,2012];
% fittestTextCircuit{4,3} = [2022,2021];
fittestTextCircuit{3,3} = [2011,2022];
fittestTextCircuit{4,3} = [2012,2021];

fittestStructure = [0 2;1 2;2 2];
drawCircuit_text(fittestStructure,fittestTextCircuit,numOfOutputs,1)

%%
[keepOutput,keepAllOutput]   = solvePerturbedCircuit(numOfInputs,1,fittestTextCircuit(:,2:3),fittestStructure,0);
[degeneracy,degeneracy2,degeneracyUB,redundancy,complexity,circuitSize] = calculateDegeneracyOption(keepOutput,keepAllOutput,fittestStructure,0);
printTruthTable(fittestStructure,keepAllOutput);

redundancy

%%

h025 = -0.25*log2(0.25);
h050 = -0.50*log2(0.50);
h075 = -0.75*log2(0.75);

h050+h050
h075+h025
h050+h025+h025
