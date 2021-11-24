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
checkStatisticalIndependence(keepAllOutput_1,fittestStructure_1)

%%
fittestTextCircuit = [];
run('loadXOR_2.m')
fittestTextCircuit_2 = fittestTextCircuit;
fittestStructure_2   = fittestStructure;
figure
drawCircuit_text(fittestStructure_2,fittestTextCircuit_2,numOfOutputs,1)
[keepOutput_2,keepAllOutput_2] = solvePerturbedCircuit(numOfInputs,1,fittestTextCircuit_2(:,2:3),fittestStructure_2,0);
checkStatisticalIndependence(keepAllOutput_2,fittestStructure_2)

%%
clc
fittestStructure = fittestStructure_2;
keepAllOutput    = keepAllOutput_2;

numOfGates    = sum(fittestStructure(2:end-1,2));
outputBinMat  = keepAllOutput(:,2:4);
C             = outputBinMat(:,2);
Cj            = cat(1, C{:});
allGates      = Cj(1:(numOfInputs+numOfGates+numOfOutputs));
inputGates    = allGates(1:numOfInputs);
outputGates   = allGates(end-numOfOutputs+1:end);
middleGates   = setdiff(allGates,[outputGates;inputGates]);

idxInput        = reshape(find(ismember(Cj,inputGates)),length(inputGates),[])';
idxMiddle       = reshape(find(ismember(Cj,middleGates)),length(middleGates),[])';
idxOutput       = reshape(find(ismember(Cj,outputGates)),length(outputGates),[])';

inputGates    = reshape(double(cell2mat(outputBinMat(idxInput,3))),[],length(inputGates));% [outputMat(idxSub(:,1),3) outputMat(idxSub(:,2),3)] %sanity check
middleGates   = reshape(double(cell2mat(outputBinMat(idxMiddle,3))),[],length(middleGates));
outputGates   = reshape(double(cell2mat(outputBinMat(idxOutput,3))),[],length(outputGates));

truthTable    = table(inputGates,middleGates,outputGates)
%%
% h025 = -0.25*log2(0.25);
% h050 = -0.50*log2(0.50);
% h075 = -0.75*log2(0.75);

syms h025 h050 h075

H_I_13  = h050+h050
H_I_23  = h050+h050
H_I_ALL = 4*h025

H_X_1013 = h075+h025
H_X_2013 = h075+h025
H_X_2023 = h075+h025
H_X_ALL  = 4*h025
H_I_ALL  = 4*h025
H_IX_ALL = 4*h025
H_XO_ALL = 4*h025

H_O_3013 = h050+h050

H_IX_ALL_O_3013   = 4*h025
H_X_ALL_O_3013    = 4*h025
H_XO_ALL_O_3013   = 4*h025
H_I_ALL_O_3013    = 4*h025

H_I_13_O_3013   = 4*h025
H_I_23_O_3013   = 4*h025

H_X_1013_O_3013 = h050+h025+h025
H_X_2013_O_3013 = h050+h025+h025
H_X_2023_O_3013 = h050+h025+h025
H_O_3013_O_3013 = h050+h050

I_I_13_O_3013  = H_I_13+H_O_3013-H_I_13_O_3013
I_I_23_O_3013  = H_I_23+H_O_3013-H_I_23_O_3013
I_I_ALL_O_3013 = H_I_ALL+H_O_3013-H_I_ALL_O_3013


I_X_1013_O_3013 = H_X_1013+H_O_3013-H_X_1013_O_3013
I_X_2013_O_3013 = H_X_2013+H_O_3013-H_X_2013_O_3013
I_X_2023_O_3013 = H_X_2023+H_O_3013-H_X_2023_O_3013

I_O_3013_O_3013 = H_O_3013+H_O_3013-H_O_3013_O_3013

I_X_ALL_O_3013  = H_X_ALL+H_O_3013-H_X_ALL_O_3013
I_IX_ALL_O_3013 = H_IX_ALL+H_O_3013-H_IX_ALL_O_3013
I_XO_ALL_O_3013 = H_XO_ALL+H_O_3013-H_XO_ALL_O_3013

R  = I_X_1013_O_3013+I_X_2013_O_3013+I_X_2023_O_3013-I_X_ALL_O_3013
Ro = I_X_1013_O_3013+I_X_2013_O_3013+I_X_2023_O_3013+I_O_3013_O_3013-I_XO_ALL_O_3013
Rio= Ro+I_I_ALL_O_3013

h025 = -0.25*log(0.25);
h050 = -0.50*log2(0.50);
h075 = -0.75*log2(0.75);

double(subs(H_X_1013))
double(subs(I_X_1013_O_3013))
double(subs(I_X_ALL_O_3013))

double(subs(R))
double(subs(Ro))
double(subs(Rio))

%%
[degeneracy_1,degeneracy2_1,degeneracyUB_1,redundancy_1,complexity_1,circuitSize_1] = calculateDegeneracyOption(keepOutput_1,keepAllOutput_1,numOfInputs,numOfOutputs,fittestStructure_1,0);
[degeneracy_2,degeneracy2_2,degeneracyUB_2,redundancy_2,complexity_2,circuitSize_2] = calculateDegeneracyOption(keepOutput_2,keepAllOutput_2,numOfInputs,numOfOutputs,fittestStructure_2,0);

%%


%
h025 = -0.25*log2(0.25);
h050 = -0.50*log2(0.50);
h075 = -0.75*log2(0.75);

% syms h025 h050 h075

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



