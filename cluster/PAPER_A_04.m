clear all;close all;clc;
rng(14); 
numOfInputs    = 3; %number of inputs
numOfOutputs   = 2; %number of outputs
numOfGates     = 5; %number of NAND gates
numOfRuns      = 200; %number of trials 
numOfCandidateSolutions = 10; %number of candidate solutions
outputMat = randn([2^numOfInputs,numOfOutputs])>0; %Random Input - Output truthtable
numSims   = 1000;
%% EVOLUTION
% The random mutations (always respecting the back- ward patterning) can be:
% (a) elimination of an existing connection, with probability Ec,
% (b) creation of a new connection with probability Cc,
% (c) elimination of a node (gate removal) with probability In, and
% (d) creation of a new node (gate addition) with probability Cn.
% Here, we use Ec=0.8, Cc=0.8, In=0.3 and Cn=0.6.

% prob of mutation #1 0.8
% prob of mutation #2 0.3
% prob of mutation #3 0.6

[keepCircuits,keepStructure,keepNumOfLayers,textCircuits,strAllText] = generateRandomCircuits(numOfInputs,numOfOutputs,numOfGates,numOfRuns,numOfCandidateSolutions);
[~,keepOutput] = solveCircuit(numOfInputs,textCircuits,keepStructure);
fitness(1,:)   = 1-reshape(mean(mean(abs(keepOutput-outputMat),1),2),1,[]);
fittestCircuitIdx = datasample(find(fitness(1,:)==max(fitness(1,:))),1); % sample one if multiple

fittestStructureInitial     = keepStructure{fittestCircuitIdx};
fittestTextCircuitInitial   = textCircuits(cell2mat(textCircuits(:,1))==fittestCircuitIdx,:);

keepCircuitsMutated = keepCircuits;
textCircuitsMutated = textCircuits;
structuresMutated   = keepStructure;
%%
maxFitness = max(fitness(1,:),[],2);
for sim=2:numSims
    if(maxFitness<1)
    disp(['---------------- at simulation ' num2str(sim-1) ' ----------------'])
    fittestStructure     = structuresMutated{fittestCircuitIdx};
    fittestTextCircuit   = textCircuitsMutated(cell2mat(textCircuitsMutated(:,1))==fittestCircuitIdx,:);
    
%     if(sim>4)
%         close(1:sim-3)
%     end
%     figure(sim-1)
%     connectionMatFittest = drawCircuit_text(fittestStructure,fittestTextCircuit,numOfOutputs);
%     title(['Fittest Circuit at Sim ' num2str(sim-1)])
    
    structuresMutated       = [];
    textCircuitsMutated     = [];
    
    indexColumnCircuit      = cell2mat(fittestTextCircuit(:,1));
    fittestTextCircuit(:,1) = num2cell(ones(size(indexColumnCircuit))); % index as 1
    textCircuitsMutated     = fittestTextCircuit;
    structuresMutated{1}    = fittestStructure;
    
    mutationIndexVec = datasample(1:3,numOfCandidateSolutions-1,'Weights',[0.8 0.3 0.6],'Replace',true);
    for mut=1:numOfCandidateSolutions-1
        [textCircuitsTemp_mutated,structureTemp_mutated] = mutateCircuit(fittestTextCircuit,fittestStructure,mutationIndexVec(mut));
        indexColumnCircuit      = cell2mat(textCircuitsTemp_mutated(:,1));
        textCircuitsTemp_mutated(:,1) = num2cell((mut+1)*ones(size(indexColumnCircuit))); % indexing
        textCircuitsMutated        = [textCircuitsMutated;textCircuitsTemp_mutated];
        structuresMutated{mut+1}   = structureTemp_mutated;
    end
    
    [~,keepOutput]    = solveCircuit(numOfInputs,textCircuitsMutated,structuresMutated);
    fitness(sim,:)    = 1-reshape(mean(mean(abs(keepOutput-outputMat),1),2),1,[]);
    maxFitness        = max(fitness(sim,:),[],2);
    fittestCircuitIdx = datasample(find(fitness(sim,:)==maxFitness),1); % sample one if multiple
    disp(['---------------- simulation ' num2str(sim-1) ' complete, max fitness ' num2str(maxFitness) ' with index ' num2str(fittestCircuitIdx) ' ----------------'])
    else
        disp(['---------------- Max fitness of 1 achieved, getting out of here. ----------------'])
        break;
    end
end
fittestStructureFinal     = structuresMutated{fittestCircuitIdx};
fittestTextCircuitFinal   = textCircuitsMutated(cell2mat(textCircuitsMutated(:,1))==fittestCircuitIdx,:);
save('SIM_RNG_14_FT.mat')
%% COMPARE
clc
close all;
figure
set(gcf, 'Position',  [100, 300, 1500, 400])
subplot(1,2,1)
connectionMatInitial = drawCircuit_text(fittestStructureInitial,fittestTextCircuitInitial,numOfOutputs);
subplot(1,2,2)
connectionMatFinal   = drawCircuit_text(fittestStructureFinal,fittestTextCircuitFinal,numOfOutputs);
%%
% connectionMatInitial = drawCircuit_text(fittestStructure,fittestTextCircuit,numOfOutputs);
% 
% %%

% close all;
% textCircuitsMutated_problem = textCircuitsMutated(cell2mat(textCircuitsMutated(:,1))==9,:);
% [x,i]=sort(cell2mat(textCircuitsMutated_problem(:,2)));
% textCircuitsMutated_problem = textCircuitsMutated_problem(i,:);
% [structureMutated_problem,allGates] = text2structure(textCircuitsMutated_problem);
% 
% connectionMatProblem        = drawCircuit_text(structureMutated_problem,textCircuitsMutated_problem,2);

% % % connectionMatFinal   = drawCircuit_text(tempStructure_orig,tempCircuit_orig,2);
% % figure
% % connectionMat_mutated   = drawCircuit_text(structureTemp_mutated,textCircuitsTemp_mutated,numOfOutputs);
