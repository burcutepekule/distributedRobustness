clear all;close all;clc;
fileinfoRDC    = dir(['./cluster_output/BEFORE_TOL_ALL_SEED_*.mat']);
allNames       = {fileinfoRDC.name};
seedsConverged = str2double(extractBefore(extractAfter(allNames,'BEFORE_TOL_ALL_SEED_'),'.mat'));

totalNumVec = [];
for seed = seedsConverged
    fileinfoBefore = dir(['./cluster_output/BEFORE_TOL_FITTEST_CIRCUIT_SEED_' num2str(seed) '_*.mat']);
    lastIdx        = size(fileinfoBefore,1);
    totalNumVec    = [totalNumVec size(fileinfoBefore,1)];
end
[~,i]             = sort(totalNumVec,'descend');
seedSorted        = seedsConverged(i);
totalNumVecSorted = totalNumVec(i);
seedPick          = seedSorted(1);
%%
for seed = seedPick
    
    fitnessVals    = [];
    degeneracyVals = [];
    complexityVals = [];
    redundancyVals = [];
    toleranceVals  = [];
    circuitSizeVals= [];
    
    fileinfoBefore = dir(['./cluster_output/BEFORE_TOL_FITTEST_CIRCUIT_SEED_' num2str(seed) '_*.mat']);
    lastIdx        = size(fileinfoBefore,1);
    totalNum       = size(fileinfoBefore,1);
    
    % KEEP THE VARIABLES FIRST TO DETERMINE THE MIN / MAX VALUES
    for simIdx=1:totalNum
        [seed simIdx totalNum]
            load(['./cluster_output/BEFORE_TOL_FITTEST_CIRCUIT_SEED_' num2str(seed) '_' num2str(simIdx) '.mat']);
        
        fittestStructure     = structuresMutated{fittestCircuitIdx};
        fittestTextCircuit   = textCircuitsMutated(cell2mat(textCircuitsMutated(:,1))==fittestCircuitIdx,:);
        
        fitnessVals    = [fitnessVals fitnessPick];
        degeneracyVals = [degeneracyVals degeneracy];
        complexityVals = [complexityVals complexity];
        redundancyVals = [redundancyVals redundancy];
        toleranceVals  = [toleranceVals faultTolerancePick];
        circuitSizeVals= [circuitSizeVals circuitSize];
    end
    
    
end

