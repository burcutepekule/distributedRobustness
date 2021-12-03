function [degeneracy,degeneracy2,degeneracy3,degeneracyUB,redundancy,complexity,circuitSize] = calculateDegeneracy2(keepOutput,keepAllOutput,fittestStructure)
numOfInputs   = fittestStructure(1,2);
numOfGates    = sum(fittestStructure(2:end-1,2));
numOfOutputs  = fittestStructure(end,2);
outputMat     = keepAllOutput(:,2:4);
C             = outputMat(:,2);
Cj            = cat(1, C{:});
allGates      = Cj(1:(numOfInputs+numOfGates+numOfOutputs));
inputGates    = allGates(1:numOfInputs);
outputGates   = allGates(end-numOfOutputs+1:end);
middleGates   = setdiff(allGates,[outputGates;inputGates]);
idxOutput     = reshape(find(ismember(Cj,outputGates)),length(outputGates),[])';
outputMatNum  = reshape(double(cell2mat(outputMat(idxOutput,3))),[],length(outputGates));

circuitSize        = length(allGates)+numOfOutputs;
degeneracyVecMean  = [];
degeneracyVec2Mean = [];
IallVecMean        = [];
IsubsubHatVecMean  = [];
IsubVecKeep        = [];
%convert double to logical as well (or vice versa)
for i=1:length(outputMat(:,3))
    outputMat{i,3}=logical(outputMat{i,3});
end
outputMatExtended = [];
for i=1:2^numOfInputs
    outputMatBlock    = outputMat(cell2mat(outputMat(:,1))==i,:);
    outputMatBlockAdd = cell(numOfOutputs,3);
    for j=1:numOfOutputs
        outputMatBlockAdd(j,1) = {[i]};
        outputMatBlockAdd(j,2) = {['O_' num2str(j)]};
        outputMatBlockAdd(j,3) = {[logical(outputMatNum(i,j))]};
    end
    outputMatBlock    = [outputMatBlock;outputMatBlockAdd];
    outputMatExtended = [outputMatExtended;outputMatBlock];
end

for j=1:numOfOutputs
    allGates = [allGates;{['O_' num2str(j)]}];
end

Z         = length(allGates);
outputMat = outputMatExtended;
C         = outputMat(:,2);
Cj        = cat(1, C{:});

