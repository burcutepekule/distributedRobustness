function [textCircuitsTemp_mutated,structureTemp_mutated] = mutation01_swap(textCircuitsTemp,structureTemp)
% RANDOM MUTATION #1
% (a)+(b) -> pick a random layer n (from 0 (inp. layer) to structureTemp(end,1)-1), and from layer n to n+1, switch two connections.
% structureTemp stays the same since the number of gates per layer doesn't change
% textCircuitsTemp changes
cond=true;
while (cond)
    layerMutateFrom = randi(structureTemp(end,1),1)-1; %input layer to second last layer (very last connected to output)
    cond = (length(1:structureTemp(layerMutateFrom+1,2))<2);
end
% layerMutateTo   = layerMutateFrom+1;
switchGates     = layerMutateFrom*1000+10*datasample(1:structureTemp(layerMutateFrom+1,2),2,'Replace',false)+3;
allGates        = cell2mat(textCircuitsTemp(:,2))';
sw1             = find(allGates==switchGates(1));
sw2             = find(allGates==switchGates(2));
allConnections1 = cell2mat(textCircuitsTemp(sw1,3));
allConnections2 = cell2mat(textCircuitsTemp(sw2,3));
connection2sw1  = datasample(allConnections1,1);
connection2sw2  = datasample(allConnections2,1);

% disp(['Switch ' num2str(switchGates(1)) '-' num2str(connection2sw1) ', and ' num2str(switchGates(2)) '-' num2str(connection2sw2)]);

textCircuitsTemp_mutated = textCircuitsTemp;
textCircuitsTemp_mutated{sw1,3}=[setdiff(allConnections1,connection2sw1),connection2sw2];
textCircuitsTemp_mutated{sw2,3}=[setdiff(allConnections2,connection2sw2),connection2sw1];
structureTemp_mutated = structureTemp; %doesn't change
end

