function [] = runSeedOutput(seed,outputMat,numOfInputs,numOfOutputs,numOfGates,numOfRuns,numOfCandidateSolutions)
% availableGPUs = gpuDeviceCount("available");
% disp(['---------------- Number of available GPUs : ' num2str(availableGPUs) ' ----------------'])
% parpool('local',availableGPUs);
% parpool('local')
rng(seed);
clearvars -except seed outputMat numOfInputs numOfOutputs numOfGates numOfRuns numOfCandidateSolutions
disp(['---------------- Simulating seed ' num2str(seed) ' ----------------'])
% EVOLUTION
% The random mutations (always respecting the back- ward patterning) can be:
% (a) elimination of an existing connection, with probability Ec,
% (b) creation of a new connection with probability Cc,
% (c) elimination of a node (gate removal) with probability In, and
% (d) creation of a new node (gate addition) with probability Cn.
% Here, we use Ec=0.8, Cc=0.8, In=0.3 and Cn=0.6.

% prob of mutation #1 0.8
% prob of mutation #2 0.3
% prob of mutation #3 0.6
sim = 1;
[keepCircuits,keepStructure,keepNumOfLayers,textCircuits,strAllText] = generateRandomCircuits(numOfInputs,numOfOutputs,numOfGates,numOfRuns,numOfCandidateSolutions);
[fitness,~]                 = calculateFitnessAndFaultTolerance(textCircuits,keepStructure,outputMat,0);
textCircuitsMutated         = textCircuits;
structuresMutated           = keepStructure;
 
% find max fitness
maxFitness           = max(fitness(sim,:),[],2);
fittestCircuitIdx    = datasample(find(fitness(sim,:)==maxFitness),1); % sample one if multiple
fittestStructure     = structuresMutated{fittestCircuitIdx};
fittestTextCircuit   = textCircuitsMutated(cell2mat(textCircuitsMutated(:,1))==fittestCircuitIdx,:);

% fitness and fault tolerance of the fittest
fitnessPick               = fitness(sim,fittestCircuitIdx);
[~,faultToleranceInitial] = calculateFitnessAndFaultTolerance(fittestTextCircuit,fittestStructure,outputMat,1);
faultTolerancePick        = faultToleranceInitial(fittestCircuitIdx);

% % plot the initial circuit?
% h=figure('visible','off');
% set(h, 'Position',  [100, 300, 1200, 1000])
% axis tight manual % this ensures that getframe() returns a consistent size
% connectionMatInitial = drawCircuit_text(fittestStructure,fittestTextCircuit,1);
% saveas(h,['CIRCUIT_SEED_ ' num2str(seed) '_INITIAL.png'])


[keepOutput,keepAllOutput]   = solvePerturbedCircuit(1,fittestTextCircuit(:,2:3),fittestStructure,0);
[degeneracy,degeneracy2,degeneracy3,degeneracyUB,redundancy,complexity,complexity2,circuitSize,IsubOne,IallFinal,IsubMatKeep,IsubsubHatMatKeep,IsubHatMatKeep] = calculateDegeneracy(keepOutput,keepAllOutput,fittestStructure);
disp(['---------------- seed ' num2str(seed) ', initialization complete, max fitness ' num2str(maxFitness) ' with index ' num2str(fittestCircuitIdx) ' ----------------'])
disp(['---------------- degeneracy 1,2,3,UB : ' num2str(degeneracy) ' '  num2str(degeneracy2) ' '  num2str(degeneracy3) ' ' num2str(degeneracyUB) ' , redundancy : ' num2str(redundancy) ' ----------------'])

save(['/net/cephfs/data/btepek/DISTRIBUTEDROBUSTNESS/BEFORE_TOL_FITTEST_CIRCUIT_SEED_' num2str(seed) '_' num2str(sim) '.mat'])

