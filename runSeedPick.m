function [] = runSeedPick(opt)
% availableGPUs = gpuDeviceCount("available");
% disp(['---------------- Number of available GPUs : ' num2str(availableGPUs) ' ----------------'])
% parpool('local',availableGPUs);
% parpool('local')
rng(0);
disp(['---------------- Simulating seed ' num2str(0) ' ----------------'])
numOfInputs    = 2; %number of inputs
numOfOutputs   = 2; %number of outputs
outputMat = randn([2^numOfInputs,numOfOutputs])>0; %Random Input - Output truthtable

%%
if(opt==5)
    numOfRuns  = 100000; %number of trials
    numOfCandidateSolutions = 5; %number of candidate solutions (generate here, this cannot be in a function since needs to be constant)
    numOfGates = 5; %number of NAND gates to start with
    [keepCircuits_5,keepStructure_5,keepNumOfLayers_5,textCircuits_5,strAllText_5] = generateRandomCircuits(numOfInputs,numOfOutputs,numOfGates,numOfRuns,numOfCandidateSolutions);
    [fitness_5,faultTolerance_5]    = calculateFitnessAndFaultTolerance(textCircuits_5,keepStructure_5,numOfInputs,outputMat,0);
    save('MADNESS_5.mat')
    
    %%
elseif(opt==6)
    numOfRuns  = 100000; %number of trials
    numOfCandidateSolutions = 5; %number of candidate solutions (generate here, this cannot be in a function since needs to be constant)
    numOfGates = 6; %number of NAND gates to start with
    [keepCircuits_6,keepStructure_6,keepNumOfLayers_6,textCircuits_6,strAllText_6] = generateRandomCircuits(numOfInputs,numOfOutputs,numOfGates,numOfRuns,numOfCandidateSolutions);
    [fitness_6,faultTolerance_6]    = calculateFitnessAndFaultTolerance(textCircuits_6,keepStructure_6,numOfInputs,outputMat,0);
    save('MADNESS_6.mat')
    
    %%
elseif(opt==7)
    numOfRuns  = 100000; %number of trials
    numOfCandidateSolutions = 5; %number of candidate solutions (generate here, this cannot be in a function since needs to be constant)
    numOfGates = 7; %number of NAND gates to start with
    [keepCircuits_7,keepStructure_7,keepNumOfLayers_7,textCircuits_7,strAllText_7] = generateRandomCircuits(numOfInputs,numOfOutputs,numOfGates,numOfRuns,numOfCandidateSolutions);
    [fitness_7,faultTolerance_7]    = calculateFitnessAndFaultTolerance(textCircuits_7,keepStructure_7,numOfInputs,outputMat,0);
    save('MADNESS_7.mat')
    
    %%
elseif(opt==8)
    numOfRuns  = 100000; %number of trials
    numOfCandidateSolutions = 5; %number of candidate solutions (generate here, this cannot be in a function since needs to be constant)
    numOfGates = 8; %number of NAND gates to start with
    [keepCircuits_8,keepStructure_8,keepNumOfLayers_8,textCircuits_8,strAllText_8] = generateRandomCircuits(numOfInputs,numOfOutputs,numOfGates,numOfRuns,numOfCandidateSolutions);
    [fitness_8,faultTolerance_8]    = calculateFitnessAndFaultTolerance(textCircuits_8,keepStructure_8,numOfInputs,outputMat,0);
    save('MADNESS_8.mat')
    
    %%
elseif(opt==9)
    numOfRuns  = 1000000; %number of trials
    numOfCandidateSolutions = 5; %number of candidate solutions (generate here, this cannot be in a function since needs to be constant)
    numOfGates = 9; %number of NAND gates to start with
    [keepCircuits_9,keepStructure_9,keepNumOfLayers_9,textCircuits_9,strAllText_9] = generateRandomCircuits(numOfInputs,numOfOutputs,numOfGates,numOfRuns,numOfCandidateSolutions);
    [fitness_9,faultTolerance_9]    = calculateFitnessAndFaultTolerance(textCircuits_9,keepStructure_9,numOfInputs,outputMat,0);
    save('MADNESS_9.mat')
    
    %%
