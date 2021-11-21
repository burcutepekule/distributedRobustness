function [inpMat] = generateBinaryInput(numOfInputs)
inpMat=[];
for i=0:(2^numOfInputs-1)
    inpMat = [inpMat;str2logicArray(dec2bin(i,numOfInputs))];
end
end

