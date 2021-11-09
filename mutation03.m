function [textCircuitsTemp_mutated,structureTemp_mutated] = mutation03(textCircuitsTemp,structureTemp)
% RANDOM MUTATION #3
% (d) -> If you add one gate, you add two inputs and one output
% You can add a gate either to the very end or very beginning because
% everything else is already fully connected.

% pick whether you wanna add at the end or at the beginning
backwardConnections=true;
while(any(backwardConnections))
    add2layer = datasample(1:structureTemp(end,1),1);
    if(add2layer==1)
        structureTemp_mutated = structureTemp;
        structureTemp_mutated(2:end,1)=structureTemp_mutated(2:end,1)+1;
        structureTemp_mutated    = [structureTemp_mutated(1,:);[1 1];structureTemp_mutated(2:end,:)];
        %rename all layers
        textCircuitsTemp_mutated = textCircuitsTemp;
        for r=1:size(textCircuitsTemp_mutated,1)
            for c=2:size(textCircuitsTemp_mutated,2)
                tempCell = cell2mat(textCircuitsTemp_mutated(r,c));
                for i=1:length(tempCell)
                    tempGate = tempCell(i);
                    if(floor(tempGate/1000)>0) % do not rename input cells
                        tempCell(i)=tempGate+1000;
                    end
                end
                textCircuitsTemp_mutated{r,c}=tempCell;
            end
        end
        
        % pick input nodes to be connected
        inputGates2Connect  = 10*(1:structureTemp_mutated(1,2))+3;
        outputGates2Connect = 1000*structureTemp_mutated(3,1)+10*(1:structureTemp_mutated(3,2));
        outputNodes2Connect = repmat(outputGates2Connect',1,2)+repmat([1 2],length(outputGates2Connect),1);
        outputNodes2Connect = outputNodes2Connect(:)';
        % find the number of connections input gates have
        % if any of them have only one connection to connect2NewOutput,
        % then that has to stay for full connectiveness
        connect2NewOutput = datasample(outputNodes2Connect,1,'Replace',true);
        sample4sure = [];
        for l=1:length(inputGates2Connect)
            rowInd         = find(cell2mat(textCircuitsTemp_mutated(:,2))==inputGates2Connect(l));
            allConnections = cell2mat(textCircuitsTemp_mutated(rowInd,3));
            if(isempty(setdiff(allConnections,connect2NewOutput)))
                sample4sure = [sample4sure inputGates2Connect(l)];
            end
        end
        
        connect2NewInputs = sample4sure;
        connect2NewInputs = [connect2NewInputs datasample(inputGates2Connect,2-length(sample4sure),'Replace',true)];
        
        % find the original connection to the connect2NewOutput
        connection2Remove = [];
        connection2Add_1  = [add2layer*1000+13 connect2NewOutput];
        connection2Add_2  = [connect2NewInputs(1) add2layer*1000+11];
        connection2Add_3  = [connect2NewInputs(2) add2layer*1000+12];
        
        % remove the connection to connect2NewOutput
        for r=1:size(textCircuitsTemp_mutated,1)
            tempCell = cell2mat(textCircuitsTemp_mutated(r,3));
            if(ismember(connect2NewOutput,tempCell))
                tempCellNew =  setdiff(tempCell,connect2NewOutput);
                textCircuitsTemp_mutated{r,3} = tempCellNew;
            end
        end
        connection2Reconnect = [connection2Add_1;connection2Add_2;connection2Add_3];
        for k=1:size(connection2Reconnect,1)
            reconnectInd        = find(cell2mat(textCircuitsTemp_mutated(:,2))==connection2Reconnect(k,1));
            if(isempty(reconnectInd)) % brand new connection
                textCircuitsTemp_mutated(size(textCircuitsTemp_mutated,1)+1,1)=textCircuitsTemp_mutated(end,1);
                textCircuitsTemp_mutated{end,2} = connection2Reconnect(k,1);
                textCircuitsTemp_mutated{end,3} = connection2Reconnect(k,2);
                [~,ii]=sort(cell2mat(textCircuitsTemp_mutated(:,2)));
                textCircuitsTemp_mutated=textCircuitsTemp_mutated(ii,:);
            else
                oldConnections      = cell2mat(textCircuitsTemp_mutated(reconnectInd,3));
                newConnections      = [oldConnections,connection2Reconnect(k,2)];
                textCircuitsTemp_mutated{reconnectInd,3} = newConnections;
            end
        end
    else
        
        numGates    = structureTemp(:,2);
        numGatesNew = [numGates(1:add2layer);1;numGates(add2layer+1:end)];
        structureTemp_mutated = [(0:length(numGatesNew)-1)' numGatesNew];
        
        %rename all layers
        textCircuitsTemp_mutated = textCircuitsTemp;
        for r=1:size(textCircuitsTemp_mutated,1)
            for c=2:size(textCircuitsTemp_mutated,2)
                tempCell = cell2mat(textCircuitsTemp_mutated(r,c));
                for i=1:length(tempCell)
                    tempGate = tempCell(i);
                    if(floor(tempGate/1000)>(add2layer-1)) % do not rename input cells
                        tempCell(i)=tempGate+1000;
                    end
                end
                textCircuitsTemp_mutated{r,c}=tempCell;
            end
        end
        
        % pick input nodes to be connected
        inputGates2Connect  = 10*(1:structureTemp_mutated(1,2))+3; %inputs
        layers2bConnected   = structureTemp_mutated(2:add2layer,1);
        for j=1:length(layers2bConnected)
            layer2bConnected   = layers2bConnected(j);
            gates2bConnected   = structureTemp_mutated(layer2bConnected+1,2);
            inputGates2Connect = [inputGates2Connect 1000*layers2bConnected(j)+10*(1:gates2bConnected)+3];
        end
        
        % pick output nodes to be connected
        outputGates2Connect = [];
        layers2bConnected   = structureTemp_mutated(add2layer+2:end,1);
        for j=1:length(layers2bConnected)
            layer2bConnected   = layers2bConnected(j);
            gates2bConnected   = structureTemp_mutated(layer2bConnected+1,2);
            outputGates2Connect = [outputGates2Connect 1000*layers2bConnected(j)+10*(1:gates2bConnected)+1 1000*layers2bConnected(j)+10*(1:gates2bConnected)+2];
        end
        
        connect2NewOutput = datasample(outputGates2Connect,1,'Replace',true);
        
        % remove the connection to connect2NewOutput
        connectNewInput_1=[];
        for r=1:size(textCircuitsTemp_mutated,1)
            tempCell = cell2mat(textCircuitsTemp_mutated(r,3));
            if(ismember(connect2NewOutput,tempCell))
                tempCellNew =  setdiff(tempCell,connect2NewOutput);
                textCircuitsTemp_mutated{r,3} = tempCellNew;
                connectNewInput_1 = cell2mat(textCircuitsTemp_mutated(r,2));
            end
        end
        % find the original connection to the connect2NewOutput
        connection2Remove = [];
        connection2Add_1  = [add2layer*1000+13 connect2NewOutput];
        connection2Add_2  = [connectNewInput_1 add2layer*1000+11];
        connection2Add_3  = [datasample(setdiff(inputGates2Connect,connectNewInput_1),1), add2layer*1000+12];
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        connection2Reconnect = [connection2Add_1;connection2Add_2;connection2Add_3];
        for k=1:size(connection2Reconnect,1)
            reconnectInd        = find(cell2mat(textCircuitsTemp_mutated(:,2))==connection2Reconnect(k,1));
            if(isempty(reconnectInd)) % brand new connection
                textCircuitsTemp_mutated(size(textCircuitsTemp_mutated,1)+1,1)=textCircuitsTemp_mutated(end,1);
                textCircuitsTemp_mutated{end,2} = connection2Reconnect(k,1);
                textCircuitsTemp_mutated{end,3} = connection2Reconnect(k,2);
                [~,ii]=sort(cell2mat(textCircuitsTemp_mutated(:,2)));
                textCircuitsTemp_mutated=textCircuitsTemp_mutated(ii,:);
            else
                oldConnections      = cell2mat(textCircuitsTemp_mutated(reconnectInd,3));
                newConnections      = [oldConnections,connection2Reconnect(k,2)];
                textCircuitsTemp_mutated{reconnectInd,3} = newConnections;
            end
        end
    end
    
    % final check for backward connections
    backwardConnections = [];
    for k=1:size(textCircuitsTemp_mutated,1)
        outputGateLayer   = floor(cell2mat(textCircuitsTemp_mutated(k,2))./1000);
        inputGateLayers   = floor(cell2mat(textCircuitsTemp_mutated(k,3))./1000);
        if(any(outputGateLayer>=inputGateLayers))
            backwardConnections = [backwardConnections true];
        else
            backwardConnections = [backwardConnections false];
        end
    end
    
end

% sprintf("Gate Added to layer : %d",add2layer);
disp(['Gate Added to layer : ' num2str(add2layer)]);

end

