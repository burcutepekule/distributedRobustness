function [keepVec] = runSeedPlay(seed)
% availableGPUs = gpuDeviceCount("available");
% disp(['---------------- Number of available GPUs : ' num2str(availableGPUs) ' ----------------'])
% parpool('local',availableGPUs);
% parpool('local')
rng(seed);
clearvars -except seed
disp(['---------------- Simulating seed ' num2str(seed) ' ----------------'])
numOfInputs    = 2; %number of inputs
numOfOutputs   = 2; %number of outputs
numOfGates     = 5; %number of NAND gates to start with
numOfRuns      = 1000; %number of trials
numOfCandidateSolutions = 100; %number of candidate solutions (generate here, this cannot be in a function since needs to be constant)
outputMat = randn([2^numOfInputs,numOfOutputs])>0; %Random Input - Output truthtable
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
[fitness,faultTolerance] = calculateFitnessAndFaultTolerance(textCircuits,keepStructure,numOfInputs,outputMat,0);
keepVec = [];
for fittestCircuitIdx=1:numOfCandidateSolutions
    fittestStructure             = keepStructure{fittestCircuitIdx};
    fittestTextCircuit           = textCircuits(cell2mat(textCircuits(:,1))==fittestCircuitIdx,:);
    [keepOutput,keepAllOutput]   = solvePerturbedCircuit(numOfInputs,1,fittestTextCircuit(:,2:3),fittestStructure,0);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FOR OPTION 0 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [degeneracy,degeneracy2,degeneracyUB,redundancy,complexity,circuitSize] = calculateDegeneracy(keepOutput,keepAllOutput,fittestStructure);
    keepVec = [keepVec;[degeneracy,degeneracy2,degeneracyUB,redundancy,complexity,circuitSize,fitness(fittestCircuitIdx)]];
    %     [degeneracy3,~] = calculateDegeneracyIncSize(keepOutput,keepAllOutput,fittestTextCircuit,fittestStructure);
    h=figure('visible','off');
    set(h, 'Position',  [100, 300, 1200, 1000])
    axis tight manual % this ensures that getframe() returns a consistent size
    connectionMatBeforeTol = drawCircuit_text(fittestStructure,fittestTextCircuit,numOfOutputs,1);
    saveas(h,['./cluster/CIRCUIT_SEED_ ' num2str(seed) '_' num2str(fittestCircuitIdx) '.png'])
end

end


