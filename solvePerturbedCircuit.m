function [keepOutput,keepAllOutput] = solvePerturbedCircuit(tempCircuitIdx,tempCircuit,tempStructure,outputGate2Perturb)
 
colIdxs2Perturb =  gate2colIdx(outputGate2Perturb,tempStructure);
numOfInputs     = tempStructure(1,2);
numOfOutputs    = tempStructure(end,2);
inpMat=[];
for i=0:(2^numOfInputs-1)
    inpMat = [inpMat;str2logicArray(dec2bin(i,numOfInputs))];
end
numOfTotalGates = sum(tempStructure(2:end,2));
keepOutput      = [];
keepAllOutput   = [];
counter         = 1;
% step 0.1: initialize
for inpIdx=1:size(inpMat,1)
    outputVector = NaN(1,3*numOfTotalGates); %2 for input, 1 for output
    inpTemp      = inpMat(inpIdx,:);
    for k=1:numOfInputs
        initialGatesTemp      = cell2mat(tempCircuit(k,2));
        colIdxs               = gate2colIdx(initialGatesTemp,tempStructure);
        outputVector(colIdxs) = inpTemp(k);
        
        inpGateNameTemp = ['i_' num2str(k) '3'];
        inpValTemp      = inpMat(inpIdx,k);
        keepAllOutput{counter,1} = tempCircuitIdx;
        keepAllOutput{counter,2} = inpIdx;
        keepAllOutput{counter,3} = inpGateNameTemp;
        keepAllOutput{counter,4} = inpValTemp;
        counter=counter+1;
    end
    
    % step 0.2: calculate
    for blockIdx=1:numOfTotalGates
        if(isnan(outputVector(3*blockIdx))) % to avoid recalculation
            outputVector(3*blockIdx) = nand(outputVector((blockIdx-1)*3+1),outputVector((blockIdx-1)*3+2));
            if(ismember(3*blockIdx,colIdxs2Perturb))
                outputVector(3*blockIdx) = mynot(outputVector(3*blockIdx));
            end
        end
    end
    numOfPrevInputs = 0;
    for l=2:(size(tempStructure,1)-1)
        numOfPrevInputs = numOfPrevInputs+tempStructure(l-1,2);
        numOfInputsTemp = tempStructure(l,2);
        % step 1: copy
        for k=1:numOfInputsTemp
            gateCopyTo                      = cell2mat(tempCircuit(numOfPrevInputs+k,2));
            gateCopyToColIdxs               = gate2colIdx(gateCopyTo,tempStructure);
            allFoundRowsVec = [];
            for g=1:length(gateCopyTo)
                [allFoundRows,~]     = findInCell(tempCircuit,gateCopyTo(g));
                allFoundRowsVec      = [allFoundRowsVec;allFoundRows];
            end
            allFoundRowsVec                 = unique(allFoundRowsVec);
            gateCopyFrom                    = cell2mat(tempCircuit(allFoundRowsVec,1));
            gateCopyFromColIdxs             = gate2colIdx(gateCopyFrom,tempStructure);
            outputVector(gateCopyToColIdxs) = outputVector(gateCopyFromColIdxs);
            
        end
        for blockIdx=1:numOfTotalGates
            if(isnan(outputVector(3*blockIdx))) % to avoid recalculation
                outputVector(3*blockIdx) = nand(outputVector((blockIdx-1)*3+1),outputVector((blockIdx-1)*3+2));
                if(ismember(3*blockIdx,colIdxs2Perturb))
                    outputVector(3*blockIdx) = mynot(outputVector(3*blockIdx));
                end                
            end
        end
    end
    outputColIdxs = sort(length(outputVector)-3.*(0:(numOfOutputs-1)));
    keepOutput    = [keepOutput;outputVector(outputColIdxs)];
    
    for ii=2:size(tempStructure,1)
        layerIdx = tempStructure(ii,1);
        for gateIdx=1:tempStructure(ii,2)
            gateIdxTemp     = layerIdx*1000+gateIdx*10+3;
            gateNameTemp    = ['i_' num2str(gateIdxTemp)];
            gateCopyFromColIdxs      = gate2colIdx(gateIdxTemp,tempStructure);
            keepAllOutput{counter,1} = tempCircuitIdx;
            keepAllOutput{counter,2} = inpIdx;
            keepAllOutput{counter,3} = gateNameTemp;
            keepAllOutput{counter,4} = outputVector(gateCopyFromColIdxs);
            counter=counter+1;
        end
    end
      
end

end

