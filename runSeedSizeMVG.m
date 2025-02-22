function [] = runSeedSizeMVG(seed,mutProb,numOfGatesVec,onlyChangeConnections)
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
G2             = or(xor(inpMat(:,1),inpMat(:,2)),xor(inpMat(:,3),inpMat(:,4)));
outputMat_1    = G1;
outputMat_2    = G2;
preDefinedSize = 11;
numOfCandidateSolutions = 1000; %number of candidate solutions (generate here, this cannot be in a function since needs to be constant)
if(numOfGatesVec==1)
    % randomly sampled # of gates
    numOfGates     = randi([9 11],1,numOfCandidateSolutions);%number of NAND gates to start with, excludes the output gates
else
    % same # of gates for all circuits
    numOfGates     = 10; %number of NAND gates to start with, excludes the output gates
end
mult           = 0.2;
freqAlternate  = 20;
L              = floor(0.25*numOfCandidateSolutions); %top 25 percent / top 50 percent?
% L              = 1; %take only the best?
runSeedSizeOutputMVG(seed,outputMat_1,outputMat_2,numOfInputs,numOfOutputs,numOfGates,numOfCandidateSolutions,mult,preDefinedSize,freqAlternate,L,mutProb,onlyChangeConnections)
end
