clear all;close all;clc;
rng(14);
numOfInputs    = 3; %number of inputs
numOfOutputs   = 2; %number of outputs
load('SIM_RNG_14.mat')
%% Fault Tolerance
textCircuitTemp       = fittestTextCircuitInitial;
structureTemp         = fittestStructureInitial;
tweakGate             = 1;
allOutputGates        = cell2mat(textCircuitTemp(:,2));
allOutputGatesPerturb = allOutputGates(floor(allOutputGates./1000)>0);
%%


keepOutput       = [];
keepAllOutput    = [];
%%
tempCircuitIdx = 1;
tempCircuit    = textCircuitTemp(:,2:3);
tempStructure  = structureTemp;
keep           = [];
keepPerturbedOutput= [];
for outputGate2Perturb = allOutputGatesPerturb'
    outputGate2Perturb
    [keepOutput_perturbed]    = solvePerturbedCircuit(numOfInputs,tempCircuitIdx,tempCircuit,tempStructure,outputGate2Perturb);
    keepPerturbedOutput       = [keepPerturbedOutput;keepOutput_perturbed];
end
%%
[keepOutput_NotPerturbed] = solvePerturbedCircuit(numOfInputs,tempCircuitIdx,tempCircuit,tempStructure,0);
faultTolerance = 1-reshape(mean(mean(abs(repmat(keepOutput_NotPerturbed,length(allOutputGatesPerturb),1)-keepPerturbedOutput),1),2),1,[]);







