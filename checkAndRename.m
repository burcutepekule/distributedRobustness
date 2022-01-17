function [structureTemp_mutated,textCircuitsTemp_mutated] = checkAndRename(textCircuitsTemp_mutated)

[structureTemp_mutated,allGates] = text2structure(textCircuitsTemp_mutated);
% Now to draw properly, you need to rename the gates since structure and therefore ordering might have changed

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% first check the differential corectness for layer indexes
allGatesUse   = allGates(floor(allGates./1000)>0);
allGatesUseOld= allGatesUse;
allGatesUse10 = floor(allGatesUse/10);
indOfLayers   = floor(allGatesUse10/100);
diffLayers    = diff(indOfLayers);
subtractDiff  = zeros(size(allGatesUseOld));
if(any(diff(diffLayers)>1))
    idxs = find(diffLayers>1);
    for ll=1:length(idxs)
        idxStart     = idxs(ll);
        subtractDiff((idxStart+1):end,1) = 1000;
    end
end
allGatesUseNew = allGatesUseOld-subtractDiff;
allGatesRename = [allGatesUseOld allGatesUseNew];

% check whether they start with level 1
allGates          = allGatesRename(:,2);
allGatesRenameNew = allGatesRename;
allGatesUse    = allGates(floor(allGates./1000)>0);
allGatesUse10  = floor(allGatesUse/10);
indOfLayers    = floor(allGatesUse10/100);
allGatesRename = [allGatesRenameNew(:,1) allGatesRenameNew(:,2)-1000*(min(indOfLayers)-1)];

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% then check the differential corectness for gate indexes
[structureTemp_mutated,allGates] = text2structure(textCircuitsTemp_mutated);
allGatesUse   = allGates(floor(allGates./1000)>0);
allGatesUse10 = floor(allGatesUse/10);
indOfLayers   = floor(allGatesUse10/100);
allGatesRename= [];
for k=unique(indOfLayers)'
    allGatesUseOld    = allGatesUse(indOfLayers==k);
    allGatesUse10Temp = allGatesUse10(indOfLayers==k);
    diffGates         = diff(allGatesUse10Temp);
    if(any(diffGates>1))
        diffGates0     = diffGates;
        diffGates0(diffGates>1)=0;
        cumsumDiff     = cumsum(diffGates)-cumsum(diffGates0);
        subtractDiff   = [0;cumsumDiff(cumsumDiff==0);cumsumDiff(cumsumDiff>0)-1];
        allGatesUseNew = allGatesUseOld-10*subtractDiff;
    else
        allGatesUseNew = allGatesUseOld;
    end
    allGatesRename = [allGatesRename; allGatesUseOld allGatesUseNew];
end
% then check whether they start with gate index 1
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
% check whether they start with level 1
allGates          = allGatesRename(:,2);
allGatesRenameNew = allGatesRename;
allGatesUse    = allGates(floor(allGates./1000)>0);
allGatesUse10  = floor(allGatesUse/10);
indOfLayers    = floor(allGatesUse10/100);
allGatesRename = [allGatesRenameNew(:,1) allGatesRenameNew(:,2)-1000*(min(indOfLayers)-1)];


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


% check whether number of layers increased / decreased?
allGatesRename = [];
for k=1:size(textCircuitsTemp_mutated,1)
    outputGateLayer   = floor(cell2mat(textCircuitsTemp_mutated(k,2))./1000);
    inputGateLayerMax = max(floor(cell2mat(textCircuitsTemp_mutated(k,3))./1000));
    if(outputGateLayer==inputGateLayerMax)
        output2change  = max(floor(cell2mat(textCircuitsTemp_mutated(k,3))));
        allGatesRename = [allGatesRename; output2change   output2change+1000];
        allGatesRename = [allGatesRename; output2change-1 output2change+1000-1];
        allGatesRename = [allGatesRename; output2change-2 output2change+1000-2];
    end
end
% check again the ordering if not empty
if(~isempty(allGatesRename))
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
    %%
    
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
end

end

