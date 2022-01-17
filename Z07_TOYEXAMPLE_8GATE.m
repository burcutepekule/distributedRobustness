clear all;close all;clc;
run('load_8GATE.m')
% Make a 3D matrix of the I(X,O) values to be able to subtract it from
% I(X_{i}^{k},O) +  I(\hat{X}_{i}^{k},O) for Eq. 2.5
IsubHatMatKeepVals3D = [];
for index=1:size(IsubMatKeepVals,3)
    IsubHatMatKeepVals3D(:,:,index)=repmat(IallFinalVals(index),size(IsubMatKeepVals,[1 2]));
end
% Ifinal = I(X_{i}^{k},O) +  I(\hat{X}_{i}^{k},O) - I(X,O)
Ifinal  = IsubMatKeepVals+IsubHatMatKeepVals-IsubHatMatKeepVals3D;
keepMat = [redundancyVals' degeneracyVals' complexityVals'];

keepMatKeep = keepMat;
IfinalKeep  = Ifinal;
IallFinalValsKeep  = IallFinalVals;
redundancyValsKeep = redundancyVals;
degeneracyValsKeep = degeneracyVals;
complexityValsKeep = complexityVals;

% CONSTRAINT FIRST FOR I(X,O) BEING SAME ACROSS
[x,f]      = freq(IallFinalValsKeep);
uniqueVals = x(f>50);
uniqueVals = uniqueVals(uniqueVals>0);
counter    = 1;
%%
for unq=uniqueVals'
    
    keepMat = keepMatKeep;
    Ifinal  = IfinalKeep;
    IallFinalVals  = IallFinalValsKeep;
    redundancyVals = redundancyValsKeep;
    degeneracyVals = degeneracyValsKeep;
    complexityVals = complexityValsKeep;
    
    keepIdxs = find(IallFinalVals==unq);
    NAIdxs   = setdiff(1:size(IsubMatKeepVals,3),keepIdxs);%set others to NA
    
    keepMat(NAIdxs,:) = nan;
    Ifinal(NAIdxs)  = nan;
    IallFinalVals(NAIdxs)  = nan;
    redundancyVals(NAIdxs) = nan;
    degeneracyVals(NAIdxs) = nan;
    complexityVals(NAIdxs) = nan;
    
    %% SIMILAR DEGENERACY, SIMILAR COMPLEXITY, DIFFERENT REDUNDANCY
    [keepMatSorted,i] = sortrows(keepMat,[2,3]);
    ind     = datasample(find(abs(diff(keepMatSorted(:,1)))==max(abs(diff(keepMatSorted(:,1))))),1);
    ind_min = i(ind);
    ind_max = i(ind+1);
    ind_plot_keep =[ind_min ind_max];
%     plot10panel(textCircuits,keepStructure,IsubOneVals,IallFinalVals,degeneracyVals,redundancyVals,complexityVals,Ifinal,IsubMatKeepVals,ind_min,ind_max,0,1)
    plot14panel(textCircuits,keepStructure,IsubOneVals,IallFinalVals,degeneracyVals,redundancyVals,complexityVals,Ifinal,IsubMatKeepVals,IsubsubHatMatKeepVals,ind_min,ind_max,0,1)
    %REDUNDANCY VALUES CAN BE OBTAINED BY THE SUM OF FIRST ROW (k=1) - I(X,O)
    [nansum(IsubMatKeepVals(1,:,ind_min))-IallFinalVals(ind_min) nansum(IsubMatKeepVals(1,:,ind_max))-IallFinalVals(ind_max)]
    %DEGENERACY VALUES CAN BE OBTAINED BY THE SUM OF THE COLUMN MEANS
    [0.5*sum(nanmean(Ifinal(:,:,ind_min),2)) 0.5*sum(nanmean(Ifinal(:,:,ind_max),2))]
    print(gcf,['PLOT_DC_R_' num2str(counter) '.png'],'-dpng','-r300');
    %% SIMILAR REDUNDANCY, SIMILAR COMPLEXITY, DIFFERENT DEGENERACY
    [keepMatSorted,i] = sortrows(keepMat,[1,3]);
    ind     = datasample(find(abs(diff(keepMatSorted(:,2)))==max(abs(diff(keepMatSorted(:,2))))),1);
    ind_min = i(ind);
    ind_max = i(ind+1);
    ind_plot_keep =[ind_plot_keep ind_min ind_max];
%     plot10panel(textCircuits,keepStructure,IsubOneVals,IallFinalVals,degeneracyVals,redundancyVals,complexityVals,Ifinal,IsubMatKeepVals,ind_max,ind_min,0,1)
    plot14panel(textCircuits,keepStructure,IsubOneVals,IallFinalVals,degeneracyVals,redundancyVals,complexityVals,Ifinal,IsubMatKeepVals,IsubsubHatMatKeepVals,ind_min,ind_max,0,1)
    %REDUNDANCY VALUES CAN BE OBTAINED BY THE SUM OF FIRST ROW (k=1) - I(X,O)
    [nansum(IsubMatKeepVals(1,:,ind_min))-IallFinalVals(ind_min) nansum(IsubMatKeepVals(1,:,ind_max))-IallFinalVals(ind_max)]
    %DEGENERACY VALUES CAN BE OBTAINED BY THE SUM OF THE COLUMN MEANS
    [0.5*sum(nanmean(Ifinal(:,:,ind_min),2)) 0.5*sum(nanmean(Ifinal(:,:,ind_max),2))]
    print(gcf,['PLOT_CR_D_' num2str(counter) '.png'],'-dpng','-r300');
    %% SIMILAR REDUNDANCY, SIMILAR DEGENERACY, DIFFERENT COMPLEXITY
    [keepMatSorted,i] = sortrows(keepMat,[1,2]);
    ind     = datasample(find(abs(diff(keepMatSorted(:,3)))==max(abs(diff(keepMatSorted(:,3))))),1);
    ind_min = i(ind);
    ind_max = i(ind+1);
    ind_plot_keep =[ind_plot_keep ind_min ind_max];
%     plot10panel(textCircuits,keepStructure,IsubOneVals,IallFinalVals,degeneracyVals,redundancyVals,complexityVals,Ifinal,IsubMatKeepVals,ind_max,ind_min,0,1)
    plot14panel(textCircuits,keepStructure,IsubOneVals,IallFinalVals,degeneracyVals,redundancyVals,complexityVals,Ifinal,IsubMatKeepVals,IsubsubHatMatKeepVals,ind_min,ind_max,0,1)
    %REDUNDANCY VALUES CAN BE OBTAINED BY THE SUM OF FIRST ROW (k=1) - I(X,O)
    [nansum(IsubMatKeepVals(1,:,ind_min))-IallFinalVals(ind_min) nansum(IsubMatKeepVals(1,:,ind_max))-IallFinalVals(ind_max)]
    %DEGENERACY VALUES CAN BE OBTAINED BY THE SUM OF THE COLUMN MEANS
    [0.5*sum(nanmean(Ifinal(:,:,ind_min),2)) 0.5*sum(nanmean(Ifinal(:,:,ind_max),2))]
    print(gcf,['PLOT_DR_C_' num2str(counter) '.png'],'-dpng','-r300');
    %% SIMILAR REDUNDANCY, SIMILAR DEGENERACY, DIFFERENT COMPLEXITY
    [keepMatSorted,i] = sortrows(keepMat,[1,3]);
    ind     = datasample(find(abs(diff(keepMatSorted(:,2)))==max(abs(diff(keepMatSorted(:,2))))),1);
    ind_min = i(ind);
    ind_max = i(ind+1);
    ind_plot_keep =[ind_plot_keep ind_min ind_max];
%     plot10panel(textCircuits,keepStructure,IsubOneVals,IallFinalVals,degeneracyVals,redundancyVals,complexityVals,Ifinal,IsubMatKeepVals,ind_max,ind_min,0,1)
    plot14panel(textCircuits,keepStructure,IsubOneVals,IallFinalVals,degeneracyVals,redundancyVals,complexityVals,Ifinal,IsubMatKeepVals,IsubsubHatMatKeepVals,ind_min,ind_max,0,1)
    %REDUNDANCY VALUES CAN BE OBTAINED BY THE SUM OF FIRST ROW (k=1) - I(X,O)
    [nansum(IsubMatKeepVals(1,:,ind_min))-IallFinalVals(ind_min) nansum(IsubMatKeepVals(1,:,ind_max))-IallFinalVals(ind_max)]
    %DEGENERACY VALUES CAN BE OBTAINED BY THE SUM OF THE COLUMN MEANS
    [0.5*sum(nanmean(Ifinal(:,:,ind_min),2)) 0.5*sum(nanmean(Ifinal(:,:,ind_max),2))]
    print(gcf,['PLOT_RD_C_' num2str(counter) '.png'],'-dpng','-r300');
    %% HIGHEST REDUNDANCY VS LOWEST REDUNDANCY
    % Redundancy is high if the sum of the mutual information between each element and the output is much larger than
    % the mutual information between the entire system and the output. This means that each of the elements of the
    % system contributes similar information with respect to the output.
    ind_min      = datasample(find(redundancyVals==min(redundancyVals((IallFinalVals>0)))),1);
    ind_max      = datasample(find(redundancyVals==max(redundancyVals)),1);
    ind_plot_keep =[ind_plot_keep ind_min ind_max];
%     plot10panel(textCircuits,keepStructure,IsubOneVals,IallFinalVals,degeneracyVals,redundancyVals,complexityVals,Ifinal,IsubMatKeepVals,ind_min,ind_max,0,1)
    plot14panel(textCircuits,keepStructure,IsubOneVals,IallFinalVals,degeneracyVals,redundancyVals,complexityVals,Ifinal,IsubMatKeepVals,IsubsubHatMatKeepVals,ind_min,ind_max,0,1)
    %REDUNDANCY VALUES CAN BE OBTAINED BY THE SUM OF FIRST ROW (k=1) - I(X,O)
    [nansum(IsubMatKeepVals(1,:,ind_min))-IallFinalVals(ind_min) nansum(IsubMatKeepVals(1,:,ind_max))-IallFinalVals(ind_max)]
    %DEGENERACY VALUES CAN BE OBTAINED BY THE SUM OF THE COLUMN MEANS
    [0.5*sum(nanmean(Ifinal(:,:,ind_min),2)) 0.5*sum(nanmean(Ifinal(:,:,ind_max),2))]
    print(gcf,['PLOT_RR_' num2str(counter) '.png'],'-dpng','-r300');
    %% HIGHEST DEGENERACY VS LOWEST DEGENERACY
    % Thus, according to Eq. 2b, DN(X;O) is high when, on average, the mutual information
    % shared between any bipartition of the system and the output is high (Fig. 2B).
    ind_min      = datasample(find(degeneracyVals==min(degeneracyVals)),1);
    ind_max      = datasample(find(degeneracyVals==max(degeneracyVals)),1);
    ind_plot_keep =[ind_plot_keep ind_min ind_max];
%     plot10panel(textCircuits,keepStructure,IsubOneVals,IallFinalVals,degeneracyVals,redundancyVals,complexityVals,Ifinal,IsubMatKeepVals,ind_min,ind_max,0,1)
    plot14panel(textCircuits,keepStructure,IsubOneVals,IallFinalVals,degeneracyVals,redundancyVals,complexityVals,Ifinal,IsubMatKeepVals,IsubsubHatMatKeepVals,ind_min,ind_max,0,1)
    %REDUNDANCY VALUES CAN BE OBTAINED BY THE SUM OF FIRST ROW (k=1) - I(X,O)
    [nansum(IsubMatKeepVals(1,:,ind_min))-IallFinalVals(ind_min) nansum(IsubMatKeepVals(1,:,ind_max))-IallFinalVals(ind_max)]
    %DEGENERACY VALUES CAN BE OBTAINED BY THE SUM OF THE COLUMN MEANS
    [0.5*sum(nanmean(Ifinal(:,:,ind_min),2)) 0.5*sum(nanmean(Ifinal(:,:,ind_max),2))]
    print(gcf,['PLOT_DD_' num2str(counter) '.png'],'-dpng','-r300');
    %% HIGHEST COMPLEXITY VS LOWEST COMPLEXITY
    % Redundancy is high if the sum of the mutual information between each element and the output is much larger than
    % the mutual information between the entire system and the output. This means that each of the elements of the
    % system contributes similar information with respect to the output.
    ind_min      = datasample(find(complexityVals==min(complexityVals((IallFinalVals>0)))),1);
    ind_max      = datasample(find(complexityVals==max(complexityVals)),1);
    ind_plot_keep =[ind_plot_keep ind_min ind_max];
%     plot10panel(textCircuits,keepStructure,IsubOneVals,IallFinalVals,degeneracyVals,redundancyVals,complexityVals,Ifinal,IsubMatKeepVals,ind_min,ind_max,0,1)
    plot14panel(textCircuits,keepStructure,IsubOneVals,IallFinalVals,degeneracyVals,redundancyVals,complexityVals,Ifinal,IsubMatKeepVals,IsubsubHatMatKeepVals,ind_min,ind_max,0,1)
    %REDUNDANCY VALUES CAN BE OBTAINED BY THE SUM OF FIRST ROW (k=1) - I(X,O)
    [nansum(IsubMatKeepVals(1,:,ind_min))-IallFinalVals(ind_min) nansum(IsubMatKeepVals(1,:,ind_max))-IallFinalVals(ind_max)]
    %DEGENERACY VALUES CAN BE OBTAINED BY THE SUM OF THE COLUMN MEANS
    [0.5*sum(nanmean(Ifinal(:,:,ind_min),2)) 0.5*sum(nanmean(Ifinal(:,:,ind_max),2))]
    print(gcf,['PLOT_CC_' num2str(counter) '.png'],'-dpng','-r300');
    %% ZERO REDUNDANCY (DOESN'T EXIST)
    % % ind_zero      = datasample(find(redundancyVals(redundancyVals>0)<0.3),1);
    % % ind_zero      = datasample(find(redundancyVals==min(redundancyVals(redundancyVals>0))),1);
    % ind_zero      = datasample(find(redundancyVals==0),1);
    % plot10panel(textCircuits,keepStructure,IsubOneVals,IallFinalVals,degeneracyVals,redundancyVals,complexityVals,Ifinal,IsubMatKeepVals,ind_zero,0,1)
    % %REDUNDANCY VALUES CAN BE OBTAINED BY THE SUM OF FIRST ROW (k=1) - I(X,O)
    % [nansum(IsubMatKeepVals(1,:,ind_zero))-IallFinalVals(ind_zero)]
    % %DEGENERACY VALUES CAN BE OBTAINED BY THE SUM OF THE COLUMN MEANS
    % [0.5*sum(nanmean(Ifinal(:,:,ind_zero),2))]
    % print(gcf,'PLOT_05.png','-dpng','-r300');
    %% SMALLEST / LARGEST DIFFERENCE BETWEEN DEGENERACY AND COMPLEXITY
    clc
    dzDiff       = abs(degeneracyVals-complexityVals);
    % ind_min      = datasample(intersect(find(dzDiff>2.3),find(IallFinalVals>0)),1);
    % ind_max      = datasample(intersect(find(dzDiff<0.1),find(IallFinalVals>0)),1);
    ind_min      = datasample(find(dzDiff==min(dzDiff)),1);
    ind_max      = datasample(find(dzDiff==max(dzDiff)),1);
    ind_plot_keep =[ind_plot_keep ind_min ind_max];
%     plot10panel(textCircuits,keepStructure,IsubOneVals,IallFinalVals,degeneracyVals,redundancyVals,complexityVals,Ifinal,IsubMatKeepVals,ind_min,ind_max,0,1)
    plot14panel(textCircuits,keepStructure,IsubOneVals,IallFinalVals,degeneracyVals,redundancyVals,complexityVals,Ifinal,IsubMatKeepVals,IsubsubHatMatKeepVals,ind_min,ind_max,0,1)
    %REDUNDANCY VALUES CAN BE OBTAINED BY THE SUM OF FIRST ROW (k=1) - I(X,O)
    [nansum(IsubMatKeepVals(1,:,ind_min))-IallFinalVals(ind_min) nansum(IsubMatKeepVals(1,:,ind_max))-IallFinalVals(ind_max)]
    %DEGENERACY VALUES CAN BE OBTAINED BY THE SUM OF THE COLUMN MEANS
    [0.5*sum(nanmean(Ifinal(:,:,ind_min),2)) 0.5*sum(nanmean(Ifinal(:,:,ind_max),2))]
    %COMPLEXITY VALUES ACCORDING TO EQ 2.9
    [0.5*sum(nanmean(IsubsubHatMatKeepVals(:,:,ind_min),2)) 0.5*sum(nanmean(IsubsubHatMatKeepVals(:,:,ind_max),2))]
    [complexityVals(ind_min) complexityVals(ind_max)]
    print(gcf,['PLOT_DCDIFF_' num2str(counter) '.png'],'-dpng','-r300');
    %% SANITY CHECK - BELOW SHOULD ALL BE ZERO (OR CLOSE TO ZERO, MACHINE PRECISION)
    clc
    % for mutual information values
    for k=1:1000
        miDiff(k) = IallFinalValsKeep(k)-nanmean(IsubMatKeepVals(end,:,k),2);
    end
    mean(miDiff)
    % for degeneracy values
    for k=1:1000
        dVariation(k) = sum(nanmean(IsubMatKeepVals(:,:,k),2)'-((1:numOfGates)./(numOfGates)).*nanmean(IsubMatKeepVals(end,:,k),2));
    end
    mean(degeneracyValsKeep-dVariation)
    % for complxity values
    for k=1:1000
        cVariation(k) = sum(nanmean(HsubMatKeepVals(:,:,k),2)'-((1:numOfGates)./(numOfGates)).*nanmean(HsubMatKeepVals(end,:,k),2));
    end
    mean(complexityValsKeep-cVariation)
    %% SOLO PLOT 1-BY-1 (FOR THE BLOG)
    inds_plot = unique(ind_plot_keep);
    for ind=inds_plot
%         plot10panel(textCircuits,keepStructure,IsubOneVals,IallFinalVals,degeneracyVals,redundancyVals,complexityVals,Ifinal,IsubMatKeepVals,ind,0,1)
    plot14panel(textCircuits,keepStructure,IsubOneVals,IallFinalVals,degeneracyVals,redundancyVals,complexityVals,Ifinal,IsubMatKeepVals,IsubsubHatMatKeepVals,ind,0,1)
        print(gcf,['PLOT_IND_' num2str(ind) '_' num2str(counter) '.png'],'-dpng','-r300');
        
    end
    counter = counter+1;
end

close all;
