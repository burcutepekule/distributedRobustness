function [connPickNewFinal] = drawCircuit_text_optimal(fittestStructurePick,fittestTextCircuitPick,textOn)
disp('Calculating optimal way of drawing...')
[~,connPick]          = drawCircuit_calc_dist(fittestStructurePick,fittestTextCircuitPick);
outputGates           = 1000.*fittestStructurePick(end,1)+fittestStructurePick(end,2)*10+3;
inputGatesOfOuputNodes= 1000.*fittestStructurePick(end,1)+fittestStructurePick(end,2)*10+[1 2];
inputNodes            = 10*[1:fittestStructurePick(1,2)]+3;
allOutputNodes        = setdiff(cell2mat(fittestTextCircuitPick(:,2))',inputNodes);
connPickDouble        = [];
connPickDouble(:,1)   = double(connPick(:,1));
connPickDouble(:,2)   = double(connPick(:,2));
connPickDoubleKeep    = connPickDouble;
% Try to write down all paths
allOutputNodes = allOutputNodes';
maxLayer       = max(fittestStructurePick(:,1));
pathMat        = connPickDoubleKeep(ismember(connPickDoubleKeep(:,1),inputNodes),:);
endLayer       = 0;
c              = 2;
while(endLayer<maxLayer)
    connsTemp = pathMat(:,c);
    pathMatNew= [];
    for l=1:length(connsTemp)
        rowTemp       = pathMat(l,:);
        connsTempGate = rowTemp(c);
        pathMatTemp   = connPickDoubleKeep(ismember(connPickDoubleKeep(:,1),[connsTempGate+1 connsTempGate+2]),:);
        if(~isempty(pathMatTemp))
            repTimes      = size(pathMatTemp,1);
            pathMatAdd    = [repmat(rowTemp,repTimes,1) pathMatTemp(:,2)];
        else
            pathMatAdd = [rowTemp NaN];
        end
        pathMatNew    = [pathMatNew; pathMatAdd];
    end
    [x,i]=sort(pathMatNew(:,1));
    pathMatNew=pathMatNew(i,:);
    pathMat   =pathMatNew;
    endLayer  =min(floor(pathMat(~isnan(pathMat(:,end)),end)./1000));
    c=c+1;
end

pathMatNew = pathMat;
pathMatKeep= pathMat;
uniqueMaskMatGates  = floor(pathMatKeep./10);
uniqueMaskMatLayers = floor(pathMatKeep./1000);

for c=2:size(pathMatNew,2)
    for r=1:size(pathMatNew,1)
        nodeTemp = pathMatNew(r,c);
        layer2be = c-1;
        % all previous connections?
        [rr,cc]=find(uniqueMaskMatGates==floor(nodeTemp./10));
        tempVec=[];
        for j=1:length(rr)
            tempVec(j)=uniqueMaskMatLayers(rr(j),cc(j)-1);
        end
        if(max(tempVec)==layer2be-1)
            for j=1:length(rr)
                pathMatNew(rr(j),cc(j)) =pathMatNew(rr(j),cc(j))-1000*(floor(pathMatNew(rr(j),cc(j))./1000)-layer2be);
            end
        end
        uniqueMaskMatLayers = floor(pathMatNew./1000);
    end
end
mappingNew = [uniqueMaskMatGates(:) pathMatNew(:)];
[~,i]=sort(mappingNew(:,1));
mappingNew = mappingNew(i,:);
mappingNew(:,3)=mappingNew(:,2);
mappingNew(:,2)=floor(mappingNew(:,2)./10);
[~,i]=sort(mappingNew(:,2));
mappingNew    = mappingNew(i,:);
mappingNewUnq = unique(mappingNew(mappingNew(:,2)>100,2));
mappingOlder  = unique(mappingNew(mappingNew(:,2)>100,1:2),'rows');
while(length(unique(mappingOlder(:,1)))-length(unique(mappingOlder(:,2)))>0)
    mappingNewer  = [];
    for m=mappingNewUnq'
        blockTemp = mappingNew(mappingNew(:,2)==m,1);
        blockTempUnq = unique(blockTemp);
        for b=1:length(blockTempUnq)
            mappingNewer = [mappingNewer;blockTempUnq(b) m+(b-1)];
        end
    end
    mappingNew = mappingNewer;
    mappingOlder=mappingNewer;
    mappingNewUnq = unique(mappingNew(mappingNew(:,2)>100,2));
end
for k=1:size(mappingOlder,1)
    oldVal = mappingOlder(k,1);
    newVal = mappingOlder(k,2);
    pathMat(floor(pathMat./10)==oldVal)=newVal*10+mod(pathMat(floor(pathMat./10)==oldVal),10);
end
% reconstruct circuit text mat
reMat = [];
for c=1:(size(pathMat,2)-1)
    reMat=[reMat; pathMat(:,c:c+1)];
end
reMat = unique(reMat,'rows');
[~,i] = sort(reMat(:,1));
reMat = reMat(i,:);
reMat = reMat(~isnan(reMat(:,2)),:);
reMatU1 = unique(reMat(:,1));
reMatU1_inp = reMatU1(reMatU1<100,:);
reMatU1_mid = reMatU1(reMatU1>100,:);

fittestTextCircuitPickNew = [];
for r=1:length(reMatU1_inp)
    fittestTextCircuitPickNew{r,1}=1;
    fittestTextCircuitPickNew{r,2}=reMatU1(r);
    fittestTextCircuitPickNew{r,3}=[reMat(reMat(:,1)==reMatU1(r),2)]';
end

rr=length(reMatU1_inp)+1;
for r=1:2:length(reMatU1_mid)
    fittestTextCircuitPickNew{rr,1}=1;
    fittestTextCircuitPickNew{rr,2}=10*floor(reMatU1_mid(r)/10)+3;
    fittestTextCircuitPickNew{rr,3}=[reMat(reMat(:,1)==reMatU1_mid(r),2)]';
    rr=rr+1;
end

[structurePickNew,~]     = text2structure(fittestTextCircuitPickNew);
% check the renaming since structure might have been changed
[structurePickNew,fittestTextCircuitPickNew] = checkAndRename(fittestTextCircuitPickNew);
 
[~,connPickNew]          = drawCircuit_calc_dist(structurePickNew,fittestTextCircuitPickNew);
connPickNewDouble        = [];
connPickNewDouble(:,1)   = double(connPickNew(:,1));
connPickNewDouble(:,2)   = double(connPickNew(:,2));
connPickNewDoubleKeep    = connPickNewDouble;
connPickOldDouble        = connPickNewDouble;

allGatesKeep   = floor(cell2mat(fittestTextCircuitPickNew(:,2))./10);
allGatesKeep   = allGatesKeep(allGatesKeep>100);
allPerms       = perms(allGatesKeep')';
allPermsLayers = floor(allPerms./100);
rowTemp        = allPermsLayers(:,1)';
[~,i]          = ismember(allPermsLayers.',rowTemp,'rows');
allPermsPick   = allPerms(:,find(i));
[~,ii] = sort(allPermsPick(:,1));
allPermsPick = allPermsPick(ii,:);
%%
[textCircuitsTempOld] = conn2textCircuit(connPickOldDouble);
[normKeep(1),~]       = drawCircuit_calc_dist(structurePickNew,textCircuitsTempOld);
textprogressbar('Calculating all permutations for NAND gates: ');
for p=2:size(allPermsPick,2)
    iPrint = 100*p/size(allPermsPick,2);
    textprogressbar(iPrint);
    mapNew                    = [allPermsPick(:,1) allPermsPick(:,p)];
    connPickNewDoubleKeepTemp = connPickOldDouble;
    connPickNewDouble         = connPickNewDoubleKeep;
    for i=1:size(mapNew,1)
        valSwap1 = mapNew(i,1);
        valSwap2 = mapNew(i,2);
        %for col 1
        indChange=find(floor(connPickNewDoubleKeepTemp(:,1)./10)==valSwap1);
        connPickNewDouble(indChange,1)=10*valSwap2+mod(connPickNewDoubleKeepTemp(indChange,1),10);
        %for col 2
        indChange=find(floor(connPickNewDoubleKeepTemp(:,2)./10)==valSwap1);
        connPickNewDouble(indChange,2)=10*valSwap2+mod(connPickNewDoubleKeepTemp(indChange,2),10);
    end
    % connPick to textCircuitsTempNew
    [textCircuitsTempNew] = conn2textCircuit(connPickNewDouble);
    
    % calculate distance given shuffle
    normKeep(p)= drawCircuit_calc_dist(structurePickNew,textCircuitsTempNew);
end
textprogressbar('Done.');
%%
[~,iMin]  = find(normKeep==min(normKeep));
mapNew    = [allPermsPick(:,1) allPermsPick(:,iMin)];
connPickNewDoubleKeepTemp = connPickOldDouble;
connPickNewDouble         = connPickNewDoubleKeep;
textprogressbar('Calculating all permutations for gate inputs: ');
for i=1:size(mapNew,1)
    iPrint = 100*i/size(mapNew,1);
    textprogressbar(iPrint);
    valSwap1 = mapNew(i,1);
    valSwap2 = mapNew(i,2);
    %for col 1
    indChange=find(floor(connPickNewDoubleKeepTemp(:,1)./10)==valSwap1);
    connPickNewDouble(indChange,1)=10*valSwap2+mod(connPickNewDoubleKeepTemp(indChange,1),10);
    %for col 2
    indChange=find(floor(connPickNewDoubleKeepTemp(:,2)./10)==valSwap1);
    connPickNewDouble(indChange,2)=10*valSwap2+mod(connPickNewDoubleKeepTemp(indChange,2),10);
    
    [textCircuitsTempNew] = conn2textCircuit(connPickNewDouble);
    [normNew,~]           = drawCircuit_calc_dist(structurePickNew,textCircuitsTempNew);
end
textprogressbar('Done.');
% connPick to textCircuitsTempNew
[textCircuitsTempNew] = conn2textCircuit(connPickNewDouble);

allGates = unique(floor(connPickNewDouble(connPickNewDouble>100)./10));
textCircuitsTempNew01=textCircuitsTempNew;
for j=1:length(allGates)
    gateCheck = 10*allGates(j);
    norm01    = drawCircuit_calc_dist(structurePickNew,textCircuitsTempNew01);
    valSwap1  = gateCheck+1;
    valSwap2  = gateCheck+2;
    textCircuitsTempNew02 = textCircuitsTempNew01;
    for k=1:size(textCircuitsTempNew01,1)
        oldVec = cell2mat(textCircuitsTempNew01(k,3));
        newVec = oldVec;
        newVec(oldVec==valSwap1)=valSwap2;
        newVec(oldVec==valSwap2)=valSwap1;
        textCircuitsTempNew02{k,3} = newVec;
    end
    norm02 = drawCircuit_calc_dist(structurePickNew,textCircuitsTempNew02);
    if(norm02<norm01)
        textCircuitsTempNew01=textCircuitsTempNew02;
    end
end
textCircuitsTempNewFinal = textCircuitsTempNew01;
connPickNewFinal         = drawCircuit_text(structurePickNew,textCircuitsTempNewFinal,textOn);
end

