clear all;close all;clc;
fileinfoRDC    = dir(['./cluster_output/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MUT_SEED_*.mat']);
allNames       = {fileinfoRDC.name};
seedsConverged = unique(str2double(extractBefore(extractAfter(allNames,'BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MUT_SEED_'),'_')));

totalNumVec = [];
for seed = seedsConverged
    fileinfoBefore = dir(['./cluster_output/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MUT_SEED_' num2str(seed) '_*.mat']);
    allNames       = {fileinfoRDC.name};
    totalNumVec    = [totalNumVec max(str2double(extractBefore(extractAfter(allNames,['BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MUT_SEED_' num2str(seed) '_' ]),'.mat')))];
end
[~,i]      = sort(totalNumVec,'descend');
seedSorted = seedsConverged(i);
totalNumVecSorted = totalNumVec(i);
seedPick   = seedSorted;
%%
for seed = seedPick
    
    fileinfoBefore = dir(['./cluster_output/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MUT_SEED_' num2str(seed) '_*.mat']);
    totalNum       = size(fileinfoBefore,1);
    load(['./cluster_output/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MUT_SEED_' num2str(seed) '_' num2str(totalNumVecSorted(seedSorted==seed)) '.mat']);
    figure(seed+1)
    plot(maxFitnessKeep,'k')
    hold on;
    plot(meanFitnessKeep,'r')
    grid on;
end
