function [degeneracy,degeneracy2,degeneracy3,degeneracyUB,redundancy,complexity,complexity2,circuitSize,IsubOne,IallFinal,IsubMatKeep,IsubsubHatMatKeep,IsubHatMatKeep,HsubsubHatMatKeep,HsubMatKeep,HsubHatMatKeep,HJointMatKeep,HJointHatMatKeep,HJointAllMatKeep,HOutputMatKeep] = calculateDegeneracy(keepOutput,keepAllOutput,fittestStructure)
numOfInputs   = fittestStructure(1,2);
numOfGates    = sum(fittestStructure(2:end-1,2));
numOfOutputs  = fittestStructure(end,2);
outputMat     = keepAllOutput(:,2:4);
C             = outputMat(:,2);
Cj            = cat(1, C(:));
% Cj            = cat(1, C{:}); %for solvePerturbedCircuit_old
allGates      = Cj(1:(numOfInputs+numOfGates+numOfOutputs));
inputGates    = allGates(1:numOfInputs);
outputGates   = allGates(end-numOfOutputs+1:end);
middleGates   = setdiff(allGates,[outputGates;inputGates]);
circuitSize        = length(middleGates)+length(outputGates);
degeneracyVecMean  = [];
degeneracyVec2Mean = [];
IallVecMean        = [];
IsubsubHatVecMean  = [];
IsubVecKeep        = [];
complexityVec      = [];
Z                  = length(middleGates);
IsubsubHatMatKeep  = NaN*ones(Z,nchoosek(length(middleGates),round(length(middleGates)/2)));
HsubsubHatMatKeep  = NaN*ones(Z,nchoosek(length(middleGates),round(length(middleGates)/2)));
IsubMatKeep        = NaN*ones(Z,nchoosek(length(middleGates),round(length(middleGates)/2)));
IsubHatMatKeep     = NaN*ones(Z,nchoosek(length(middleGates),round(length(middleGates)/2)));
HsubMatKeep        = NaN*ones(Z,nchoosek(length(middleGates),round(length(middleGates)/2)));
HsubHatMatKeep     = NaN*ones(Z,nchoosek(length(middleGates),round(length(middleGates)/2)));
HJointMatKeep      = NaN*ones(Z,nchoosek(length(middleGates),round(length(middleGates)/2)));
HJointHatMatKeep   = NaN*ones(Z,nchoosek(length(middleGates),round(length(middleGates)/2)));
HJointAllMatKeep   = NaN*ones(Z,nchoosek(length(middleGates),round(length(middleGates)/2)));
HOutputMatKeep     = NaN*ones(Z,nchoosek(length(middleGates),round(length(middleGates)/2)));

