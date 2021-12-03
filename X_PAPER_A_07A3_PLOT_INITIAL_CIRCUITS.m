clear all;close all;clc;
fileinfoRDC    = dir(['./cluster/BEFORE_TOL_FITTEST_CIRCUIT_SEED_*_1.mat']);
allNames       = {fileinfoRDC.name};
seedsConverged = sort(str2double(extractBefore(extractAfter(allNames,'BEFORE_TOL_FITTEST_CIRCUIT_SEED_'),'_1.mat')));
keepAll        = [];
%%
for s=seedsConverged
    s
    load(['./cluster/BEFORE_TOL_FITTEST_CIRCUIT_SEED_' num2str(s) '_1.mat'])
    fittestStructure     = structuresMutated{fittestCircuitIdx};
    fittestTextCircuit   = textCircuitsMutated(cell2mat(textCircuitsMutated(:,1))==fittestCircuitIdx,:);
    
%     [keepOutput,keepAllOutput] = solvePerturbedCircuit(numOfInputs,1,fittestTextCircuit(:,2:3),fittestStructure,0);
%     checkStatisticalIndependence(keepAllOutput,fittestStructure)
% %     [fitness,faultTolerance] = calculateFitnessAndFaultTolerance(fittestTextCircuit,fittestStructure,numOfInputs,keepOutput,1);
%     [degeneracy,degeneracy2,degeneracyUB,redundancy,complexity,circuitSize] = calculateDegeneracy(keepOutput,keepAllOutput,fittestStructure);
%     keepAll = [keepAll; [degeneracy,degeneracy2,degeneracyUB,redundancy,complexity,circuitSize]];
    
        h=figure('visible','off');
        set(h, 'Position',  [100, 300, 1200, 1000])
        axis tight manual % this ensures that getframe() returns a consistent size
        connectionMatBeforeTol = drawCircuit_text(fittestStructure,fittestTextCircuit,numOfOutputs,1);
        saveas(h,['./cluster/CIRCUIT_SEED_ ' num2str(seed) '_INITIAL.png'])
end
%%
% scatter(keepAll(:,4),keepAll(:,1),20,'k','filled')
% axis equal