sim = 2;
while(maxFitness<1)
    disp(['---------------- seed ' num2str(seed) ', at simulation ' num2str(sim-1) ' ----------------'])
    
    structuresMutated       = [];
    
    indexColumnCircuit      = cell2mat(fittestTextCircuit(:,1));
    fittestTextCircuit(:,1) = num2cell(ones(size(indexColumnCircuit))); % index as 1
    textCircuitsMutated     = fittestTextCircuit;
    structuresMutated{1}    = fittestStructure;
    
    mutationIndexVec = datasample(1:3,numOfCandidateSolutions-1,'Weights',[0.8 0.3 0.6],'Replace',true);
    for mut=1:numOfCandidateSolutions-1
        [textCircuitsTemp_mutated,structureTemp_mutated] = mutateCircuit(fittestTextCircuit,fittestStructure,mutationIndexVec(mut));
        indexColumnCircuit            = cell2mat(textCircuitsTemp_mutated(:,1));
        textCircuitsTemp_mutated(:,1) = num2cell((mut+1)*ones(size(indexColumnCircuit))); %indexing
        textCircuitsMutated           = [textCircuitsMutated;textCircuitsTemp_mutated];
        structuresMutated{mut+1}      = structureTemp_mutated;
    end
    
    [fitnessTemp,~]      = calculateFitnessAndFaultTolerance(textCircuitsMutated,structuresMutated,outputMat,0);
    fitness(sim,:)       = fitnessTemp;
    maxFitness           = max(fitness(sim,:),[],2);
    fittestCircuitIdx    = datasample(find(fitness(sim,:)==maxFitness),1); % sample one if multiple
    fittestStructure     = structuresMutated{fittestCircuitIdx};
    fittestTextCircuit   = textCircuitsMutated(cell2mat(textCircuitsMutated(:,1))==fittestCircuitIdx,:);
    
    % fitness and fault tolerance of the fittest
    fitnessPick                   = fitness(sim,fittestCircuitIdx);
    [~,faultToleranceTemp]        = calculateFitnessAndFaultTolerance(fittestTextCircuit,fittestStructure,outputMat,1);
    faultTolerancePick            = faultToleranceTemp(fittestCircuitIdx);
    
    [keepOutput,keepAllOutput]   = solvePerturbedCircuit(1,fittestTextCircuit(:,2:3),fittestStructure,0);
    [degeneracy,degeneracy2,degeneracy3,degeneracyUB,redundancy,complexity,complexity2,circuitSize,IsubOne,IallFinal,IsubMatKeep,IsubsubHatMatKeep,IsubHatMatKeep,HsubsubHatMatKeep,HsubMatKeep,HsubHatMatKeep,HJointMatKeep,HJointHatMatKeep,HJointAllMatKeep,HOutputMatKeep] = calculateDegeneracy(keepOutput,keepAllOutput,fittestStructure);
    
    [keepOutput outputMat]
    
    disp(['---------------- seed ' num2str(seed) ', simulation ' num2str(sim-1) ' complete, max fitness ' num2str(maxFitness) ' with index ' num2str(fittestCircuitIdx) ' ----------------'])
    disp(['---------------- degeneracy 1,2,3,UB : ' num2str(degeneracy) ' '  num2str(degeneracy2) ' '  num2str(degeneracy3) ' ' num2str(degeneracyUB) ' , redundancy : ' num2str(redundancy) ' ----------------'])
    save(['/net/cephfs/data/btepek/DISTRIBUTEDROBUSTNESS/BEFORE_TOL_FITTEST_CIRCUIT_SEED_' num2str(seed) '_' num2str(sim) '.mat'])
    sim = sim + 1;
    

end

