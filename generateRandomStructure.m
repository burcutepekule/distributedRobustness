

function [numOfGatesPerLayer,numOfLayers] = generateRandomStructure(numOfGatesBetween,numOfInputs,numOfOutputs)
lookFor=1;
while(lookFor==1)
    noNegative=0;
    while(noNegative==0)
        numOfLayers        = randi([1 numOfGatesBetween],1);
        %                 [tempCircuit numOfLayers]
        numOfGatesPerLayer = [];
        numOfGatesUsed     = 0;
        if(numOfLayers==1)
            numOfGatesPerLayer = [1 numOfGatesBetween];
        else
            
            for layerIdx=numOfLayers:-1:2
                % last layer before the output layer has to have ***AT MOST***
                % 2*numOfOutputs gates so that all output of the last layer can be
                % connected to the output layer
                if(layerIdx==numOfLayers)
                    numOfGates         = randi([1 2*numOfOutputs],1);
                    numOfGatesPerLayer = [numOfGatesPerLayer;layerIdx numOfGates];
                    numOfGatesUsed     = numOfGatesUsed+numOfGates;
                else
                    numOfOutputsTemp   = sum(numOfGatesPerLayer(numOfGatesPerLayer(:,1)<=layerIdx+1,2));
                    numOfGates         = randi([0 max(0,numOfGatesBetween-numOfGatesUsed)],1);
                    numOfGatesPerLayer = [numOfGatesPerLayer;layerIdx numOfGates];
                    numOfGatesUsed     = numOfGatesUsed+numOfGates;
                end
            end
            [~,iSorted]=sort(numOfGatesPerLayer(:,1));
            numOfGatesPerLayer = numOfGatesPerLayer(iSorted,:);
%             numOfGatesPerLayer = sort(numOfGatesPerLayer,1); %BUG
            numOfGatesPerLayer = [1 numOfGatesBetween-numOfGatesUsed;numOfGatesPerLayer];
            % HERE
            if(any(sign(numOfGatesPerLayer(:,2))<0))
                noNegative=0;
            else
                noNegative=1;
            end
        end
    end
    numOfGatesPerLayer(numOfGatesPerLayer(:,2)==0,:)=[]; % delete empty layers, recalculate num of layers
    numOfLayers            = size(numOfGatesPerLayer,1)+1;
    numOfGatesPerLayer(:,1)=1:size(numOfGatesPerLayer,1); % reset the layer indexes
    % add an additional row for the input layer
    numOfGatesPerLayer = [0,numOfInputs;numOfGatesPerLayer];
    numOfGatesPerLayer = [numOfGatesPerLayer;numOfLayers,numOfOutputs];
    % check whether enough number of gates each layer for a fully connected circuit
    
    mumOfOpenInputs = 2*([numOfGatesPerLayer(2:end,2); numOfOutputs]);
    matCheck = [numOfGatesPerLayer mumOfOpenInputs 2*numOfGatesPerLayer(:,2) flipud(cumsum(flipud(mumOfOpenInputs)))];
    matCheckKeep = matCheck;
    residualsKeep = [];
    for layerIdx=numOfLayers:-1:1
        residual = matCheck(layerIdx+1,5)-matCheck(layerIdx+1,4);
        matCheck(layerIdx,5)=matCheck(layerIdx,5)-residual;
        residualsKeep = [residualsKeep residual];
    end
    if(all(matCheck(:,5)-matCheck(:,4)>=0))
        lookFor = 0;
        break
    end
end


end

