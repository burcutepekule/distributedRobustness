clear all;close all;clc;
fittestCircuitIdx= 1;
numOfOutputs     = 1;
numOfInputs      = 2;
%%
fittestTextCircuit = [];
run('loadXOR_1.m')
fittestTextCircuit_1 = fittestTextCircuit;
fittestStructure_1   = fittestStructure;
figure
drawCircuit_text(fittestStructure_1,fittestTextCircuit_1,numOfOutputs,1)
[keepOutput_1,keepAllOutput_1] = solvePerturbedCircuit(numOfInputs,1,fittestTextCircuit_1(:,2:3),fittestStructure_1,0);
%%
fittestTextCircuit = [];
run('loadXOR_2.m')
fittestTextCircuit_2 = fittestTextCircuit;
fittestStructure_2   = fittestStructure;
figure
drawCircuit_text(fittestStructure_2,fittestTextCircuit_2,numOfOutputs,1)
[keepOutput_2,keepAllOutput_2] = solvePerturbedCircuit(numOfInputs,1,fittestTextCircuit_2(:,2:3),fittestStructure_2,0);
%%
[degeneracy_1,degeneracy2_1,degeneracyUB_1,redundancy_1,complexity_1,circuitSize_1] = calculateDegeneracy(keepOutput_1,keepAllOutput_1,numOfInputs,numOfOutputs,fittestStructure_1);
[degeneracy_2,degeneracy2_2,degeneracyUB_2,redundancy_2,complexity_2,circuitSize_2] = calculateDegeneracy(keepOutput_2,keepAllOutput_2,numOfInputs,numOfOutputs,fittestStructure_2);
[redundancy_1 redundancy_2]
[degeneracy_1 degeneracy_2]

%%


(10/4)*log(2)-(9/4)*log(3)
% 
% h025 = -0.25*log(0.25);
% h050 = -0.50*log(0.50);
% h075 = -0.75*log(0.75);

syms h025 h050 h075

H_1013 = h075+h025
H_2013 = h075+h025
H_2023 = h075+h025
H_3013 = h050+h050
H_O    = h050+h050
H_ALL  = 4*h025

H_1013_O = h050+h025+h025
H_2013_O = h050+h025+h025
H_2023_O = h050+h025+h025
H_3013_O = h050+h050
H_ALL_O  = 4*h025

I_1013_O = H_1013+H_O-H_1013_O
I_2013_O = H_2013+H_O-H_2013_O
I_2023_O = H_2023+H_O-H_2023_O
I_3013_O = H_3013+H_O-H_3013_O
I_ALL_O  = H_ALL+H_O-H_ALL_O

R_1 = I_1013_O+I_2013_O+I_2023_O-I_ALL_O
R_2 = I_1013_O+I_2013_O+I_2023_O+I_3013_O-I_ALL_O



