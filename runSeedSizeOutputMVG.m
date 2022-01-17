function [] = runSeedSizeOutputMVG(seed,outputMat_1,outputMat_2,numOfInputs,numOfOutputs,numOfGates,numOfCandidateSolutions,mult,preDefinedSize,freqAlternate,L,mutProb,onlyChangeConnections)
% availableGPUs = gpuDeviceCount("available");
% disp(['---------------- Number of available GPUs : ' num2str(availableGPUs) ' ----------------'])
% parpool('local',availableGPUs);
% parpool('local')
rng(seed);
clearvars -except seed outputMat_1 outputMat_2 numOfInputs numOfOutputs numOfGates numOfRuns numOfCandidateSolutions mult preDefinedSize freqAlternate L mutProb onlyChangeConnections
disp(['---------------- Simulating seed ' num2str(seed) ' with mutation prob : ' num2str(mutProb) ' ----------------'])
% EVOLUTION
% The random mutations (always respecting the back- ward patterning) can be:
% (a) elimination of an existing connection, with probability Ec,
% (b) creation of a new connection with probability Cc,
% (c) elimination of a node (gate removal) with probability In, and
% (d) creation of a new node (gate addition) with probability Cn.
% For this one, we use Ec=Cc=In=Cn=0.5.

% mutation #1 - change connections
% mutation #2 - remove gate
% mutation #3 - add gate

maxFitnessKeep  = [];
meanFitnessKeep = [];
if(onlyChangeConnections==0)
    weightMutations = [(1-mutProb) mutProb/3 mutProb/3 mutProb/3]; %mutProb is the chance of mutation per genome
else
    weightMutations = [(1-mutProb) mutProb 0 0]; %Only randomly change wires and start from 11 NAND gates already
end
sim = 1;
[keepCircuits,keepStructure,keepNumOfLayers,textCircuits,strAllText] = generateRandomCircuits(numOfInputs,numOfOutputs,numOfGates,numOfCandidateSolutions);

fittestStructurePick = [0 4;1 2;2 4;3 2;4 2;5 1];
llsearch=find(keepNumOfLayers==5);
for ll=llsearch
    if(sum(sum(abs(keepStructure{ll}-fittestStructurePick)))==0)
        disp(['---------------- seed ' num2str(seed) ', initialization complete, similar structure to possible modular solution found. ----------------'])
    end
end

outputMat       = outputMat_1;% start with output outputMat_1
[fitness,~]     = calculateFitnessAndFaultTolerance(textCircuits,keepStructure,outputMat,0);
circuitSizesVec = [];
for k=1:size(keepStructure,2)
    keepStructure_temp=keepStructure{k};
    circuitSizesVec = [circuitSizesVec sum(keepStructure_temp(2:end,2))];
end
fitness                     = fitness-mult.*(circuitSizesVec>preDefinedSize);
% other alternatives?
% fitness                     = fitness-mult.*(circuitSizesVec-min(circuitSizesVec));
% fitness                     = fitness-mult.*circuitSizesVec;
textCircuitsMutated         = textCircuits;
structuresMutated           = keepStructure;
maxFitness                  = max(fitness,[],2); % max fitness
[sortedFitness,sortedIndex] = sort(fitness,'descend'); % mean fitness
meanFitness                 = mean(sortedFitness);
% fittestCircuitIdx    = datasample(find(fitness(sim,:)==maxFitness),1); % sample one if multiple
fittestCircuitIdx    = sortedIndex(1:L); %take the first L solutions
fittestCircuitIdx    = sort(fittestCircuitIdx);
fittestStructure     = structuresMutated(fittestCircuitIdx);
logicalArray         = cell2mat(textCircuitsMutated(:,1))==fittestCircuitIdx;
fittestTextCircuit   = textCircuitsMutated(orColumns(logicalArray),:);

maxFitnessKeep              = [maxFitnessKeep maxFitness];
meanFitnessKeep             = [meanFitnessKeep meanFitness];

disp(['---------------- seed ' num2str(seed) ', initialization complete, max fitness ' num2str(maxFitness) ', mean fitness ' num2str(meanFitness) ' ----------------'])

if(mutProb==0)
    save(['/net/cephfs/data/btepek/DISTRIBUTEDROBUSTNESS/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MVG_SEED_' num2str(seed) '_' num2str(sim) '.mat'])
else
    save(['/net/cephfs/data/btepek/DISTRIBUTEDROBUSTNESS/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MVG_MUT_SEED_' num2str(seed) '_' num2str(sim) '.mat'])
end

% drawCircuit_text_Ind(fittestTextCircuit,fittestStructure,1:L) %fittest

