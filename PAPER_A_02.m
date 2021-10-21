%% REPRODUCING PAPER FIGURE 2
clear all;close all;clc;
rng(14); % THIS GENERATES WHAT I WANTED
numOfInputs        = 2; %number of inputs
numOfOutputs       = 2; %number of outputs
numOfGates         = 5; %number of NAND gates
numOfSolutions     = 5000; %number of candidate solutions
numOfLayers        = 3;
numOfGatesPerLayer = [0 2;1 1;2 2;3 2];
[keepCircuits,keepStructure,keepNumOfLayers,textCircuits,strAllText] = generateRandomCircuits(numOfInputs,numOfOutputs,numOfGates,numOfSolutions,numOfLayers,numOfGatesPerLayer);
%%
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
strlookFor   = circuit2str(lookFor);
%FIND THE CIRCUIT YOU ARE LOOKING FOR
fun           = @(A,B)cellfun(@isequal,A,B);
idxFound      = find(cellfun(@(c)all(fun(strlookFor,c)),num2cell(strAllText,2)));
keepAllOutput = solveCircuit(numOfInputs,textCircuits,keepStructure,idxFound);
%%
clc
structureTemp    = keepStructure{idxFound};
textCircuitsTemp = textCircuits(cell2mat(textCircuits(:,1))==idxFound,:);
drawCircuit(structureTemp,textCircuitsTemp,numOfOutputs)