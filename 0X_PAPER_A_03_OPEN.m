clear all;close all;clc;
rng(14);
numOfInputs    = 2; %number of inputs
numOfOutputs   = 2; %number of outputs
numOfGates     = 5; %number of NAND gates
numOfSolutions = 100; %number of trials (max candidate solutions)
%% STEP 1 : GENERATE RANDOM CIRCUITS
[keepCircuits,keepStructure,keepNumOfLayers,textCircuits,strAllText] = generateRandomCircuits(numOfInputs,numOfOutputs,numOfGates,numOfSolutions);
%% STEP 2 : SOLVE THE CIRCUITS
keepAllOutput    = solveCircuit(numOfInputs,textCircuits,keepStructure);
%% STEP 3 : VISUALIZE
idxFound         = 2; %pick a circuit index
structureTemp    = keepStructure{idxFound};
textCircuitsTemp = textCircuits(cell2mat(textCircuits(:,1))==idxFound,:);
connectionMat    = drawCircuit_text(structureTemp,textCircuitsTemp,numOfOutputs);
%% STEP 4 : EVOLUTION (?)
% The random mutations (always respecting the back- ward patterning) can be:
% (a) elimination of an existing connection, with probability Ec,
% (b) creation of a new connection with probability Cc,
% (c) elimination of a node (gate removal) with probability In, and
% (d) creation of a new node (gate addition) with probability Cn.
% Here, we use Ec=0.8, Cc=0.8, In=0.3 and Cn=0.6.
%%
% RANDOM MUTATION #1
% (a)+(b) -> pick a random layer n (from 0 (inp. layer) to structureTemp(end,1)-1), and from layer n to n+1, switch two connections.
% structureTemp stays the same since the number of gates per layer doesn't change
% textCircuitsTemp changes

textCircuitsTemp
layerMutateFrom = randi(structureTemp(end,1),1)-1; %input layer to second last layer (very last connected to output)
layerMutateTo   = layerMutateFrom+1;
switchGates     = layerMutateFrom*1000+10*datasample(1:structureTemp(layerMutateFrom+1,2),2,'Replace',false)+3;
allGates        = cell2mat(textCircuitsTemp(:,2))';
sw1             = find(allGates==switchGates(1));
sw2             = find(allGates==switchGates(2));
allConnections1 = cell2mat(textCircuitsTemp(sw1,3));
allConnections2 = cell2mat(textCircuitsTemp(sw2,3));
connection2sw1  = datasample(allConnections1,1);
connection2sw2  = datasample(allConnections2,1);
textCircuitsTemp_mutated = textCircuitsTemp;
textCircuitsTemp_mutated{sw1,3}=[setdiff(allConnections1,connection2sw1),connection2sw2];
textCircuitsTemp_mutated{sw2,3}=[setdiff(allConnections2,connection2sw2),connection2sw1];
close all;
figure
set(gcf, 'Position',  [100, 300, 1500, 400])
subplot(1,2,1)
connectionMat         = drawCircuit_text(structureTemp,textCircuitsTemp,numOfOutputs);
subplot(1,2,2)
connectionMat_mutated = drawCircuit_text(structureTemp,textCircuitsTemp_mutated,numOfOutputs);
%%
% RANDOM MUTATION #2
% (c) -> If you remove one gate, you remove two inputs and one output - so
% delete one of the connections to the input that is connected to two (or
% more) other gates (to maintain the full connectiveness), and connect the
% other input to the output.

% structureTemp changes since the number of gates per layer changes

% better to pick a gate in random which its input is connected to an ouput
% that has two (or more) connections
close all;
% NOT WORKING YET - CHECK IT OUT
textCircuitsTemp
connectedNode2Remove=[];inputNodes2reconnect=0; % if more than 1, repeat to maintain full connectiveness
while(isempty(connectedNode2Remove) && length(inputNodes2reconnect)==1)
    layerMutateAt     = randi(structureTemp(end,1),1); %can't delete input, so all middle layers
    inputNodes2remove = datasample(1000*layerMutateAt+10*(1:structureTemp(layerMutateAt+1,2)),1)+[1 2];
    outputNode2remove = max(inputNodes2remove)+1;
%     layerMutateAt     = 2;
%     inputNodes2remove = [2021,2022];
%     outputNode2remove = max(inputNodes2remove)+1;
    gate2remove       = outputNode2remove-3;
    [gate2remove]
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
    % does any of these ouputs have two (or more)
    connectedNodes2Remove = [];
    for i=1:length(connectedNodes)
        if(length(cell2mat(textCircuitsTemp(cell2mat(textCircuitsTemp(:,2))==connectedNodes(i),3)))>1)
            connectedNodes2Remove = [connectedNodes2Remove connectedNodes(i)];
        end
    end
    connectedNodes2Remove   = unique(connectedNodes2Remove);
    if(length(unique(connectedNodes))>1)
        % might be multiple, sample 1
        connectedNode2Remove    = datasample(connectedNodes2Remove,1);
        connectedNode2Reconnect = datasample(setdiff(connectedNodes,connectedNodes2Remove),1);
        connection2Remove_1     = [connectedNode2Remove inputNodes2remove(connectedNodes==connectedNode2Remove)];
        connection2Remove_2     = [connectedNode2Reconnect inputNodes2remove(connectedNodes==connectedNode2Reconnect)];
        
        reconnect2 = cell2mat(textCircuitsTemp(cell2mat(textCircuitsTemp(:,2))==outputNode2remove,3));
           

        %                 connection2Reconnect    = [connectedNode2Reconnect outputNode2remove];
        connection2Reconnect = [];
        connection2Remove_o  = [];
        renameMat            = [];
        if(isempty(reconnect2)) % means it's a terminal node connected to the output
