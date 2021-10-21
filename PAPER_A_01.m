clear all;close all;clc;
rng(14); % THIS GENERATES WHAT I WANTED
numOfInputs    = 2; %number of inputs
numOfOutputs   = 2; %number of outputs
numOfGates     = 9; %number of NAND gates
numOfSolutions = 1000; %number of trials (max candidate solutions)
%% STEP 1 : GENERATE RANDOM CIRCUITS
[keepCircuits,keepStructure,keepNumOfLayers,textCircuits,strAllText] = generateRandomCircuits(numOfInputs,numOfOutputs,numOfGates,numOfSolutions);
%% STEP 2 : SOLVE THE CIRCUITS
keepAllOutput    = solveCircuit(numOfInputs,textCircuits,keepStructure);
%% STEP 3 : VISUALIZE
idxFound         = 1; %pick a circuit index
structureTemp    = keepStructure{idxFound};
textCircuitsTemp = textCircuits(cell2mat(textCircuits(:,1))==idxFound,:);
drawCircuit(structureTemp,textCircuitsTemp,numOfOutputs)