save(['/net/cephfs/data/btepek/DISTRIBUTEDROBUSTNESS/BEFORE_TOL_ALL_SEED_' num2str(seed) '.mat'])
disp(['---------------- seed ' num2str(seed) ', max fitness of 1 achieved, now check fault tolerance convergence ----------------'])
%%
% clearvars -except seed
% load(['BEFORE_TOL_ALL_SEED_' num2str(seed) '.mat'])
% sim
sumDiffTolerance    = 1; % to enter the loop
sumDiffIndex        = 1; % to enter the loop
tolMeanTolerance    = 0;
tolTolerance        = 0.60; %?
tolLength           = 4;
keepFaultTolerance  = [];
keepIndex           = [];
faultTolerance      = [];
while(sumDiffTolerance>0 || sumDiffIndex>0 || tolMeanTolerance<tolTolerance)
    disp(['---------------- seed ' num2str(seed) ', at simulation ' num2str(sim-1) ' ----------------'])
    
    structuresMutated       = [];
    
    indexColumnCircuit      = cell2mat(fittestTextCircuit(:,1));
    fittestTextCircuit(:,1) = num2cell(ones(size(indexColumnCircuit))); % index as 1
    textCircuitsMutated     = fittestTextCircuit;
    structuresMutated{1}    = fittestStructure;
    
    mutationIndexVec = datasample(1:3,numOfCandidateSolutions-1,'Weights',[0.8 0.3 0.6],'Replace',true);
    for mut=1:numOfCandidateSolutions-1
        [textCircuitsTemp_mutated,structureTemp_mutated] = mutateCircuit(fittestTextCircuit,fittestStructure,mutationIndexVec(mut));
        indexColumnCircuit            = cell2mat(textCircuitsTemp_mutated(:,1));
        textCircuitsTemp_mutated(:,1) = num2cell((mut+1)*ones(size(indexColumnCircuit))); %indexing
        textCircuitsMutated           = [textCircuitsMutated;textCircuitsTemp_mutated];
        structuresMutated{mut+1}      = structureTemp_mutated;
    end
    
    [fitnessTemp,faultToleranceTemp] = calculateFitnessAndFaultTolerance(textCircuitsMutated,structuresMutated,outputMat,1);
    
    fitness(sim,:)        = fitnessTemp;
    faultTolerance(sim,:) = faultToleranceTemp;
    fittestIdxs           = find(fitness(sim,:)==1); %we know that max is 1 now
    maxTolerance          = max(faultTolerance(sim,fittestIdxs),[],2); %among the fittest
    tolerantIdxs          = find(faultTolerance(sim,:)==maxTolerance);
    intersectIdxs         = intersect(fittestIdxs,tolerantIdxs);
    if(~isempty(intersectIdxs))
        disp(['----------------  seed ' num2str(seed) ', Intersection between the fittest and the most tolerant, sampling from the fittest AND the most tolerant  ----------------'])
        if(ismember(1,intersectIdxs))
            fittestCircuitIdx = 1;
        else
            fittestCircuitIdx     = datasample(intersectIdxs,1);
        end
    else
        disp(['----------------  seed ' num2str(seed) ', No intersection between the fittest and the most tolerant, sampling from the fittest  ----------------'])
        fittestCircuitIdx     = datasample(fittestIdxs,1);
    end
    
    fittestStructure     = structuresMutated{fittestCircuitIdx};
    fittestTextCircuit   = textCircuitsMutated(cell2mat(textCircuitsMutated(:,1))==fittestCircuitIdx,:);
    
    % fitness and fault tolerance of the fittest
    fitnessPick        = fitness(sim,fittestCircuitIdx);
    faultTolerancePick = faultTolerance(sim,fittestCircuitIdx);
    
    [keepOutput,keepAllOutput]   = solvePerturbedCircuit(1,fittestTextCircuit(:,2:3),fittestStructure,0);
    [degeneracy,degeneracy2,degeneracy3,degeneracyUB,redundancy,complexity,complexity2,circuitSize,IsubOne,IallFinal,IsubMatKeep,IsubsubHatMatKeep,IsubHatMatKeep,HsubsubHatMatKeep,HsubMatKeep,HsubHatMatKeep,HJointMatKeep,HJointHatMatKeep,HJointAllMatKeep,HOutputMatKeep] = calculateDegeneracy(keepOutput,keepAllOutput,fittestStructure);
    
    [keepOutput outputMat]
    
    keepFaultTolerance    = [keepFaultTolerance faultTolerance(sim,fittestCircuitIdx)];
    keepIndex             = [keepIndex fittestCircuitIdx];
    disp(['---------------- seed ' num2str(seed) ', simulation ' num2str(sim-1) ' complete, max fitness ' num2str(maxFitness) ' with index ' num2str(fittestCircuitIdx) ', with fault tolerance ' num2str(faultTolerance(sim,fittestCircuitIdx)) ' ----------------'])
    disp(['---------------- degeneracy 1,2,3,UB : ' num2str(degeneracy) ' '  num2str(degeneracy2) ' '  num2str(degeneracy3) ' ' num2str(degeneracyUB) ' , redundancy : ' num2str(redundancy) ' ----------------'])
    
    if(length(keepFaultTolerance)>tolLength) %get the diff of last tolerance values
        faultToleranceDiff = diff(keepFaultTolerance((end-tolLength):end));
        indexDiff          = diff(keepIndex((end-tolLength):end));
        sumDiffTolerance   = sum(abs(faultToleranceDiff));
        sumDiffIndex       = sum(abs(indexDiff)); %fittestCircuitIdx will be 1 for max(tolLength+1) and min(tolLength) times if same circuit converges
        tolMeanTolerance   = mean(keepFaultTolerance((end-tolLength):end));
    end
    save(['/net/cephfs/data/btepek/DISTRIBUTEDROBUSTNESS/AFTER_TOL_FITTEST_CIRCUIT_SEED_' num2str(seed) '_' num2str(sim) '.mat'])
    sim = sim + 1;
end

disp(['---------------- seed ' num2str(seed) ', Tolerance converged, getting out of here. ----------------'])
fittestStructureFinal     = structuresMutated{fittestCircuitIdx};
fittestTextCircuitFinal   = textCircuitsMutated(cell2mat(textCircuitsMutated(:,1))==fittestCircuitIdx,:);
save(['/net/cephfs/data/btepek/DISTRIBUTEDROBUSTNESS/AFTER_TOL_ALL_SEED_' num2str(seed) '.mat'])

end