sim = 2;
% while(maxFitness<1)
% while(sim<1e4)
while(sim<5*1e4)
    
    if(logical(mod(floor((sim-1)./freqAlternate),2)))
        outputMat  = outputMat_2;% switch to outputMat_2
        disp(['---------------- simulation ' num2str(sim) ' , using output #' num2str(2) ' ----------------'])
    else
        outputMat  = outputMat_1;% switch to outputMat_1
        disp(['---------------- simulation ' num2str(sim) ' , using output #' num2str(1) ' ----------------'])
    end
    
    %     disp(['---------------- seed ' num2str(seed) ', at simulation ' num2str(sim) ' ----------------'])
    
    structuresMutated       = [];
    indexColumnCircuit      = cell2mat(fittestTextCircuit(:,1));
    indexColumnCircuitUnq   = unique(indexColumnCircuit);
    indexColumnCircuitNew   = [];
    replicationPerCircuit   = numOfCandidateSolutions/length(indexColumnCircuitUnq);
    
    for c=1:length(indexColumnCircuitUnq)
        indexColumnCircuitNew(indexColumnCircuit==indexColumnCircuitUnq(c))=1+(c-1)*replicationPerCircuit;
        structuresMutated{1+(c-1)*replicationPerCircuit} = fittestStructure{c};
    end
    fittestTextCircuit(:,1) = num2cell(indexColumnCircuitNew); % index as 1
    textCircuitsMutated     = fittestTextCircuit;
    circuitSizesVec         = [];
    
    for c=1:length(indexColumnCircuitUnq)
        mutationIndexVec       = datasample(0:3,replicationPerCircuit-1,'Weights',weightMutations,'Replace',true);
        fittestTextCircuitTemp = fittestTextCircuit(cell2mat(fittestTextCircuit(:,1))==(1+(c-1)*replicationPerCircuit),:);
        fittestStructureTemp   = structuresMutated{1+(c-1)*replicationPerCircuit};
        circuitSizesVec((c-1)*replicationPerCircuit+1) = sum(fittestStructureTemp(2:end,2));
        for mut=1:length(mutationIndexVec)
            [textCircuitsTemp_mutated,structureTemp_mutated] = mutateCircuit(fittestTextCircuitTemp,fittestStructureTemp,mutationIndexVec(mut));
            indexColumnCircuit            = cell2mat(textCircuitsTemp_mutated(:,1));
            textCircuitsTemp_mutated(:,1) = num2cell((indexColumnCircuit-1)+(mut+1)*ones(size(indexColumnCircuit))); %indexing
            textCircuitsMutated           = [textCircuitsMutated;textCircuitsTemp_mutated];
            structuresMutated{mut+(c-1)*replicationPerCircuit+1} = structureTemp_mutated;
            circuitSizesVec(mut+(c-1)*replicationPerCircuit+1)=sum(structureTemp_mutated(2:end,2));
        end
    end
    
    [~,ii]=sort(cell2mat(textCircuitsMutated(:,1)),'ascend');
    textCircuitsMutatedOrdered=textCircuitsMutated(ii,:);
    textCircuitsMutated = textCircuitsMutatedOrdered;
    [fitnessTemp,~]     = calculateFitnessAndFaultTolerance(textCircuitsMutated,structuresMutated,outputMat,0);
    fitnessTemp         = fitnessTemp-mult.*(circuitSizesVec>preDefinedSize);
    
    maxFitness                  = max(fitnessTemp,[],2); % max fitness
    [sortedFitness,sortedIndex] = sort(fitnessTemp,'descend'); % mean fitness
    meanFitness                 = mean(sortedFitness);
    
    maxFitnessKeep              = [maxFitnessKeep maxFitness];
    meanFitnessKeep             = [meanFitnessKeep meanFitness];
    
    
    fittestCircuitIdx    = sortedIndex(1:L); %take the first L solutions
    fittestCircuitIdx    = sort(fittestCircuitIdx);
    fittestStructure     = structuresMutated(fittestCircuitIdx);
    logicalArray         = cell2mat(textCircuitsMutated(:,1))==fittestCircuitIdx;
    fittestTextCircuit   = textCircuitsMutated(orColumns(logicalArray),:);
    
    disp(['---------------- seed ' num2str(seed) ', simulation ' num2str(sim) ' complete, max fitness ' num2str(maxFitness) ', mean fitness ' num2str(meanFitness) ' ----------------'])
    
    if(mod(sim,20)==0) %save every x
        if(mutProb==0)
            save(['/net/cephfs/data/btepek/DISTRIBUTEDROBUSTNESS/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MVG_SEED_' num2str(seed) '_' num2str(sim) '.mat'])
        else
            save(['/net/cephfs/data/btepek/DISTRIBUTEDROBUSTNESS/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MVG_MUT_SEED_' num2str(seed) '_' num2str(sim) '.mat'])
        end
    end
    sim = sim + 1;
end
save(['/net/cephfs/data/btepek/DISTRIBUTEDROBUSTNESS/BEFORE_TOL_ALL_SIZE_MVG_SEED_' num2str(seed) '.mat'])
disp(['---------------- seed ' num2str(seed) ', max fitness of 1 achieved, now check fault tolerance convergence ----------------'])
end

