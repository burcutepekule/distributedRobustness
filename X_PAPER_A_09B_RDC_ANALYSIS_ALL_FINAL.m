clear all;close all;clc;
fileinfoRDC    = dir(['./cluster/AFTER_TOL_ALL_SEED_*.mat']);
allNames       = {fileinfoRDC.name};
seedsConverged = str2double(extractBefore(extractAfter(allNames,'AFTER_TOL_ALL_SEED_'),'.mat'));
%%GATHER DATA
seedMat                  = [];

circuitSizeMat_BT        = [];
fitnessMat_BT            = [];
faultToleranceMat_BT     = [];
degeneracyMat_BT         = [];
degeneracy2Mat_BT        = [];
degeneracyUBMat_BT       = [];
redundancyMat_BT         = [];
complexityMat_BT         = [];

circuitSizeMat_AT        = [];
fitnessMat_AT            = [];
faultToleranceMat_AT     = [];
degeneracyMat_AT         = [];
degeneracy2Mat_AT        = [];
degeneracyUBMat_AT       = [];
redundancyMat_AT         = [];
complexityMat_AT         = [];
for s=seedsConverged
    s
    seedMat                  = [seedMat;s];
    
    load(['./cluster/BEFORE_TOL_ALL_SEED_' num2str(s)])
    circuitSizeMat_BT        = [circuitSizeMat_BT;circuitSize];
    fitnessMat_BT            = [fitnessMat_BT;fitnessPick];
    faultToleranceMat_BT     = [faultToleranceMat_BT;faultTolerancePick];
    degeneracyMat_BT         = [degeneracyMat_BT;degeneracy];
    degeneracy2Mat_BT        = [degeneracy2Mat_BT;degeneracy2];
    degeneracyUBMat_BT       = [degeneracyUBMat_BT;degeneracyUB];
    redundancyMat_BT         = [redundancyMat_BT;redundancy];
    complexityMat_BT         = [complexityMat_BT;complexity];
    
    
    load(['./cluster/AFTER_TOL_ALL_SEED_' num2str(s)])
    circuitSizeMat_AT        = [circuitSizeMat_AT;circuitSize];
    fitnessMat_AT            = [fitnessMat_AT;fitnessPick];
    faultToleranceMat_AT     = [faultToleranceMat_AT;faultTolerancePick];
    degeneracyMat_AT         = [degeneracyMat_AT;degeneracy];
    degeneracy2Mat_AT        = [degeneracy2Mat_AT;degeneracy2];
    degeneracyUBMat_AT       = [degeneracyUBMat_AT;degeneracyUB];
    redundancyMat_AT         = [redundancyMat_AT;redundancy];
    complexityMat_AT         = [complexityMat_AT;complexity];
   
end
%% PLOT
close all;
h=figure(1);
set(h, 'Position',  [100, 300, 1000, 1000])
axis tight manual % this ensures that getframe() returns a consistent size
alphaVec = ones(1,length(seedsConverged));
cmap_AT  = [255, 114, 111]./255;
cmap_BT  = [0 0 0]./255;
%REDUNDANCY VS DEGENERACY
subplot(2,2,1)
hold on;
scatter(redundancyMat_BT,degeneracyMat_BT,80,cmap_BT,'filled','^');
hold on;
scatter(redundancyMat_AT,degeneracyMat_AT,80,cmap_AT,'filled','o');
% axis([0 max(redundancyMat_AT) 0 7])
% axis([0 6 0 7])
xlabel('Redundancy','FontSize', 22);
ylabel('Degeneracy','FontSize', 22);
grid on;
%DEGENERACY VS COMPLEXITY
subplot(2,2,2)
hold on;
scatter(degeneracyMat_BT,complexityMat_BT,80,cmap_BT,'filled','^');
hold on;
scatter(degeneracyMat_AT,complexityMat_AT,80,cmap_AT,'filled','o');
% axis([0 7 0 10])
xlabel('Degeneracy','FontSize', 22);
ylabel('Complexity','FontSize', 22);
grid on;
%CIRCUIT SIZE VS DEGENERACY
subplot(2,2,3)
hold on;
scatter(circuitSizeMat_BT,degeneracyMat_BT,80,cmap_BT,'filled','^');
hold on;
scatter(circuitSizeMat_AT,degeneracyMat_AT,80,cmap_AT,'filled','o');
% axis([5 max(circuitSizeMat_AT) 0 7])
xlabel('Circuit Size','FontSize', 22);
ylabel('Degeneracy','FontSize', 22);
grid on;
%COMPLEXITY VS FAULT TOLERANCE
subplot(2,2,4)
hold on;
scatter(complexityMat_BT,faultToleranceMat_BT,80,cmap_BT,'filled','^');
hold on;
scatter(complexityMat_AT,faultToleranceMat_AT,80,cmap_AT,'filled','o');
% axis([0 10 0.6 1])
xlabel('Complexity','FontSize', 22);
ylabel('Fault Tolerance','FontSize', 22);
grid on;
saveas(h,['4plots_FINAL.png'])
