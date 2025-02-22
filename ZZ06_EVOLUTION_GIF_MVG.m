clear all;close all;clc;
fileinfoRDC    = dir(['./cluster_output/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MVG_MUT_SEED_*.mat']);
allNames       = {fileinfoRDC.name};
seedsConverged = unique(str2double(extractBefore(extractAfter(allNames,'BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MVG_MUT_SEED_'),'_')));
seedsConverged = seedsConverged(seedsConverged>=100); %both sizeVec=1 and sizeVec=0, occ=0

totalNumVec = [];
for seedId = 1:length(seedsConverged)
    seed = seedsConverged(seedId);
    fileinfoBefore = dir(['./cluster_output/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MVG_MUT_SEED_' num2str(seed) '_*.mat']);
    allNames       = {fileinfoBefore.name};
    totalNumVec    = [totalNumVec max(str2double(extractBefore(extractAfter(allNames,['BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MVG_MUT_SEED_' num2str(seed) '_' ]),'.mat')))];
    % DELETE THE FILES BEFORE LAST SAVED FILE FOR SPACE
    largestSimName = ['BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MVG_MUT_SEED_' num2str(seed) '_' num2str(totalNumVec(end)) '.mat'];
    allNames2Delete= setdiff(allNames,largestSimName);
    if(~isempty(allNames2Delete))
        for l=1:size(allNames2Delete,2)
        delete(['./cluster_output/' allNames2Delete{l}])
        end
    end
end
[~,i]      = sort(totalNumVec,'descend');
seedSorted = seedsConverged(i);
totalNumVecSorted = totalNumVec(i);
seedSortedKeep = seedSorted;

%%
seedSorted = seedSortedKeep(seedSortedKeep>=100 & seedSortedKeep<150);%sizeVec=0, occ=0
% seedSorted = seedSortedKeep(seedSortedKeep>=200);%sizeVec=1, occ=0
seedPick   = seedSorted(1:end);
% seedPick = [3 9]; %3 and 9
totalNumVecSortedPick = totalNumVecSorted(ismember(seedSortedKeep,seedPick));

for seed = seedPick
    
    fileinfoBefore = dir(['./cluster_output/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MVG_MUT_SEED_' num2str(seed) '_*.mat']);
    load(['./cluster_output/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MVG_MUT_SEED_' num2str(seed) '_' num2str(totalNumVecSortedPick(seedPick==seed)) '.mat']);
    figure(seed+1)
    plot(freqAlternate:freqAlternate:totalNumVecSortedPick(seedPick==seed),maxFitnessKeep(freqAlternate:freqAlternate:end),'k')
    hold on;
    plot(freqAlternate:freqAlternate:totalNumVecSortedPick(seedPick==seed),meanFitnessKeep(freqAlternate:freqAlternate:end),'r')
    grid on;
    axis([0 totalNumVecSortedPick(seedPick==seed) 0.65 1.05])
    
end
%% GIF
% seedPickGIF=[105 112 115 116 130 205 231 236];
seedPickGIF=[130 205 231 236];
for seed = seedPickGIF
    close all;
    totalNumVecSortedPick = totalNumVecSorted(ismember(seedSortedKeep,seed));
    printGIF_MVG(totalNumVecSortedPick,freqAlternate,seed)
end
