%% REPRODUCING PAPER FIGURE 2
clear all;close all;clc;
rng(14); 
numOfInputs        = 2; %number of inputs
numOfOutputs       = 2; %number of outputs
numOfGates         = 5; %number of NAND gates
numOfSolutions     = 5000; %number of candidate solutions
numOfLayers        = 3;
numOfGatesPerLayer = [0 2;1 1;2 2;3 2];
[keepCircuits,keepStructure,keepNumOfLayers,textCircuits,strAllText] = generateRandomCircuits(numOfInputs,numOfOutputs,numOfGates,numOfSolutions,numOfLayers,numOfGatesPerLayer,numOfSolutions);
%% FIND THE CIRCUIT YOU ARE LOOKING FOR (FIG 2A)
% INDEXING : (A)-(BC)-1 : Ath later, BCth gate, input 1
% INDEXING : (A)-(BC)-2 : Ath later, BCth gate, input 2
% INDEXING : (A)-(BC)-3 : Ath later, BCth gate, output
% A = 0 -> INPUT LAYER

lookFor{1,1} = 13;
lookFor{1,2} = [1012,2011,2021,3012];
lookFor{2,1} = 23;
lookFor{2,2} = [1011,3022];
lookFor{3,1} = 1013;
lookFor{3,2} = [2012,2022];
lookFor{4,1} = 2013;
lookFor{4,2} = [3011];
lookFor{5,1} = 2023;
lookFor{5,2} = [3021];

strlookFor       = circuit2str(lookFor);
fun              = @(A,B)cellfun(@isequal,A,B);
idxFound         = find(cellfun(@(c)all(fun(strlookFor,c)),num2cell(strAllText,2)));
indStart         = find(cell2mat(textCircuits(:,1))==idxFound, 1 );
indEnd           = find(cell2mat(textCircuits(:,1))==idxFound, 1, 'last' );
tempCircuit      = textCircuits(indStart:indEnd,2:3);
structureTemp    = keepStructure{idxFound};
[keepOutput,keepAllOutput] = solvePerturbedCircuit(numOfInputs,1,tempCircuit,structureTemp,0);

%%
clc
structureTemp    = keepStructure{idxFound};
textCircuitsTemp = textCircuits(cell2mat(textCircuits(:,1))==idxFound,:);
% drawCircuit(structureTemp,textCircuitsTemp,numOfOutputs)
drawCircuit_text(structureTemp,textCircuitsTemp,numOfOutputs,1)