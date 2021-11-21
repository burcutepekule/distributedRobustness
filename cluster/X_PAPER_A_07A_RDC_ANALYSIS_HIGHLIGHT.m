clear all;close all;clc;
fileinfoRDC    = dir(['./cluster/RDC_ALL_SEED_*.mat']);
allNames       = {fileinfoRDC.name};
seedsConverged = str2double(extractBefore(extractAfter(allNames,'RDC_ALL_SEED_'),'.mat'));
%%
% %%
% keepData = [keepData;
%  simIdx            1
%  circuitSize       2
%  fitness           3
%  faultTolerance    4
%  degeneracy        5
%  degeneracy2       6
%  degeneracyUB      7
%  redundancy        8
%  complexity        9
%  ];

%%
for s_hl=seedsConverged
    alphaVec = 0.015*ones(1,length(seedsConverged));
    alphaVec(seedsConverged==s_hl) = 1;
    cmap    = viridis(length(seedsConverged));
    edgeMat = cmap;
    edgeMat(seedsConverged==s_hl,:) = [0 0 0];
    close all;
    h=figure('visible','off');
    set(h, 'Position',  [100, 300, 1000, 1000])
    c    = 1;
    for s=seedsConverged
        [s_hl s]
        load(['./cluster/RDC_ALL_SEED_' num2str(s)])
        afterFT = keepData(keepData(:,4)>0,:);
        %% REDUNDANCY VS DEGENERACY
        subplot(2,2,1)
        hold on;
        scatter(keepData(:,8),keepData(:,5),[],cmap(c,:),'filled',...
            'MarkerFaceColor',cmap(c,:),'MarkerFaceAlpha',alphaVec(c),...
            'MarkerEdgeColor',edgeMat(c,:),'MarkerEdgeAlpha',alphaVec(c));
        xlabel('Redundancy','FontSize', 22);
        ylabel('Degeneracy','FontSize', 22);
        grid on;
        %% DEGENERACY VS COMPLEXITY
        subplot(2,2,2)
        hold on;
        scatter(keepData(:,5),keepData(:,9),[],cmap(c,:),'filled',...
            'MarkerFaceColor',cmap(c,:),'MarkerFaceAlpha',alphaVec(c),...
            'MarkerEdgeColor',edgeMat(c,:),'MarkerEdgeAlpha',alphaVec(c));
        xlabel('Degeneracy','FontSize', 22);
        ylabel('Complexity','FontSize', 22);
        grid on;
        %% CIRCUIT SIZE VS DEGENERACY
        subplot(2,2,3)
        hold on;
        scatter(keepData(:,2),keepData(:,5),[],cmap(c,:),'filled',...
            'MarkerFaceColor',cmap(c,:),'MarkerFaceAlpha',alphaVec(c),...
            'MarkerEdgeColor',edgeMat(c,:),'MarkerEdgeAlpha',alphaVec(c));
        xlabel('Circuit Size','FontSize', 22);
        ylabel('Degeneracy','FontSize', 22);
        grid on;
        %% COMPLEXITY VS FAULT TOLERANCE
        subplot(2,2,4)
        hold on;
        scatter(afterFT(:,9),afterFT(:,4),[],'filled',...
            'MarkerFaceColor',cmap(c,:),'MarkerFaceAlpha',alphaVec(c),...
            'MarkerEdgeColor',edgeMat(c,:),'MarkerEdgeAlpha',alphaVec(c));
        xlabel('Complexity','FontSize', 22);
        ylabel('Fault Tolerance','FontSize', 22);
        grid on;
        
        c = c + 1;
    end
    saveas(h,['4plots_HL_' num2str(s_hl)],'png')
end
%%

% tbl = table(circuitSizeMat,fitnessMat,faultToleranceMat,degeneracyMat,redundancyMat,complexityMat);
% %%
% binranges = 0:2:30;
% [bincounts,ind] = histc(complexityMat,binranges);
% %%
% boxplot(faultToleranceMat,ind)
