function [] = runSeed(seed)
% availableGPUs = gpuDeviceCount("available");
% disp(['---------------- Number of available GPUs : ' num2str(availableGPUs) ' ----------------'])
% parpool('local',availableGPUs);
% parpool('local')
rng(seed);
clearvars -except seed
disp(['---------------- Simulating seed ' num2str(seed) ' ----------------'])
numOfInputs    = 3; %number of inputs
numOfOutputs   = 2; %number of outputs
numOfGates     = 5; %number of NAND gates to start with
numOfRuns      = 500; %number of trials
numOfCandidateSolutions = 10; %number of candidate solutions (generate here, this cannot be in a function since needs to be constant)
outputMat = randn([2^numOfInputs,numOfOutputs])>0; %Random Input - Output truthtable
numSims   = 1000;
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
[fitness,faultTolerance]    = calculateFitnessAndFaultTolerance(textCircuits,keepStructure,numOfInputs,outputMat,0);
fittestCircuitIdx           = datasample(find(fitness(sim,:)==max(fitness(sim,:))),1); % sample one if multiple
fittestStructureInitial     = keepStructure{fittestCircuitIdx};
fittestTextCircuitInitial   = textCircuits(cell2mat(textCircuits(:,1))==fittestCircuitIdx,:);

keepCircuitsMutated = keepCircuits;
textCircuitsMutated = textCircuits;
structuresMutated   = keepStructure;
maxFitness          = max(fitness(sim,:),[],2);
disp(['---------------- seed ' num2str(seed) ', initialization complete, max fitness ' num2str(maxFitness) ' with index ' num2str(fittestCircuitIdx) ' ----------------'])
save(['BEFORE_TOL_FITTEST_CIRCUIT_SEED_' num2str(seed) '_' num2str(sim) '.mat'])

sim = 2;
while(maxFitness<1)
    disp(['---------------- seed ' num2str(seed) ', at simulation ' num2str(sim-1) ' ----------------'])
    fittestStructure     = structuresMutated{fittestCircuitIdx};
    fittestTextCircuit   = textCircuitsMutated(cell2mat(textCircuitsMutated(:,1))==fittestCircuitIdx,:);
    
    structuresMutated       = [];
    textCircuitsMutated     = [];
    
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
    
    [fitnessTemp,~]   = calculateFitnessAndFaultTolerance(textCircuitsMutated,structuresMutated,numOfInputs,outputMat,0);
    fitness(sim,:)    = fitnessTemp;
    maxFitness        = max(fitness(sim,:),[],2);
    fittestCircuitIdx = datasample(find(fitness(sim,:)==maxFitness),1); % sample one if multiple
    disp(['---------------- seed ' num2str(seed) ', simulation ' num2str(sim-1) ' complete, max fitness ' num2str(maxFitness) ' with index ' num2str(fittestCircuitIdx) ' ----------------'])
    save(['BEFORE_TOL_FITTEST_CIRCUIT_SEED_' num2str(seed) '_' num2str(sim) '.mat'])
    sim = sim + 1;
end

save(['BEFORE_TOL_ALL_SEED_' num2str(seed) '.mat'])
disp(['---------------- seed ' num2str(seed) ', max fitness of 1 achieved, now check fault tolerance convergence ----------------'])
%%
% clearvars -except seed
% load(['BEFORE_TOL_ALL_SEED_' num2str(seed) '.mat'])
% sim
sumDiffTolerance    = 1e6; %arbitrarily large number
tolMeanTolerance    = 0;
tolTolerance        = 0.60; %?
tolLength           = 4;
keepFaultTolerance  = [];
while(sumDiffTolerance>0 || tolMeanTolerance<tolTolerance)
    disp(['---------------- seed ' num2str(seed) ', at simulation ' num2str(sim-1) ' ----------------'])
    fittestStructure     = structuresMutated{fittestCircuitIdx};
    fittestTextCircuit   = textCircuitsMutated(cell2mat(textCircuitsMutated(:,1))==fittestCircuitIdx,:);
    
    structuresMutated       = [];
    textCircuitsMutated     = [];
    
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
    
    [fitnessTemp,faultToleranceTemp] = calculateFitnessAndFaultTolerance(textCircuitsMutated,structuresMutated,numOfInputs,outputMat,1);
    
    fitness(sim,:)        = fitnessTemp;
    faultTolerance(sim,:) = faultToleranceTemp;
    fittestIdxs           = find(fitness(sim,:)==1); %we know that it is 1 now
    maxTolerance          = max(faultTolerance(sim,fittestIdxs),[],2); %among the fittest
    tolerantIdxs          = find(faultTolerance(sim,:)==maxTolerance);
    intersectIdxs         = intersect(fittestIdxs,tolerantIdxs);
    if(~isempty(intersectIdxs))
        disp(['----------------  seed ' num2str(seed) ', Intersection between the fittest and the most tolerant, sampling from the fittest AND the most tolerant  ----------------'])
        fittestCircuitIdx     = datasample(intersectIdxs,1);
    else
        disp(['----------------  seed ' num2str(seed) ', No intersection between the fittest and the most tolerant, sampling from the fittest  ----------------'])
        fittestCircuitIdx     = datasample(fittestIdxs,1);
    end
    
    keepFaultTolerance    = [keepFaultTolerance faultTolerance(sim,fittestCircuitIdx)];
    disp(['---------------- seed ' num2str(seed) ', simulation ' num2str(sim-1) ' complete, max fitness ' num2str(maxFitness) ' with index ' num2str(fittestCircuitIdx) ', with fault tolerance ' num2str(faultTolerance(sim,fittestCircuitIdx)) ' ----------------'])
    if(length(keepFaultTolerance)>tolLength) %get the diff of last tolerance values
        faultToleranceDiff = diff(keepFaultTolerance((end-tolLength):end));
        sumDiffTolerance   = sum(abs(faultToleranceDiff));
        tolMeanTolerance   = mean(keepFaultTolerance((end-tolLength):end));
    end
    save(['AFTER_TOL_FITTEST_CIRCUIT_SEED_' num2str(seed) '_' num2str(sim) '.mat'])
    sim = sim + 1;
end

disp(['---------------- seed ' num2str(seed) ', Tolerance converged, getting out of here. ----------------'])
fittestStructureFinal     = structuresMutated{fittestCircuitIdx};
fittestTextCircuitFinal   = textCircuitsMutated(cell2mat(textCircuitsMutated(:,1))==fittestCircuitIdx,:);
save(['AFTER_TOL_ALL_SEED_' num2str(seed) '.mat'])

end


