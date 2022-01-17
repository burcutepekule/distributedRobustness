function [] = runSeedSize(seed,mutProb)



% fix the output 
numOfInputs    = 4; %number of inputs
% THIS IS TO REPLICATE THE RESULTS OF URI ALON
inpMat         = [];
for i=0:(2^numOfInputs-1)
    inpMat = [inpMat;str2logicArray(dec2bin(i,numOfInputs))];
end
% An Introduction to Systems Biology, Eq. 15.5.1 
numOfOutputs   = 1;
G1             = and(xor(inpMat(:,1),inpMat(:,2)),xor(inpMat(:,3),inpMat(:,4)));
outputMat      = G1; %Random Input - Output truthtable
numOfGates     = 10; %number of NAND gates to start with, excludes the output gates 
preDefinedSize = 11;
numOfCandidateSolutions = 1000; %number of candidate solutions (generate here, this cannot be in a function since needs to be constant)
mult           = 0.2;
L              = floor(0.25*numOfCandidateSolutions); %top 25 percent
runSeedSizeOutput(seed,outputMat,numOfInputs,numOfOutputs,numOfGates,numOfCandidateSolutions,mult,preDefinedSize,L,mutProb)
end