HSubOutputSum = 0;
HSubOutputVec = [];
for k=1:Z
    disp(['Calculating for ' num2str(k) '-gate subcircuits...'])
    gates2use     = nchoosek(middleGates,k); % since this is gonna blow up for large circuits, put a limit in the main script to terminate after a certain size
    degeneracyVec = [];
    degeneracyVec2= [];
    IallVec       = [];
    IsubsubHatVec = [];
    IsubVec       = [];
    IxSubVec      = [];
    if(size(gates2use,2)==1)
        [~,indOrder]    = sort(str2double(extractAfter(gates2use,"i_")'));
        gates2use       = gates2use(indOrder); %to prevent "10013" to come before  "1013"
    end
    for i=1:size(gates2use,1)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if(size(gates2use,2)>1)
            gatesSubTemp    = gates2use(i,:);
            [~,indOrder]    = sort(str2double(extractAfter(gatesSubTemp,"i_")'));
            gatesSubTemp    = gatesSubTemp(indOrder); %to prevent "10013" to come before  "1013"
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
        
        
        HSub    = -sum(pSubOutputDist(:,end).*log(pSubOutputDist(:,end))); %H(X_i^k)
        HSubHat = -sum(pSubOutputHatDist(:,end).*log(pSubOutputHatDist(:,end)));%H(X_i^khat)
        HAll    = -sum(pAllOutputDist(:,end).*log(pAllOutputDist(:,end)));%H(X)
        HOutput = -sum(pOutputDist(:,end).*log(pOutputDist(:,end)));%H(O)
        
        
        HJoint        = -sum(pJointDist(:,end).*log(pJointDist(:,end))); %H(X_i^k,O)
        HJointHat     = -sum(pJointHatDist(:,end).*log(pJointHatDist(:,end))); %H(X_i^khat,O)
        HJointAll     = -sum(pJointAllDist(:,end).*log(pJointAllDist(:,end))); %H(X,O)
        HJointSubHat  = -sum(pJointSubHatDist(:,end).*log(pJointSubHatDist(:,end))); %H(X_i^k,X_i^khat)
        
        %                 round([HSubOutput;HSubOutputHat;HAllOutput;HOutput;HJoint;HJointHat;HJointAll],2) %table 2
        
        Isub       = HSub+HOutput-HJoint; % I(X_i^k,O) = H(X_i^k) + H(O) - H(X_i^k,O)
        IsubHat    = HSubHat+HOutput-HJointHat; % I(X_i^khat,O) = H(X_i^khat) + H(O) - H(X_i^khat,O)
        Iall       = HAll+HOutput-HJointAll; % I(X,O) = H(X) + H(O) - H(X,O)
        IsubsubHat = HSub+HSubHat-HJointSubHat;% I(X_i^k,X_i^khat) = H(X_i^k) + H(X_i^khat) - H(X_i^k,X_i^khat)
        
        %                 round([Isub;IsubHat;Iall;(Isub+IsubHat-Iall)],3)%Table 4
        
        degeneracyVec  = [degeneracyVec Isub+IsubHat-Iall];
        degeneracyVec2 = [degeneracyVec2 Isub];
        IallVec        = [IallVec Iall]; %all same anyway
        %         if(k==1) %for overall redundancy
        %             IsubVec = [IsubVec Isub];
        %         end
        IsubVec        = [IsubVec Isub];
        IsubsubHatVec  = [IsubsubHatVec IsubsubHat];
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        IsubsubHatMatKeep(k,i)  = IsubsubHat;
        HsubsubHatMatKeep(k,i)  = HJointSubHat;
        IsubMatKeep(k,i)        = Isub;
        HsubMatKeep(k,i)        = HSub;
        IsubHatMatKeep(k,i)     = IsubHat;
        HsubHatMatKeep(k,i)     = HSubHat;
        HJointMatKeep(k,i)      = HJoint;
        HJointHatMatKeep(k,i)   = HJointHat;
        HJointAllMatKeep(k,i)   = HJointAll;
        HOutputMatKeep(k,i)     = HOutput;

        if(k==1)
            HSubOutputSum = HSubOutputSum+HSub;
            HSubOutputVec = [HSubOutputVec HSub];
        end
        inds     = idxSub(1,:)-numOfInputs;
        IxSubVec = [IxSubVec sum(HSubOutputVec(inds))-HSub];
    end
    degeneracyVecMean  = [degeneracyVecMean mean(degeneracyVec)];
    degeneracyVec2Mean = [degeneracyVec2Mean mean(degeneracyVec2)-(k/Z)*Iall];
    IallVecMean        = [IallVecMean mean(IallVec)];
    IsubsubHatVecMean  = [IsubsubHatVecMean mean(IsubsubHatVec)]; %<I(X_i^k,X_i^khat)>
    IsubVecKeep{k}     = IsubVec;
    %TONINI 1998
    if(k==1)
        Ix = HSubOutputSum-HAll;
    end
    complexityVec      = [complexityVec (k/Z)*Ix-mean(IxSubVec)];
end

degeneracy   = 0.5*sum(degeneracyVecMean);
degeneracy2  = sum(degeneracyVec2Mean);
degeneracyUB = (Z/2)*mean(IallVecMean); % (Z/2) I(X,O)
% complexity   = 0.5*sum(IsubsubHatVecMean); % 0.5*sum(<I(X_i^k,X_i^khat)>)
complexity   = 0.5*sum(nanmean(IsubsubHatMatKeep,2)); % 0.5*sum(<I(X_i^k,X_i^khat)>)
complexity2  = sum(complexityVec);
IsubOne      = IsubVecKeep{1};
IsubSum      = sum(IsubOne); % sum(I(X^1_i,O))
IallFinal    = mean(IallVecMean);
redundancy   = IsubSum-IallFinal; % sum(<I(X^k,O)>)-I(X,O)

%%% EQUATION 2.4
degeneracyVec3 = [];
for k=1:length(IsubVecKeep)
    degeneracyVec3(k) = mean(IsubVecKeep{k})-(k/Z)*mean(IallVecMean);
end
degeneracy3 = sum(degeneracyVec3);
end

