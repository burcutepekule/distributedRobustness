clear all;close all;clc;
fileinfoRDC    = dir(['./local_output/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_SEED_*.mat']);
allNames       = {fileinfoRDC.name};
seedsConverged = unique(str2double(extractBefore(extractAfter(allNames,'BEFORE_TOL_FITTEST_CIRCUIT_SIZE_SEED_'),'_')));

totalNumVec = [];
for seed = seedsConverged
    fileinfoBefore = dir(['./local_output/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_SEED_' num2str(seed) '_*.mat']);
    allNames       = {fileinfoRDC.name};
    totalNumVec    = [totalNumVec max(str2double(extractBefore(extractAfter(allNames,['BEFORE_TOL_FITTEST_CIRCUIT_SIZE_SEED_' num2str(seed) '_' ]),'.mat')))];
end
[~,i]      = sort(totalNumVec,'descend');
seedSorted = seedsConverged(i);
totalNumVecSorted = totalNumVec(i);
seedPick   = seedSorted(1);

for seed = seedPick
    
    fileinfoBefore = dir(['./local_output/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_SEED_' num2str(seed) '_*.mat']);
    totalNum       = size(fileinfoBefore,1);
    load(['./local_output/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_SEED_' num2str(seed) '_' num2str(totalNumVecSorted(seedSorted==seed)) '.mat']);
    plot(maxFitnessKeep)
    hold on;
    plot(meanFitnessKeep)
    
end