%             renameMat = [connectedNode2Reconnect outputNode2remove]; %output
            renameMat = [renameMat; connectedNode2Reconnect-1 outputNode2remove-1]; %inp_2
            renameMat = [renameMat; connectedNode2Reconnect-2 outputNode2remove-2]; %inp_1
        else
            for l=1:length(reconnect2)
                connection2Reconnect = [connection2Reconnect; connectedNode2Reconnect reconnect2(l)];
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
        
        reconnect2 = cell2mat(textCircuitsTemp(cell2mat(textCircuitsTemp(:,2))==outputNode2remove,3));
        %                 connection2Reconnect    = [connectedNode2Reconnect outputNode2remove];
        connection2Reconnect = [];
        connection2Remove_o  = [];
        renameMat            = [];
        if(isempty(reconnect2)) % means it's a terminal node connected to the output
%             renameMat = [connectedNode2Reconnect outputNode2remove]; %output
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
%    renameMat = renameMat(2:end,:);% you actually don't need the first row since it's the output gate
    for i=1:size(renameMat,2)
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
[structureTemp_mutated,allGates] = text2structure(textCircuitsTemp_mutated);
% Now to draw properly, you need to rename the gates since structure and therefore ordering might have changed
% first check the differential corectness
allGatesUse   = allGates(floor(allGates./1000)>0);
allGatesUse10 = floor(allGatesUse/10);
indOfLayers   = floor(allGatesUse10/100);
allGatesRename= [];
for k=unique(indOfLayers)'
    allGatesUseOld    = allGatesUse(indOfLayers==k);
    allGatesUse10Temp = allGatesUse10(indOfLayers==k);
    diffGates         = diff(allGatesUse10Temp);
    if(any(diffGates>1))
        cumsumDiff     = cumsum(diffGates);
        subtractDiff   = [0;cumsumDiff(cumsumDiff==0);cumsumDiff(cumsumDiff>0)-1];
        allGatesUseNew = allGatesUseOld-10*subtractDiff;
    else
        allGatesUseNew = allGatesUseOld;
    end
    allGatesRename = [allGatesRename; allGatesUseOld allGatesUseNew];
end
% then check whether they start with 1
allGates          = allGatesRename(:,2);
allGatesRenameNew = allGatesRename;

allGatesUse   = allGates(floor(allGates./1000)>0);
allGatesUse10 = floor(allGatesUse/10);
indOfLayers   = floor(allGatesUse10/100);
allGatesRename= [];
for k=unique(indOfLayers)'
    allGatesUseOld    = allGatesUse(indOfLayers==k);
    allGatesUse10Temp = allGatesUse10(indOfLayers==k);
    allGatesUse10TempMod100 = mod(allGatesUse10Temp,100);
    if(min(unique(allGatesUse10TempMod100))>1)
        diffSubt       = min(unique(allGatesUse10TempMod100))-1;
        allGatesUseNew = allGatesUseOld-10*diffSubt;
    else
        allGatesUseNew = allGatesUseOld;
    end
    allGatesRename = [allGatesRename; allGatesUseOld allGatesUseNew];
end
% combine both
allGatesRename = [allGatesRenameNew(:,1) allGatesRename(:,2)];
% find these and rename
for k=1:size(allGatesRename,1)
    oldNameTemp = allGatesRename(k,1);
    newNameTemp = allGatesRename(k,2);
    if(oldNameTemp~=newNameTemp)
        for r=1:size(textCircuitsTemp_mutated,1)
            for c=2:size(textCircuitsTemp_mutated,2)
                tempCell = cell2mat(textCircuitsTemp_mutated(r,c));
                if(ismember(oldNameTemp,tempCell))
                    tempCell(oldNameTemp==tempCell)=newNameTemp;
                    textCircuitsTemp_mutated{r,c}=tempCell;
                end
            end
        end
    end
end

close all;
figure
set(gcf, 'Position',  [100, 300, 1500, 400])
subplot(1,2,1)
connectionMat         = drawCircuit_text(structureTemp,textCircuitsTemp,numOfOutputs);
subplot(1,2,2)
connectionMat_mutated = drawCircuit_text(structureTemp_mutated,textCircuitsTemp_mutated,numOfOutputs);


