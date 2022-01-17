function [textCircuitsTemp_mutated,structureTemp_mutated] = mutation02(textCircuitsTemp,structureTemp)
% RANDOM MUTATION #2
% (c) -> If you remove one gate, you remove two inputs and one output - so
% delete one of the connections to the input that is connected to two (or
% more) other gates (to maintain the full connectiveness), and connect the
% other input to the output.

% structureTemp changes since the number of gates per layer changes

% better to pick a gate in random which its input is connected to an ouput
% that has two (or more) connections
connectedNode2Remove=[];connection2Reconnect=[];condRemove=1; % if more than 1, repeat to maintain full connectiveness
connectedNodes2Remove = [];diffNodes2Connect=[];condReconnect=true;backwardConnections=true;
% while(isempty(connectedNode2Remove) || length(inputNodes2reconnect)==1 || isempty(connectedNodes2Remove) || ~(isempty(diffNodes2Connect) || ~isempty(connectedNodes2Remove)))
while(any(backwardConnections) || (isempty(connectedNode2Remove) && condRemove==1) || (isempty(renameMat) && isempty(connection2Reconnect)) || isempty(connectedNodes2Remove) || ~(isempty(diffNodes2Connect) || ~isempty(connectedNodes2Remove)))
    
    layerMutateAt     = randi(structureTemp(end-1,1),1); %can't delete input or output, so all middle layers
    inputNodes2remove = datasample(1000*layerMutateAt+10*(1:structureTemp(layerMutateAt+1,2)),1)+[1 2];
    outputNode2remove = max(inputNodes2remove)+1;
    gate2remove       = outputNode2remove-3;
    %     disp(['Gate removed : ' num2str(gate2remove)])
    
    inputNodes2reconnect =  cell2mat(textCircuitsTemp(cell2mat(textCircuitsTemp(:,2))==outputNode2remove,3));
    connectedNodes       = [];
    % what is connected to these input nodes that would be removed?
    for i=1:2
        for k=1:size(textCircuitsTemp,1)
            tempInputRow = cell2mat(textCircuitsTemp(k,3));
            if(ismember(inputNodes2remove(i),tempInputRow))
                connectedNodes(i) = cell2mat(textCircuitsTemp(k,2));
            end
        end
    end
    connectedNodes2Remove = [];
    for i=1:length(connectedNodes)
        % Condition # 1 : does any of these ouputs have two (or more) connections?
        connectionsOfInpNode = cell2mat(textCircuitsTemp(cell2mat(textCircuitsTemp(:,2))==connectedNodes(i),3));
        cond_1 = length(connectionsOfInpNode)>1;
        % Condition # 2 : does any of these ouputs would cause backward feedback if
        % connected to the output?
        connectionsOfOutNode = [];
        outputsOfInpNode     = 10*unique(floor(connectionsOfInpNode./10))+3;
        
        %         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %         for o=1:length(outputsOfInpNode)
        %             connectionsOfOutNode = [connectionsOfOutNode cell2mat(textCircuitsTemp(cell2mat(textCircuitsTemp(:,2))==outputsOfInpNode(o),3))];
        %         end
        %         if(~isempty(connectionsOfOutNode))
        %             cond_2 = min(floor(connectionsOfOutNode./1000)) <= structureTemp(end,1);
        %         else
        %             cond_2 = 0>1;
        %         end
        %         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        cond_2 = min(floor(outputsOfInpNode./1000)) <= structureTemp(end,1);
        
        if(cond_1 && cond_2)
            connectedNodes2Remove = [connectedNodes2Remove connectedNodes(i)];
        end
    end
    connectedNodes2Remove   = unique(connectedNodes2Remove);
    diffNodes2Connect       = mysetdiff(connectedNodes,connectedNodes2Remove);
    if(~isempty(diffNodes2Connect) || ~isempty(connectedNodes2Remove))
        
        if(length(unique(connectedNodes))>1)
            
            if(~isempty(diffNodes2Connect))
                if(~isempty(inputNodes2reconnect))
                    connectedNode2Reconnect = datasample(diffNodes2Connect,length(inputNodes2reconnect),'Replace',true);
                else % means it's connected to an output
                    connectedNode2Reconnect = datasample(diffNodes2Connect,1);
                end
            else
                if(~isempty(inputNodes2reconnect))
                    connectedNode2Reconnect = datasample(connectedNodes,length(inputNodes2reconnect),'Replace',true);
                else % means it's connected to an output
                    connectedNode2Reconnect = datasample(connectedNodes,1);
                end
            end
            
            diffSet = setdiff(connectedNodes,connectedNode2Reconnect);
            if(isempty(diffSet)) %identical arrays
                condRemove              = 0;
                connection2Remove_1     = [connectedNodes(1) inputNodes2remove(connectedNodes==connectedNodes(1))];
                connection2Remove_2     = [connectedNodes(2) inputNodes2remove(connectedNodes==connectedNodes(2))];
            else
                connectedNode2Remove    = datasample(diffSet,1);
                connection2Remove_1     = [connectedNode2Remove inputNodes2remove(connectedNodes==connectedNode2Remove)];
                connection2Remove_2     = [];
                for kk=1:length(connectedNode2Reconnect)
                    connection2Remove_2     = [connection2Remove_2; connectedNode2Reconnect(kk) inputNodes2remove(connectedNodes==connectedNode2Reconnect(kk))];
                end
            end
            connection2Remove_2 = unique(connection2Remove_2,'rows');
            % is the reconnected node an input node?
            condReconnect  = floor(connectedNode2Reconnect/1000)==0;
            
            reconnect2 = cell2mat(textCircuitsTemp(cell2mat(textCircuitsTemp(:,2))==outputNode2remove,3));
            
            
            %                 connection2Reconnect    = [connectedNode2Reconnect outputNode2remove];
            connection2Reconnect = [];
            connection2Remove_o  = [];
            renameMat            = [];
            if(isempty(reconnect2)) % means it's a terminal node connected to the output
                connectionsOfInpNode = [];
                for cc=1:length(connectedNode2Reconnect)
                    connectionsOfInpNode = [connectionsOfInpNode cell2mat(textCircuitsTemp(cell2mat(textCircuitsTemp(:,2))==connectedNode2Reconnect(cc),3))];
                end
                % Condition # 2 : does any of these ouputs would cause backward feedback if
                % connected to the output?
                connectionsOfOutNode2bRemoved = [];
                outputsOfInpNode     = 10*unique(floor(connectionsOfInpNode./10))+3;
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                for o=1:length(outputsOfInpNode)
                    connectionsOfOutNode2bRemoved = [connectionsOfOutNode2bRemoved cell2mat(textCircuitsTemp(cell2mat(textCircuitsTemp(:,2))==outputsOfInpNode(o),3))];
                end
                if(~isempty(connectionsOfOutNode2bRemoved))
                    cond_4 = min(floor(connectionsOfOutNode2bRemoved./1000)) <= structureTemp(end,1);
                elseif(isempty(connectionsOfOutNode2bRemoved) && max(floor(outputsOfInpNode/1000)== structureTemp(end,1))) %if outputsOfInpNode is the output layer
                    cond_4 = true;
                else
                    cond_4 = 0>1;
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if(cond_4)
                    renameMat = [connectedNode2Reconnect outputNode2remove]; %output
                    renameMat = [renameMat; connectedNode2Reconnect-1 outputNode2remove-1]; %inp_2
                    renameMat = [renameMat; connectedNode2Reconnect-2 outputNode2remove-2]; %inp_1
                end
            else
                for l=1:length(reconnect2)
                    connection2Reconnect = [connection2Reconnect; connectedNode2Reconnect(l) reconnect2(l)];
                    connection2Remove_o  = [connection2Remove_o; outputNode2remove reconnect2(l)];
                end
                
            end
            
            % if empty, repeat
        else
            % if both inputs of the gate2remove were connected to the same
            % node
            connectedNode2Remove    = connectedNodes2Remove;
            connectedNode2Reconnect = connectedNodes2Remove;
            connection2Remove_1     = [connectedNode2Remove inputNodes2remove(1)];
            connection2Remove_2     = [connectedNode2Reconnect inputNodes2remove(2)];
            % is the reconnected node an input node?
            condReconnect           = floor(connectedNode2Reconnect/1000)==0;
            
            reconnect2 = cell2mat(textCircuitsTemp(cell2mat(textCircuitsTemp(:,2))==outputNode2remove,3));
            %                 connection2Reconnect    = [connectedNode2Reconnect outputNode2remove];
            connection2Reconnect = [];
            connection2Remove_o  = [];
            renameMat            = [];
            if(isempty(reconnect2)) % means it's a terminal node connected to the output
                renameMat = [connectedNode2Reconnect outputNode2remove]; %output
                renameMat = [renameMat; connectedNode2Reconnect-1 outputNode2remove-1]; %inp_2
                renameMat = [renameMat; connectedNode2Reconnect-2 outputNode2remove-2]; %inp_1
            else
                for l=1:length(reconnect2)
                    connection2Reconnect = [connection2Reconnect; connectedNode2Reconnect reconnect2(l)];
                    connection2Remove_o  = [connection2Remove_o; outputNode2remove reconnect2(l)];
                end
            end
        end
    end
    
    % connectionMat         = drawCircuit_text(structureTemp,textCircuitsTemp,numOfOutputs);
    textCircuitsTemp_mutated = textCircuitsTemp;
    % remove the connections
    % Connection # 1
    removeConnectionInd = find(cell2mat(textCircuitsTemp_mutated(:,2))==connection2Remove_1(1));
    oldConnections      = cell2mat(textCircuitsTemp_mutated(removeConnectionInd,3));
    newConnections      = setdiff(oldConnections,connection2Remove_1(2));
    textCircuitsTemp_mutated{removeConnectionInd,3} = newConnections;
    
    removeConnectionInd = find(cell2mat(textCircuitsTemp_mutated(:,2))==connection2Remove_2(1));
    oldConnections      = cell2mat(textCircuitsTemp_mutated(removeConnectionInd,3));
    newConnections      = setdiff(oldConnections,connection2Remove_2(2));
    textCircuitsTemp_mutated{removeConnectionInd,3} = newConnections;
    
    for k=1:size(connection2Remove_o,1)
        removeConnectionInd = find(cell2mat(textCircuitsTemp_mutated(:,2))==connection2Remove_o(k,1));
        oldConnections      = cell2mat(textCircuitsTemp_mutated(removeConnectionInd,3));
        newConnections      = setdiff(oldConnections,connection2Remove_o(k,2));
        textCircuitsTemp_mutated{removeConnectionInd,3} = newConnections;
    end
    % re-connect / re-name the new connections
    for k=1:size(connection2Reconnect,1)
        reconnectInd        = find(cell2mat(textCircuitsTemp_mutated(:,2))==connection2Reconnect(k,1));
        oldConnections      = cell2mat(textCircuitsTemp_mutated(reconnectInd,3));
        newConnections      = [oldConnections,connection2Reconnect(k,2)];
        textCircuitsTemp_mutated{reconnectInd,3} = newConnections;
    end
    
    if(~isempty(renameMat))
        % for column 2
        for i=1:size(renameMat,1)
            renameTempOld = renameMat(i,1);
            renameTempNew = renameMat(i,2);
            for k=1:size(textCircuitsTemp_mutated,1)
                oldRow = cell2mat(textCircuitsTemp_mutated(k,2));
                oldRow(oldRow==renameTempOld)=renameTempNew;
                textCircuitsTemp_mutated{k,2}=oldRow;
            end
        end
        % for column 3
        for i=1:size(renameMat,1)
            renameTempOld = renameMat(i,1);
            renameTempNew = renameMat(i,2);
            for k=1:size(textCircuitsTemp_mutated,1)
                oldRow = cell2mat(textCircuitsTemp_mutated(k,3));
                oldRow(oldRow==renameTempOld)=renameTempNew;
                textCircuitsTemp_mutated{k,3}=oldRow;
            end
        end
    end
    % delete if any row is empty now
    textCircuitsTemp_mutated(cellfun(@isempty,textCircuitsTemp_mutated(:,3)),:)=[];
    %%
    %sort after renaming
    [~,i]=sort(cell2mat(textCircuitsTemp_mutated(:,2)));
    textCircuitsTemp_mutated = textCircuitsTemp_mutated(i,:);
    %  check for backward connections
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
    if(~any(backwardConnections))
        [structureTemp_mutated,textCircuitsTemp_mutated] = checkAndRename(textCircuitsTemp_mutated);
        % FUNCTION DOES BELOW
        %         [structureTemp_mutated,allGates] = text2structure(textCircuitsTemp_mutated);
        %         % Now to draw properly, you need to rename the gates since structure and therefore ordering might have changed
        %
        %         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %         % first check the differential corectness for layer indexes
        %         allGatesUse   = allGates(floor(allGates./1000)>0);
        %         allGatesUseOld= allGatesUse;
        %         allGatesUse10 = floor(allGatesUse/10);
        %         indOfLayers   = floor(allGatesUse10/100);
        %         diffLayers    = diff(indOfLayers);
        %         subtractDiff  = zeros(size(allGatesUseOld));
        %         if(any(diff(diffLayers)>1))
        %             idxs = find(diffLayers>1);
        %             for ll=1:length(idxs)
        %                 idxStart     = idxs(ll);
        %                 subtractDiff((idxStart+1):end,1) = 1000;
        %             end
        %         end
        %         allGatesUseNew = allGatesUseOld-subtractDiff;
        %         allGatesRename = [allGatesUseOld allGatesUseNew];
        %
        %         % check whether they start with level 1
        %         allGates          = allGatesRename(:,2);
        %         allGatesRenameNew = allGatesRename;
        %         allGatesUse    = allGates(floor(allGates./1000)>0);
        %         allGatesUse10  = floor(allGatesUse/10);
        %         indOfLayers    = floor(allGatesUse10/100);
        %         allGatesRename = [allGatesRenameNew(:,1) allGatesRenameNew(:,2)-1000*(min(indOfLayers)-1)];
        %
        %         % find these and rename
        %         for k=1:size(allGatesRename,1)
        %             oldNameTemp = allGatesRename(k,1);
        %             newNameTemp = allGatesRename(k,2);
        %             if(oldNameTemp~=newNameTemp)
        %                 for r=1:size(textCircuitsTemp_mutated,1)
        %                     for c=2:size(textCircuitsTemp_mutated,2)
        %                         tempCell = cell2mat(textCircuitsTemp_mutated(r,c));
        %                         if(ismember(oldNameTemp,tempCell))
        %                             tempCell(oldNameTemp==tempCell)=newNameTemp;
        %                             textCircuitsTemp_mutated{r,c}=tempCell;
        %                         end
        %                     end
        %                 end
        %             end
        %         end
        %         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %         % then check the differential corectness for gate indexes
        %         [structureTemp_mutated,allGates] = text2structure(textCircuitsTemp_mutated);
        %         allGatesUse   = allGates(floor(allGates./1000)>0);
        %         allGatesUse10 = floor(allGatesUse/10);
        %         indOfLayers   = floor(allGatesUse10/100);
        %         allGatesRename= [];
        %         for k=unique(indOfLayers)'
        %             allGatesUseOld    = allGatesUse(indOfLayers==k);
        %             allGatesUse10Temp = allGatesUse10(indOfLayers==k);
        %             diffGates         = diff(allGatesUse10Temp);
        %             if(any(diffGates>1))
        %                 diffGates0     = diffGates;
        %                 diffGates0(diffGates>1)=0;
        %                 cumsumDiff     = cumsum(diffGates)-cumsum(diffGates0);
        %                 subtractDiff   = [0;cumsumDiff(cumsumDiff==0);cumsumDiff(cumsumDiff>0)-1];
        %                 allGatesUseNew = allGatesUseOld-10*subtractDiff;
        %             else
        %                 allGatesUseNew = allGatesUseOld;
        %             end
        %             allGatesRename = [allGatesRename; allGatesUseOld allGatesUseNew];
        %         end
        %         % then check whether they start with gate index 1
        %         allGates          = allGatesRename(:,2);
        %         allGatesRenameNew = allGatesRename;
        %         allGatesUse   = allGates(floor(allGates./1000)>0);
        %         allGatesUse10 = floor(allGatesUse/10);
        %         indOfLayers   = floor(allGatesUse10/100);
        %         allGatesRename= [];
        %         for k=unique(indOfLayers)'
        %             allGatesUseOld    = allGatesUse(indOfLayers==k);
        %             allGatesUse10Temp = allGatesUse10(indOfLayers==k);
        %             allGatesUse10TempMod100 = mod(allGatesUse10Temp,100);
        %             if(min(unique(allGatesUse10TempMod100))>1)
        %                 diffSubt       = min(unique(allGatesUse10TempMod100))-1;
        %                 allGatesUseNew = allGatesUseOld-10*diffSubt;
        %             else
        %                 allGatesUseNew = allGatesUseOld;
        %             end
        %             allGatesRename = [allGatesRename; allGatesUseOld allGatesUseNew];
        %         end
        %         % combine both
        %         allGatesRename = [allGatesRenameNew(:,1) allGatesRename(:,2)];
        %         % check whether they start with level 1
        %         allGates          = allGatesRename(:,2);
        %         allGatesRenameNew = allGatesRename;
        %         allGatesUse    = allGates(floor(allGates./1000)>0);
        %         allGatesUse10  = floor(allGatesUse/10);
        %         indOfLayers    = floor(allGatesUse10/100);
        %         allGatesRename = [allGatesRenameNew(:,1) allGatesRenameNew(:,2)-1000*(min(indOfLayers)-1)];
        %
        %
        %         % find these and rename
        %         for k=1:size(allGatesRename,1)
        %             oldNameTemp = allGatesRename(k,1);
        %             newNameTemp = allGatesRename(k,2);
        %             if(oldNameTemp~=newNameTemp)
        %                 for r=1:size(textCircuitsTemp_mutated,1)
        %                     for c=2:size(textCircuitsTemp_mutated,2)
        %                         tempCell = cell2mat(textCircuitsTemp_mutated(r,c));
        %                         if(ismember(oldNameTemp,tempCell))
        %                             tempCell(oldNameTemp==tempCell)=newNameTemp;
        %                             textCircuitsTemp_mutated{r,c}=tempCell;
        %                         end
        %                     end
        %                 end
        %             end
        %         end
        %
        %
        %         % check whether number of layers increased / decreased?
        %         allGatesRename = [];
        %         for k=1:size(textCircuitsTemp_mutated,1)
        %             outputGateLayer   = floor(cell2mat(textCircuitsTemp_mutated(k,2))./1000);
        %             inputGateLayerMax = max(floor(cell2mat(textCircuitsTemp_mutated(k,3))./1000));
        %             if(outputGateLayer==inputGateLayerMax)
        %                 output2change  = max(floor(cell2mat(textCircuitsTemp_mutated(k,3))));
        %                 allGatesRename = [allGatesRename; output2change   output2change+1000];
        %                 allGatesRename = [allGatesRename; output2change-1 output2change+1000-1];
        %                 allGatesRename = [allGatesRename; output2change-2 output2change+1000-2];
        %             end
        %         end
        %         % check again the ordering if not empty
        %         if(~isempty(allGatesRename))
        %             allGates          = allGatesRename(:,2);
        %             allGatesRenameNew = allGatesRename;
        %             allGatesUse   = allGates(floor(allGates./1000)>0);
        %             allGatesUse10 = floor(allGatesUse/10);
        %             indOfLayers   = floor(allGatesUse10/100);
        %             allGatesRename= [];
        %             for k=unique(indOfLayers)'
        %                 allGatesUseOld    = allGatesUse(indOfLayers==k);
        %                 allGatesUse10Temp = allGatesUse10(indOfLayers==k);
        %                 allGatesUse10TempMod100 = mod(allGatesUse10Temp,100);
        %                 if(min(unique(allGatesUse10TempMod100))>1)
        %                     diffSubt       = min(unique(allGatesUse10TempMod100))-1;
        %                     allGatesUseNew = allGatesUseOld-10*diffSubt;
        %                 else
        %                     allGatesUseNew = allGatesUseOld;
        %                 end
        %                 allGatesRename = [allGatesRename; allGatesUseOld allGatesUseNew];
        %             end
        %             % combine both
        %             allGatesRename = [allGatesRenameNew(:,1) allGatesRename(:,2)];
        %             %%
        %
        %             % find these and rename
        %             for k=1:size(allGatesRename,1)
        %                 oldNameTemp = allGatesRename(k,1);
        %                 newNameTemp = allGatesRename(k,2);
        %                 if(oldNameTemp~=newNameTemp)
        %                     for r=1:size(textCircuitsTemp_mutated,1)
        %                         for c=2:size(textCircuitsTemp_mutated,2)
        %                             tempCell = cell2mat(textCircuitsTemp_mutated(r,c));
        %                             if(ismember(oldNameTemp,tempCell))
        %                                 tempCell(oldNameTemp==tempCell)=newNameTemp;
        %                                 textCircuitsTemp_mutated{r,c}=tempCell;
        %                             end
        %                         end
        %                     end
        %                 end
        %             end
        %         end
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
    
end
% since names changed, update structure again
[structureTemp_mutated,allGates] = text2structure(textCircuitsTemp_mutated);
end

