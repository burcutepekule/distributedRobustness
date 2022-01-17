function [] = runSeedConstraint(seed)
% fix the output 
numOfInputs    = 2; %number of inputs
numOfOutputs   = 2; %number of outputs
rng(77) % gives the output in the paper
outputMat      = randn([2^numOfInputs,numOfOutputs])>0; %Random Input - Output truthtable
numOfGates     = 8; %number of NAND gates to start with, excludes the output gates 
numOfRuns      = 1000; %number of trials
numOfCandidateSolutions = 10; %number of candidate solutions (generate here, this cannot be in a function since needs to be constant)
runSeedConstraintOutput(seed,outputMat,numOfInputs,numOfOutputs,numOfGates,numOfRuns,numOfCandidateSolutions)
end

