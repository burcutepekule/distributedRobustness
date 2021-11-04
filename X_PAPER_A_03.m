clear all;close all;clc;
rng(14);
numOfInputs    = 2; %number of inputs
numOfOutputs   = 2; %number of outputs
numOfGates     = 5; %number of NAND gates
numOfSolutions = 100; %number of trials (max candidate solutions)
%% STEP 1 : GENERATE RANDOM CIRCUITS
[keepCircuits,keepStructure,keepNumOfLayers,textCircuits,strAllText] = generateRandomCircuits(numOfInputs,numOfOutputs,numOfGates,numOfSolutions);
%% STEP 2 : SOLVE THE CIRCUITS
keepAllOutput    = solveCircuit(numOfInputs,textCircuits,keepStructure);
%% STEP 3 : VISUALIZE
% idxFound         = 2; %pick a circuit index
idxFound         = 3; %pick a circuit index
structureTemp    = keepStructure{idxFound};
textCircuitsTemp = textCircuits(cell2mat(textCircuits(:,1))==idxFound,:);
close all;
connectionMat    = drawCircuit_text(structureTemp,textCircuitsTemp,numOfOutputs);
%% STEP 4 : EVOLUTION (?)
% The random mutations (always respecting the back- ward patterning) can be:
% (a) elimination of an existing connection, with probability Ec,
% (b) creation of a new connection with probability Cc,
% (c) elimination of a node (gate removal) with probability In, and
% (d) creation of a new node (gate addition) with probability Cn.
% Here, we use Ec=0.8, Cc=0.8, In=0.3 and Cn=0.6.
%% TRY OUT RANDOM MUTATION #1 (a)+(b)
close all;
[textCircuitsTemp_mutated,structureTemp_mutated] = mutation01(textCircuitsTemp,structureTemp);
figure
set(gcf, 'Position',  [100, 300, 1500, 400])
subplot(1,2,1)
connectionMat         = drawCircuit_text(structureTemp,textCircuitsTemp,numOfOutputs);
subplot(1,2,2)
connectionMat_mutated = drawCircuit_text(structureTemp_mutated,textCircuitsTemp_mutated,numOfOutputs);

%% TRY OUT RANDOM MUTATION #2 (c)
clc
[textCircuitsTemp_mutated,structureTemp_mutated] = mutation02(textCircuitsTemp,structureTemp);
close all;
figure
set(gcf, 'Position',  [100, 300, 1500, 400])
subplot(1,2,1)
connectionMat         = drawCircuit_text(structureTemp,textCircuitsTemp,numOfOutputs);
subplot(1,2,2)
connectionMat_mutated = drawCircuit_text(structureTemp_mutated,textCircuitsTemp_mutated,numOfOutputs);
% problematic :     "Gate removed : 3010"
%%
% RANDOM MUTATION #3
% (d) -> If you add one gate, you add two inputs and one output 
% You can add a gate either to the very 
% delete one of the connections to the input that is connected to two (or
% more) other gates (to maintain the full connectiveness), and connect the
% other input to the output.