elseif(opt==10)
    numOfRuns  = 1000000; %number of trials
    numOfCandidateSolutions = 5; %number of candidate solutions (generate here, this cannot be in a function since needs to be constant)
    numOfGates = 10; %number of NAND gates to start with
    [keepCircuits_10,keepStructure_10,keepNumOfLayers_10,textCircuits_10,strAllText_10] = generateRandomCircuits(numOfInputs,numOfOutputs,numOfGates,numOfRuns,numOfCandidateSolutions);
    [fitness_10,faultTolerance_10]    = calculateFitnessAndFaultTolerance(textCircuits_10,keepStructure_10,numOfInputs,outputMat,0);
    save('MADNESS_10.mat')
    
    %%
elseif(opt==11)
    numOfRuns  = 1000000; %number of trials
    numOfCandidateSolutions = 3; %number of candidate solutions (generate here, this cannot be in a function since needs to be constant)
    numOfGates = 11; %number of NAND gates to start with
    [keepCircuits_11,keepStructure_11,keepNumOfLayers_11,textCircuits_11,strAllText_11] = generateRandomCircuits(numOfInputs,numOfOutputs,numOfGates,numOfRuns,numOfCandidateSolutions);
    [fitness_11,faultTolerance_11]    = calculateFitnessAndFaultTolerance(textCircuits_11,keepStructure_11,numOfInputs,outputMat,0);
    save('MADNESS_11.mat')
    
    %%
elseif(opt==12)
    numOfRuns  = 1000000; %number of trials
    numOfCandidateSolutions = 1; %number of candidate solutions (generate here, this cannot be in a function since needs to be constant)
    numOfGates = 12; %number of NAND gates to start with
    [keepCircuits_12,keepStructure_12,keepNumOfLayers_12,textCircuits_12,strAllText_12] = generateRandomCircuits(numOfInputs,numOfOutputs,numOfGates,numOfRuns,numOfCandidateSolutions);
    [fitness_12,faultTolerance_12]    = calculateFitnessAndFaultTolerance(textCircuits_12,keepStructure_12,numOfInputs,outputMat,0);
    save('MADNESS_12.mat')
    
    %%
elseif(opt==13)
    numOfRuns  = 1000000; %number of trials
    numOfCandidateSolutions = 1; %number of candidate solutions (generate here, this cannot be in a function since needs to be constant)
    numOfGates = 13; %number of NAND gates to start with
    [keepCircuits_13,keepStructure_13,keepNumOfLayers_13,textCircuits_13,strAllText_13] = generateRandomCircuits(numOfInputs,numOfOutputs,numOfGates,numOfRuns,numOfCandidateSolutions);
    [fitness_13,faultTolerance_13]    = calculateFitnessAndFaultTolerance(textCircuits_13,keepStructure_13,numOfInputs,outputMat,0);
    save('MADNESS_13.mat')
    
    %%
elseif(opt==14)
    numOfRuns  = 1000000; %number of trials
    numOfCandidateSolutions = 1; %number of candidate solutions (generate here, this cannot be in a function since needs to be constant)
    numOfGates = 14; %number of NAND gates to start with
    [keepCircuits_14,keepStructure_14,keepNumOfLayers_14,textCircuits_14,strAllText_14] = generateRandomCircuits(numOfInputs,numOfOutputs,numOfGates,numOfRuns,numOfCandidateSolutions);
    [fitness_14,faultTolerance_14]    = calculateFitnessAndFaultTolerance(textCircuits_14,keepStructure_14,numOfInputs,outputMat,0);
    save('MADNESS_14.mat')
    
    %%
    
elseif(opt==15)
    numOfRuns  = 1000000; %number of trials
    numOfCandidateSolutions = 1; %number of candidate solutions (generate here, this cannot be in a function since needs to be constant)
    numOfGates = 15; %number of NAND gates to start with
    [keepCircuits_15,keepStructure_15,keepNumOfLayers_15,textCircuits_15,strAllText_15] = generateRandomCircuits(numOfInputs,numOfOutputs,numOfGates,numOfRuns,numOfCandidateSolutions);
    [fitness_15,faultTolerance_15]    = calculateFitnessAndFaultTolerance(textCircuits_15,keepStructure_15,numOfInputs,outputMat,0);
    save('MADNESS_15.mat')
    
end
end


