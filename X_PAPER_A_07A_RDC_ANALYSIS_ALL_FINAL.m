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
degeneracy2Mat        = [];
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
    keepData              = keepData_0;
    afterFT               = keepData(keepData(:,4)>0,:);
    seedMat               = [seedMat;s];
    circuitSizeMat        = [circuitSizeMat;keepData(end,2)];
    fitnessMat            = [fitnessMat;keepData(end,3)];
    faultToleranceMat     = [faultToleranceMat;keepData(end,4)];
    degeneracyMat         = [degeneracyMat;keepData(end,5)];
    degeneracy2Mat        = [degeneracy2Mat;keepData(end,6)];
    redundancyMat         = [redundancyMat;keepData(end,8)];
    complexityMat         = [complexityMat;keepData(end,9)];
    
    complexityMat_AFT     = [complexityMat_AFT;afterFT(end,9)];
    faultToleranceMat_AFT = [faultToleranceMat_AFT;afterFT(end,4)];
    
    %% REDUNDANCY VS DEGENERACY
    subplot(2,2,1)
    hold on;
    scatter(keepData(end,8),keepData(end,5),[],cmap(c,:),'filled',...
        'MarkerFaceColor',cmap(c,:),'MarkerFaceAlpha',alphaVec(c),...
        'MarkerEdgeColor',edgeMat(c,:),'MarkerEdgeAlpha',alphaVec(c));
    xlabel('Redundancy','FontSize', 22);
    ylabel('Degeneracy','FontSize', 22);
    grid on;
    %% DEGENERACY VS COMPLEXITY
    subplot(2,2,2)
    hold on;
    scatter(keepData(end,5),keepData(end,9),[],cmap(c,:),'filled',...
        'MarkerFaceColor',cmap(c,:),'MarkerFaceAlpha',alphaVec(c),...
        'MarkerEdgeColor',edgeMat(c,:),'MarkerEdgeAlpha',alphaVec(c));
    xlabel('Degeneracy','FontSize', 22);
    ylabel('Complexity','FontSize', 22);
    grid on;
    %% CIRCUIT SIZE VS DEGENERACY
    subplot(2,2,3)
    hold on;
    scatter(keepData(end,2),keepData(end,5),[],cmap(c,:),'filled',...
        'MarkerFaceColor',cmap(c,:),'MarkerFaceAlpha',alphaVec(c),...
        'MarkerEdgeColor',edgeMat(c,:),'MarkerEdgeAlpha',alphaVec(c));
    xlabel('Circuit Size','FontSize', 22);
    ylabel('Degeneracy','FontSize', 22);
    grid on;
    %% COMPLEXITY VS FAULT TOLERANCE
    subplot(2,2,4)
    hold on;
    scatter(afterFT(end,9),afterFT(end,4),[],'filled',...
        'MarkerFaceColor',cmap(c,:),'MarkerFaceAlpha',alphaVec(c),...
        'MarkerEdgeColor',edgeMat(c,:),'MarkerEdgeAlpha',alphaVec(c));
    xlabel('Complexity','FontSize', 22);
    ylabel('Fault Tolerance','FontSize', 22);
    grid on;
    
    c = c + 1;
end
saveas(h,'4plots_FINAL_0.png')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
degeneracy2Mat        = [];
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
    keepData              = keepData_1;
    afterFT               = keepData(keepData(:,4)>0,:);
    seedMat               = [seedMat;s];
    circuitSizeMat        = [circuitSizeMat;keepData(end,2)];
    fitnessMat            = [fitnessMat;keepData(end,3)];
    faultToleranceMat     = [faultToleranceMat;keepData(end,4)];
    degeneracyMat         = [degeneracyMat;keepData(end,5)];
    degeneracy2Mat        = [degeneracy2Mat;keepData(end,6)];
    redundancyMat         = [redundancyMat;keepData(end,8)];
    complexityMat         = [complexityMat;keepData(end,9)];
    
    complexityMat_AFT     = [complexityMat_AFT;afterFT(end,9)];
    faultToleranceMat_AFT = [faultToleranceMat_AFT;afterFT(end,4)];
    
    %% REDUNDANCY VS DEGENERACY
    subplot(2,2,1)
    hold on;
    scatter(keepData(end,8),keepData(end,5),[],cmap(c,:),'filled',...
        'MarkerFaceColor',cmap(c,:),'MarkerFaceAlpha',alphaVec(c),...
        'MarkerEdgeColor',edgeMat(c,:),'MarkerEdgeAlpha',alphaVec(c));
    xlabel('Redundancy','FontSize', 22);
    ylabel('Degeneracy','FontSize', 22);
    grid on;
    %% DEGENERACY VS COMPLEXITY
    subplot(2,2,2)
    hold on;
    scatter(keepData(end,5),keepData(end,9),[],cmap(c,:),'filled',...
        'MarkerFaceColor',cmap(c,:),'MarkerFaceAlpha',alphaVec(c),...
        'MarkerEdgeColor',edgeMat(c,:),'MarkerEdgeAlpha',alphaVec(c));
    xlabel('Degeneracy','FontSize', 22);
    ylabel('Complexity','FontSize', 22);
    grid on;
    %% CIRCUIT SIZE VS DEGENERACY
    subplot(2,2,3)
    hold on;
    scatter(keepData(end,2),keepData(end,5),[],cmap(c,:),'filled',...
        'MarkerFaceColor',cmap(c,:),'MarkerFaceAlpha',alphaVec(c),...
        'MarkerEdgeColor',edgeMat(c,:),'MarkerEdgeAlpha',alphaVec(c));
    xlabel('Circuit Size','FontSize', 22);
    ylabel('Degeneracy','FontSize', 22);
    grid on;
    %% COMPLEXITY VS FAULT TOLERANCE
    subplot(2,2,4)
    hold on;
    scatter(afterFT(end,9),afterFT(end,4),[],'filled',...
        'MarkerFaceColor',cmap(c,:),'MarkerFaceAlpha',alphaVec(c),...
        'MarkerEdgeColor',edgeMat(c,:),'MarkerEdgeAlpha',alphaVec(c));
    xlabel('Complexity','FontSize', 22);
    ylabel('Fault Tolerance','FontSize', 22);
    grid on;
    
    c = c + 1;
end
saveas(h,'4plots_FINAL_1.png')
