clear all;close all;clc;

numOfInputs    = 4; %number of inputs
inpMat         = [];
for i=0:(2^numOfInputs-1)
    inpMat = [inpMat;str2logicArray(dec2bin(i,numOfInputs))];
end
G1             = and(xor(inpMat(:,1),inpMat(:,2)),xor(inpMat(:,3),inpMat(:,4)));
G2             = or(xor(inpMat(:,1),inpMat(:,2)),xor(inpMat(:,3),inpMat(:,4)));
outputMat_1    = G1;
outputMat_2    = G2;

% CAN YOU UNDERSTAND WHETHER G1 DIFFERS FROM G2 BY ONE FUNCTION?

outputMat_both = [outputMat_1 outputMat_2];
unique(outputMat_both,'rows')