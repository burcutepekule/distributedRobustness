function [] = runSeedLocal(seed)
if(~isfolder('./local_output/'))
     mkdir './local_output/'
end
% fix the output 
numOfInputs    = 2; %number of inputs
numOfOutputs   = 2; %number of outputs
rng(77) % gives the output in the paper
outputMat      = randn([2^numOfInputs,numOfOutputs])>0; %Random Input - Output truthtable
numOfGates     = 3; %number of NAND gates to start with, excludes the output gates 
numOfCandidateSolutions = 10; %number of candidate solutions (generate here, this cannot be in a function since needs to be constant)
circuitSizeTh           = 15+numOfInputs;
runSeedOutputLocal(seed,outputMat,numOfInputs,numOfOutputs,numOfGates,numOfCandidateSolutions,circuitSizeTh)
end

