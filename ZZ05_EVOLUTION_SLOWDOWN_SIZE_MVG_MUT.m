clear all;close all;clc;
fileinfoRDC    = dir(['./cluster_output/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MVG_MUT_SEED_*.mat']);
allNames       = {fileinfoRDC.name};
seedsConverged = unique(str2double(extractBefore(extractAfter(allNames,'BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MVG_MUT_SEED_'),'_')));
%pick seeds occ=1 sizeVec =1, seedSorted>50
% seedsConverged = seedsConverged(seedsConverged>=100);
seedsConverged = seedsConverged(seedsConverged<50);

totalNumVec = [];
for seed = seedsConverged
    fileinfoBefore = dir(['./cluster_output/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MVG_MUT_SEED_' num2str(seed) '_*.mat']);
    allNames       = {fileinfoRDC.name};
    totalNumVec    = [totalNumVec max(str2double(extractBefore(extractAfter(allNames,['BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MVG_MUT_SEED_' num2str(seed) '_' ]),'.mat')))];
end
[~,i]      = sort(totalNumVec,'descend');
seedSorted = seedsConverged(i);
totalNumVecSorted = totalNumVec(i);

% seedPick = seedSorted(1:10);
seedPick = [3 9]; %3 and 9
totalNumVecSortedPick = totalNumVecSorted(ismember(seedSorted,seedPick));

for seed = seedPick
    
    fileinfoBefore = dir(['./cluster_output/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MVG_MUT_SEED_' num2str(seed) '_*.mat']);
    load(['./cluster_output/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MVG_MUT_SEED_' num2str(seed) '_' num2str(totalNumVecSorted(seedSorted==seed)) '.mat']);
    figure(seed+1)
    plot(freqAlternate:freqAlternate:totalNumVecSorted(seedSorted==seed),maxFitnessKeep(freqAlternate:freqAlternate:end),'k')
    hold on;
    plot(freqAlternate:freqAlternate:totalNumVecSorted(seedSorted==seed),meanFitnessKeep(freqAlternate:freqAlternate:end),'r')
    grid on;
    axis([0 totalNumVecSorted(seedSorted==seed) 0.65 1.05])
    
    
end
%%
% draw first circuit
close all;
seed=3
load(['./cluster_output/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MVG_MUT_SEED_' num2str(seed) '_' num2str(1) '.mat']);
figure
drawCircuit_text_Ind(fittestTextCircuit,fittestStructure,1)
%%

totalNumVecSortedPick = totalNumVecSorted(ismember(seed,seedPick));
% fix the output
numOfInputs    = 4; %number of inputs
% THIS IS TO REPLICATE THE RESULTS OF URI ALON
inpMat         = [];
for i=0:(2^numOfInputs-1)
    inpMat = [inpMat;str2logicArray(dec2bin(i,numOfInputs))];
end
% An Introduction to Systems Biology, Eq. 15.5.1
numOfOutputs   = 1;
xor_module_1   = xor(inpMat(:,1),inpMat(:,2));
xor_module_2   = xor(inpMat(:,3),inpMat(:,4));
G1             = and(xor(inpMat(:,1),inpMat(:,2)),xor(inpMat(:,3),inpMat(:,4)));
G2             = or(xor(inpMat(:,1),inpMat(:,2)),xor(inpMat(:,3),inpMat(:,4)));


roundMutation = floor((totalNumVecSortedPick-20)/40)-2;

load(['./cluster_output/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MVG_MUT_SEED_' num2str(seed) '_' num2str(20+roundMutation*40) '.mat']);
% figure(20+roundMutation*40)
drawCircuit_text_Ind(fittestTextCircuit,fittestStructure,1);
indPlot          = 1; %fittest
allInds          = unique(cell2mat(fittestTextCircuit(:,1)));
structureTemp    = fittestStructure{indPlot};
textCircuitsTemp = fittestTextCircuit(cell2mat(fittestTextCircuit(:,1))==allInds(indPlot),:);
[keepOutput,keepAllOutput] = solvePerturbedCircuit(allInds(indPlot),textCircuitsTemp(:,2:3),structureTemp,0);
truthTable_G1=printTruthTable(structureTemp,keepAllOutput,0);
middleStates = truthTable_G1.middleStates;
middleStates_XOR = middleStates(:,7:8);
mod1_g1=mean(abs([xor_module_1-middleStates_XOR(:,1)]));
mod2_g1=mean(abs([xor_module_2-middleStates_XOR(:,2)]));


load(['./cluster_output/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MVG_MUT_SEED_' num2str(seed) '_' num2str(20+roundMutation*40+20) '.mat']);
% figure(20+roundMutation*40+20)
drawCircuit_text_Ind(fittestTextCircuit,fittestStructure,1);
indPlot          = 1; %fittest
allInds          = unique(cell2mat(fittestTextCircuit(:,1)));
structureTemp    = fittestStructure{indPlot};
textCircuitsTemp = fittestTextCircuit(cell2mat(fittestTextCircuit(:,1))==allInds(indPlot),:);
[keepOutput,keepAllOutput] = solvePerturbedCircuit(allInds(indPlot),textCircuitsTemp(:,2:3),structureTemp,0);
truthTable_G2=printTruthTable(structureTemp,keepAllOutput,0);
middleStates = truthTable_G2.middleStates;
middleStates_XOR = middleStates(:,7:8);
mod1_g2=mean(abs([xor_module_1-middleStates_XOR(:,1)]));
mod2_g2=mean(abs([xor_module_2-middleStates_XOR(:,2)]));

% either all 0 or 0.5
[mod1_g1 mod2_g1 mod1_g2 mod2_g2]
%%
close all;clc;
fittestStructurePick  = fittestStructure{1};
fittestTextCircuitPick= fittestTextCircuit(cell2mat(fittestTextCircuit(:,1))==1,:);
%%
drawCircuit_text(structureTemp,textCircuitsTemp,0);
%%
drawCircuit_text_optimal(structureTemp,textCircuitsTemp,0);
%%
printGIF_MVG(1200,freqAlternate,3)


