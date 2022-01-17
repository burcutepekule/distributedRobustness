clear all;close all;clc;
run('loadXOR_1.m')
% figure
% connectionMat_2 = drawCircuit_text(fittestStructure,fittestTextCircuit,1);
outputGate2Perturb = 0;
%%
tic;
[keepOutput_old,keepAllOutput_old] = solvePerturbedCircuit_old(1,fittestTextCircuit(:,2:3),fittestStructure,outputGate2Perturb);
toc;
%%
tic;
[keepOutput_new,keepAllOutput_new] = solvePerturbedCircuit(1,fittestTextCircuit(:,2:3),fittestStructure,outputGate2Perturb);
toc;
%%

[keepOutput_old keepOutput_new]
[keepAllOutput_old keepAllOutput_new]
