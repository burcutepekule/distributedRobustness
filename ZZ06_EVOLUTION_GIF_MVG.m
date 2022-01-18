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
%% GIF
for seed = seedPick
    close all;
    totalNumVecSortedPick = totalNumVecSorted(ismember(seedSorted,seed));
    printGIF_MVG(totalNumVecSortedPick,freqAlternate,seed)
end
