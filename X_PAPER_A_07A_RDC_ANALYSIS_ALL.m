clear all;close all;clc;
fileinfoRDC    = dir(['./cluster/RDC_ALL_SEED_*.mat']);
allNames       = {fileinfoRDC.name};
seedsConverged = str2double(extractBefore(extractAfter(allNames,'RDC_ALL_SEED_'),'.mat'));

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
camp = viridis(length(seedsConverged));
c    = 1;
h=figure(1)
set(h, 'Position',  [100, 300, 1000, 1000])
axis tight manual % this ensures that getframe() returns a consistent size
seedMat               = [];
circuitSizeMat        = [];
fitnessMat            = [];
faultToleranceMat     = [];
degeneracyMat         = [];
redundancyMat         = [];
complexityMat         = [];
complexityMat_AFT     = [];
faultToleranceMat_AFT = [];
alphaVec = ones(1,length(seedsConverged));
cmap     = viridis(length(seedsConverged));
edgeMat  = cmap;
%%
for s=seedsConverged
% for s=35
    s
    load(['./cluster/RDC_ALL_SEED_' num2str(s)])
    
    afterFT               = keepData(keepData(:,4)>0,:);
    seedMat               = [seedMat;repmat(s,size(keepData,1),1)];
    circuitSizeMat        = [circuitSizeMat;keepData(:,2)];
    fitnessMat            = [fitnessMat;keepData(:,3)];
    faultToleranceMat     = [faultToleranceMat;keepData(:,4)];
    degeneracyMat         = [degeneracyMat;keepData(:,5)];
    redundancyMat         = [redundancyMat;keepData(:,8)];
    complexityMat         = [complexityMat;keepData(:,9)];
    
    complexityMat_AFT     = [complexityMat_AFT;afterFT(:,9)];
    faultToleranceMat_AFT = [faultToleranceMat_AFT;afterFT(:,4)];
    
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
saveas(h,'4plots.png')
