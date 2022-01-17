clear all;close all;clc;
fileinfoRDC    = dir(['./local_output/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MVG_SEED_*.mat']);
allNames       = {fileinfoRDC.name};
seedsConverged = unique(str2double(extractBefore(extractAfter(allNames,'BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MVG_SEED_'),'_')));

totalNumVec = [];
for seed = seedsConverged
    fileinfoBefore = dir(['./local_output/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MVG_SEED_' num2str(seed) '_*.mat']);
    allNames       = {fileinfoRDC.name};
    totalNumVec    = [totalNumVec max(str2double(extractBefore(extractAfter(allNames,['BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MVG_SEED_' num2str(seed) '_' ]),'.mat')))];
end
[~,i]      = sort(totalNumVec,'descend');
seedSorted = seedsConverged(i);
totalNumVecSorted = totalNumVec(i);
%%
seedPick   = 456;
for seed = seedPick 
    
    fileinfoBefore = dir(['./local_output/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MVG_SEED_' num2str(seed) '_*.mat']);
    load(['./local_output/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MVG_SEED_' num2str(seed) '_' num2str(totalNumVecSorted(seedSorted==seed)) '.mat']);
    figure
    plot(freqAlternate:freqAlternate:totalNumVecSorted(seedSorted==seed),maxFitnessKeep(freqAlternate:freqAlternate:end),'k')
    hold on;
    plot(freqAlternate:freqAlternate:totalNumVecSorted(seedSorted==seed),meanFitnessKeep(freqAlternate:freqAlternate:end),'r')
    grid on;
end
%%
seed = seedPick(1);
pickIdx      = 1;

close all;
seedsFittest = unique(cell2mat(fittestTextCircuit(:,1)));
seedFittest  = seedsFittest(pickIdx);

for it=[1 10:100:totalNumVecSorted(seedSorted==seed)]
load(['./local_output/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MVG_SEED_' num2str(seed) '_' num2str(it) '.mat']);
close all;

fittestTextCircuitPick = fittestTextCircuit(cell2mat(fittestTextCircuit(:,1))==cell2mat(fittestTextCircuit(1,1)),:);
fittestStructurePick   = fittestStructure{pickIdx};
figure(it)
drawCircuit_text(fittestStructurePick,fittestTextCircuitPick,1);

pause

end