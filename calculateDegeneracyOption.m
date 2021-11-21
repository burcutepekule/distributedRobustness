function [degeneracy,degeneracy2,degeneracyUB,redundancy,complexity,circuitSize] = calculateDegeneracyOption(keepOutput,keepAllOutput,numOfInputs,numOfOutputs,fittestStructure,opt)
% numOfGates    = sum(fittestStructure(2:end,2));
numOfGates    = sum(fittestStructure(2:end-1,2));
circuitSize   = numOfGates;
outputMat     = keepAllOutput(:,2:4);
C             = outputMat(:,2);
Cj            = cat(1, C{:});
allGates      = Cj(1:(numOfInputs+numOfGates+numOfOutputs));
inputGates    = allGates(1:numOfInputs);
outputGates   = allGates(end-numOfOutputs+1:end);
if(opt==0)
    middleGates   = setdiff(allGates,[outputGates;inputGates]);
elseif(opt==1)
    middleGates   = setdiff(allGates,inputGates);
end
degeneracyVecMean  = [];
degeneracyVec2Mean = [];
IallVecMean        = [];
IsubsubHatVecMean  = [];
IsubVec            = [];
for k=1:length(middleGates)
    disp(['Calculating for ' num2str(k) '-gate subcircuits...'])
    gates2use     = nchoosek(middleGates,k);
    degeneracyVec = [];
    degeneracyVec2= [];
    IallVec       = [];
    IsubsubHatVec = [];
    for i=1:size(gates2use,1)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if(size(gates2use,2)>1)
            gatesSubTemp    = gates2use(i,:);
        else
            gatesSubTemp    = gates2use(i);
        end
        gatesSubHatTemp = setdiff(middleGates,gatesSubTemp);
        
        idxSub          = reshape(find(ismember(Cj,gatesSubTemp)),length(gatesSubTemp),[])';
        idxSubHat       = reshape(find(ismember(Cj,gatesSubHatTemp)),length(gatesSubHatTemp),[])';
        idxOutput       = reshape(find(ismember(Cj,outputGates)),length(outputGates),[])';
        
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
        
%                 round([HSubOutput;HSubOutputHat;HAllOutput;HOutput;HJoint;HJointHat;HJointAll],2) %table 2
        
        Isub       = HSubOutput+HOutput-HJoint; % I(X_i^k,O) = H(X_i^k) + H(O) - H(X_i^k,O)
        IsubHat    = HSubOutputHat+HOutput-HJointHat; % I(X_i^khat,O) = H(X_i^khat) + H(O) - H(X_i^khat,O)
        Iall       = HAllOutput+HOutput-HJointAll; % I(X,O) = H(X) + H(O) - H(X,O)
        IsubsubHat = HSubOutput+HSubOutputHat-HJointSubHat;% I(X_i^k,X_i^khat) = H(X_i^k) + H(X_i^khat) - H(X_i^k,X_i^khat)
        
        
%                 round([Isub;IsubHat;Iall;(Isub+IsubHat-Iall)],3)%Table 4
        
        degeneracyVec  = [degeneracyVec Isub+IsubHat-Iall];
        degeneracyVec2 = [degeneracyVec2 Isub];
        IallVec        = [IallVec Iall]; %all same anyway
        if(k==1) %for redundancy
            IsubVec = [IsubVec Isub];
        end
        IsubsubHatVec  = [IsubsubHatVec IsubsubHat];
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    end
    degeneracyVecMean  = [degeneracyVecMean mean(degeneracyVec)];
    degeneracyVec2Mean = [degeneracyVec2Mean mean(degeneracyVec2)-(k/numOfGates)*Iall];
    IallVecMean        = [IallVecMean mean(IallVec)];
    IsubsubHatVecMean  = [IsubsubHatVecMean mean(IsubsubHatVec)]; %<I(X_i^k,X_i^khat)>
end

degeneracy   = 0.5*sum(degeneracyVecMean);
degeneracy2  = sum(degeneracyVec2Mean);
degeneracyUB = (numOfGates/2)*mean(IallVecMean); % (Z/2) I(X,O)
complexity   = 0.5*sum(IsubsubHatVecMean); % 0.5*sum(<I(X_i^k,X_i^khat)>)
IsubSum      = sum(IsubVec); % sum(I(X_i,O))
redundancy   = IsubSum-mean(IallVecMean); % sum(<I(X^k,O)>)-I(X,O)
end

