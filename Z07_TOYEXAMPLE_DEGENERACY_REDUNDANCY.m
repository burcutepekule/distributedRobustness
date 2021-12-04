clear all;close all;clc;
run('load_8GATE.m')
IsubHatMatKeepVals3D = [];
for index=1:size(IsubMatKeepVals,3)
    IsubHatMatKeepVals3D(:,:,index)=repmat(IallFinalVals(index),size(IsubMatKeepVals,[1 2]));
end
Ifinal = IsubMatKeepVals+IsubHatMatKeepVals-IsubHatMatKeepVals3D;
keepMat = [redundancyVals' degeneracyVals'];
%%
figure
scatter(redundancyVals,degeneracyVals,20,'k','filled')
hold on;
scatter(redundancyVals,degeneracyUBVals,20,'r','filled')
grid on;
%% SIMILAR DEGENERACY, DIFFERENT REDUNDANCY
[~,i]         = sort(keepMat(:,2));
keepMatSorted = keepMat(i,:);
ind     = find(abs(diff(keepMatSorted(:,1)))==max(abs(diff(keepMatSorted(:,1)))));
ind_min = i(ind); 
ind_max = i(ind+1); 
plot10panel(textCircuits,keepStructure,IsubOneVals,IallFinalVals,degeneracyVals,redundancyVals,Ifinal,IsubMatKeepVals,ind_min,ind_max,0,1)
%REDUNDANCY VALUES CAN BE OBTAINED BY THE SUM OF FIRST ROW (k=1) - I(X,O)
[nansum(IsubMatKeepVals(1,:,ind_min))-IallFinalVals(ind_min) nansum(IsubMatKeepVals(1,:,ind_max))-IallFinalVals(ind_max)]
%DEGENERACY VALUES CAN BE OBTAINED BY THE SUM OF THE COLUMN MEANS
[0.5*sum(nanmean(Ifinal(:,:,ind_min),2)) 0.5*sum(nanmean(Ifinal(:,:,ind_max),2))]
print(gcf,'PLOT_01.png','-dpng','-r300');     

%% SIMILAR REDUNDANCY, DIFFERENT DEGENERACY
[~,i]         = sort(keepMat(:,1));
keepMatSorted = keepMat(i,:);
ind     = find(abs(diff(keepMatSorted(:,2)))==max(abs(diff(keepMatSorted(:,2)))));
ind_min = i(ind); 
ind_max = i(ind+1); 
plot10panel(textCircuits,keepStructure,IsubOneVals,IallFinalVals,degeneracyVals,redundancyVals,Ifinal,IsubMatKeepVals,ind_max,ind_min,0,1)
%REDUNDANCY VALUES CAN BE OBTAINED BY THE SUM OF FIRST ROW (k=1) - I(X,O)
[nansum(IsubMatKeepVals(1,:,ind_min))-IallFinalVals(ind_min) nansum(IsubMatKeepVals(1,:,ind_max))-IallFinalVals(ind_max)]
%DEGENERACY VALUES CAN BE OBTAINED BY THE SUM OF THE COLUMN MEANS
[0.5*sum(nanmean(Ifinal(:,:,ind_min),2)) 0.5*sum(nanmean(Ifinal(:,:,ind_max),2))]
print(gcf,'PLOT_02.png','-dpng','-r300');  

%% HIGHEST REDUNDANCY VS LOWEST REDUNDANCY
% Redundancy is high if the sum of the mutual information between each element and the output is much larger than 
% the mutual information between the entire system and the output. This means that each of the elements of the 
% system contributes similar information with respect to the output. 
ind_min      = datasample(find(redundancyVals==min(redundancyVals((IallFinalVals>0)))),1);
ind_max      = datasample(find(redundancyVals==max(redundancyVals)),1);
plot10panel(textCircuits,keepStructure,IsubOneVals,IallFinalVals,degeneracyVals,redundancyVals,Ifinal,IsubMatKeepVals,ind_min,ind_max,0,1)
%REDUNDANCY VALUES CAN BE OBTAINED BY THE SUM OF FIRST ROW (k=1) - I(X,O)
[nansum(IsubMatKeepVals(1,:,ind_min))-IallFinalVals(ind_min) nansum(IsubMatKeepVals(1,:,ind_max))-IallFinalVals(ind_max)]
%DEGENERACY VALUES CAN BE OBTAINED BY THE SUM OF THE COLUMN MEANS
[0.5*sum(nanmean(Ifinal(:,:,ind_min),2)) 0.5*sum(nanmean(Ifinal(:,:,ind_max),2))]
print(gcf,'PLOT_03.png','-dpng','-r300'); 
%% HIGHEST DEGENERACY VS LOWEST DEGENERACY
% Thus, according to Eq. 2b, DN(X;O) is high when, on average, the mutual information 
% shared between any bipartition of the system and the output is high (Fig. 2B).
ind_min      = datasample(intersect(find(degeneracyVals<0.3),find(IallFinalVals>0)),1);
ind_max      = datasample(find(degeneracyVals==max(degeneracyVals)),1);
plot10panel(textCircuits,keepStructure,IsubOneVals,IallFinalVals,degeneracyVals,redundancyVals,Ifinal,IsubMatKeepVals,ind_min,ind_max,0,1)
%REDUNDANCY VALUES CAN BE OBTAINED BY THE SUM OF FIRST ROW (k=1) - I(X,O)
[nansum(IsubMatKeepVals(1,:,ind_min))-IallFinalVals(ind_min) nansum(IsubMatKeepVals(1,:,ind_max))-IallFinalVals(ind_max)]
%DEGENERACY VALUES CAN BE OBTAINED BY THE SUM OF THE COLUMN MEANS
[0.5*sum(nanmean(Ifinal(:,:,ind_min),2)) 0.5*sum(nanmean(Ifinal(:,:,ind_max),2))]
print(gcf,'PLOT_04.png','-dpng','-r300'); 
%% ZERO REDUNDANCY
ind_zero      = datasample(find(redundancyVals==0),1);
plot10panel(textCircuits,keepStructure,IsubOneVals,IallFinalVals,degeneracyVals,redundancyVals,Ifinal,IsubMatKeepVals,ind_zero,0,1)
%REDUNDANCY VALUES CAN BE OBTAINED BY THE SUM OF FIRST ROW (k=1) - I(X,O)
[nansum(IsubMatKeepVals(1,:,ind_min))-IallFinalVals(ind_min) nansum(IsubMatKeepVals(1,:,ind_max))-IallFinalVals(ind_max)]
%DEGENERACY VALUES CAN BE OBTAINED BY THE SUM OF THE COLUMN MEANS
[0.5*sum(nanmean(Ifinal(:,:,ind_min),2)) 0.5*sum(nanmean(Ifinal(:,:,ind_max),2))]
print(gcf,'PLOT_05.png','-dpng','-r300'); 

