clear all;close all;clc;
fileinfoRDC    = dir(['./cluster_output/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MVG_SEED_*.mat']);
allNames       = {fileinfoRDC.name};
seedsConverged = unique(str2double(extractBefore(extractAfter(allNames,'BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MVG_SEED_'),'_')));

totalNumVec = [];
for seed = seedsConverged
    fileinfoBefore = dir(['./cluster_output/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MVG_SEED_' num2str(seed) '_*.mat']);
    allNames       = {fileinfoRDC.name};
    totalNumVec    = [totalNumVec max(str2double(extractBefore(extractAfter(allNames,['BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MVG_SEED_' num2str(seed) '_' ]),'.mat')))];
end
[~,i]      = sort(totalNumVec,'descend');
seedSorted = seedsConverged(i);
totalNumVecSorted = totalNumVec(i);
seedPick   = seedSorted;
%%
for seed = seedPick(1)
    
    fileinfoBefore = dir(['./cluster_output/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MVG_SEED_' num2str(seed) '_*.mat']);
    load(['./cluster_output/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MVG_SEED_' num2str(seed) '_' num2str(totalNumVecSorted(seedSorted==seed)) '.mat']);
    figure
    plot(freqAlternate:freqAlternate:totalNumVecSorted(seedSorted==seed),maxFitnessKeep(freqAlternate:freqAlternate:end),'k')
    hold on;
    plot(freqAlternate:freqAlternate:totalNumVecSorted(seedSorted==seed),meanFitnessKeep(freqAlternate:freqAlternate:end),'r')
    grid on;
end

%%
close all;
pickIdx      = 12;
seedsFittest = unique(cell2mat(fittestTextCircuit(:,1)));
seedFittest  = seedsFittest(pickIdx)
fittestTextCircuitPick = fittestTextCircuit(cell2mat(fittestTextCircuit(:,1))==seedFittest,:);
fittestStructurePick   = fittestStructure{pickIdx};
connectionMat_2 = drawCircuit_text(fittestStructurePick,fittestTextCircuitPick,1);