for k=1:Z
    disp(['Calculating for ' num2str(k) '-gate subcircuits...'])
    gates2use     = nchoosek(allGates,k);
    degeneracyVec = [];
    degeneracyVec2= [];
    IallVec       = [];
    IsubsubHatVec = [];
    IsubVec       = [];
    for i=1:size(gates2use,1)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if(size(gates2use,2)>1)
            gatesSubTemp    = gates2use(i,:);
        else
            gatesSubTemp    = gates2use(i);
        end
        gatesSubHatTemp = setdiff(allGates,gatesSubTemp);
        
        idxSub          = reshape(find(ismember(Cj,gatesSubTemp)),length(gatesSubTemp),[])';
        idxSubHat       = reshape(find(ismember(Cj,gatesSubHatTemp)),length(gatesSubHatTemp),[])';
        
        subOutputMat    = reshape(double(cell2mat(outputMat(idxSub,3))),[],length(gatesSubTemp));% [outputMat(idxSub(:,1),3) outputMat(idxSub(:,2),3)] %sanity check
        subOutputMatHat = reshape(double(cell2mat(outputMat(idxSubHat,3))),[],length(gatesSubHatTemp));
        allOutputMat    = [subOutputMat subOutputMatHat];
        
        pSubOutput    = probRows(subOutputMat);
        pSubOutputHat = probRows(subOutputMatHat);
        
        pOutput       = probRows(keepOutput);%for H(O)
        pAllOutput    = probRows(allOutputMat);%for H(X)
        pJoint        = probRows([subOutputMat keepOutput]);%for H(X_i^k,O) and I(X_i^k,O)
        pJointHat     = probRows([subOutputMatHat keepOutput]);%for H(X_i^khat,O) and I(X_i^khat,O)
        pJointAll     = probRows([allOutputMat keepOutput]); %for H(X,O) and I(X,O)
        pJointSubHat  = probRows([subOutputMat subOutputMatHat]);%for H(X_i^k,X_i^khat) and I(X_i^k,X_i^khat)
        
        %%
        pSubOutputDist    = unique(pSubOutput,'rows');
        pSubOutputHatDist = unique(pSubOutputHat,'rows');
        pOutputDist       = unique(pOutput,'rows');
        pAllOutputDist    = unique(pAllOutput,'rows');
        pJointDist        = unique(pJoint,'rows');
        pJointHatDist     = unique(pJointHat,'rows');
        pJointAllDist     = unique(pJointAll,'rows');
        pJointSubHatDist  = unique(pJointSubHat,'rows');
        
        
        HSubOutput    = -sum(pSubOutputDist(:,end).*log(pSubOutputDist(:,end))); %H(X_i^k)
        HSubOutputHat = -sum(pSubOutputHatDist(:,end).*log(pSubOutputHatDist(:,end)));%H(X_i^khat)
        HAllOutput    = -sum(pAllOutputDist(:,end).*log(pAllOutputDist(:,end)));%H(X)
        HOutput       = -sum(pOutputDist(:,end).*log(pOutputDist(:,end)));%H(O)
        
        
        HJoint        = -sum(pJointDist(:,end).*log(pJointDist(:,end))); %H(X_i^k,O)
        HJointHat     = -sum(pJointHatDist(:,end).*log(pJointHatDist(:,end))); %H(X_i^khat,O)
        HJointAll     = -sum(pJointAllDist(:,end).*log(pJointAllDist(:,end))); %H(X,O)
        HJointSubHat  = -sum(pJointSubHatDist(:,end).*log(pJointSubHatDist(:,end))); %H(X_i^k,X_i^khat)
        
        %                 [HSubOutput;HSubOutputHat;HAllOutput;HOutput;HJoint;HJointHat;HJointAll],2) %table 2
        
        Isub       = HSubOutput+HOutput-HJoint; % I(X_i^k,O) = H(X_i^k) + H(O) - H(X_i^k,O)
        IsubHat    = HSubOutputHat+HOutput-HJointHat; % I(X_i^khat,O) = H(X_i^khat) + H(O) - H(X_i^khat,O)
        Iall       = HAllOutput+HOutput-HJointAll; % I(X,O) = H(X) + H(O) - H(X,O)
        IsubsubHat = HSubOutput+HSubOutputHat-HJointSubHat;% I(X_i^k,X_i^khat) = H(X_i^k) + H(X_i^khat) - H(X_i^k,X_i^khat)
        
        %                 [Isub;IsubHat;Iall;(Isub+IsubHat-Iall)],3)%Table 4
        
        degeneracyVec  = [degeneracyVec Isub+IsubHat-Iall];
        degeneracyVec2 = [degeneracyVec2 Isub];
        IallVec        = [IallVec Iall]; %all same anyway
        %         if(k==1) %for overall redundancy
        %             IsubVec = [IsubVec Isub];
        %         end
        IsubVec        = [IsubVec Isub];
        IsubsubHatVec  = [IsubsubHatVec IsubsubHat];
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    end
    degeneracyVecMean  = [degeneracyVecMean mean(degeneracyVec)];
    degeneracyVec2Mean = [degeneracyVec2Mean mean(degeneracyVec2)-(k/Z)*Iall];
    IallVecMean        = [IallVecMean mean(IallVec)];
    IsubsubHatVecMean  = [IsubsubHatVecMean mean(IsubsubHatVec)]; %<I(X_i^k,X_i^khat)>
    IsubVecKeep{k}     = IsubVec;
end

degeneracy   = 0.5*sum(degeneracyVecMean);
degeneracy2  = sum(degeneracyVec2Mean);
degeneracyUB = (Z/2)*mean(IallVecMean); % (Z/2) I(X,O)
complexity   = 0.5*sum(IsubsubHatVecMean); % 0.5*sum(<I(X_i^k,X_i^khat)>)
IsubSum      = sum(IsubVecKeep{1}); % sum(I(X^1_i,O))
redundancy   = IsubSum-mean(IallVecMean); % sum(<I(X^k,O)>)-I(X,O)

%%% EQUATION 2.4
degeneracyVec3 = [];
for k=1:Z
    degeneracyVec3(k) = mean(IsubVecKeep{k})-(k/Z)*mean(IallVecMean);
end
degeneracy3 = sum(degeneracyVec3);
end

