function [textCircuitsTemp_mutated,structureTemp_mutated] = mutation01(textCircuitsTemp,structureTemp)
% RANDOM MUTATION #1
% pick a connection to randomly cut
allGatesOutput  = cell2mat(textCircuitsTemp(:,2))';
allGatesOutputNumConnections = [];
for k=1:length(allGatesOutput)
    allGatesOutputNumConnections=[allGatesOutputNumConnections length(cell2mat(textCircuitsTemp(k,3)))];
end
if(all(allGatesOutputNumConnections==1))
    %     sprintf('allGatesOutputNumConnections ALL 1')
    [textCircuitsTemp_mutated,structureTemp_mutated] = mutation01_swap(textCircuitsTemp,structureTemp);
else
    if(randn>0)
        [textCircuitsTemp_mutated,structureTemp_mutated] = mutation01_swap(textCircuitsTemp,structureTemp);
    else
        cutFromIndex = datasample(find(allGatesOutputNumConnections>1),1);
        cutFrom = datasample(cell2mat(textCircuitsTemp(cutFromIndex,2)),1);
        cutTo   = datasample(cell2mat(textCircuitsTemp(cutFromIndex,3)),1);
        reconnect2possible = allGatesOutput(floor(allGatesOutput./1000)<floor(cutTo/1000));
        reconnect2 = datasample(reconnect2possible,1);
        
        connection2Remove    = [cutFrom cutTo];
        connection2Reconnect = [reconnect2 cutTo];
        
%         disp(['Cutting connection from ' num2str(connection2Remove(1)) ' to ' num2str(connection2Remove(2)) ...
%             ', reconnecting to ' num2str(connection2Reconnect(1))]);
        
        textCircuitsTemp_mutated = textCircuitsTemp;
        
        removeConnectionInd      = find(cell2mat(textCircuitsTemp_mutated(:,2))==connection2Remove(1));
        oldConnections           = cell2mat(textCircuitsTemp_mutated(removeConnectionInd,3));
        newConnections           = setdiff(oldConnections,connection2Remove(2));
        textCircuitsTemp_mutated{removeConnectionInd,3} = newConnections;
        
        reconnectInd        = find(cell2mat(textCircuitsTemp_mutated(:,2))==connection2Reconnect(1));
        oldConnections      = cell2mat(textCircuitsTemp_mutated(reconnectInd,3));
        newConnections      = [oldConnections,connection2Reconnect(2)];
        textCircuitsTemp_mutated{reconnectInd,3} = newConnections;
        
        structureTemp_mutated = structureTemp; %doesn't change
    end
end
end


