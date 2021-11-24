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
% GATHER DATA
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
statisticalIndependence=[];
option                = 0;
for s=seedsConverged
    % for s=35
    s
    load(['./cluster/RDC_ALL_SEED_' num2str(s)])
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
    statisticalIndependence = [statisticalIndependence;checkStatisticalIndependence(keepAllOutput,fittestStructure)];

end
%% FILTER GIVEN STATISTICAL INDEPENDENCE?
% seedsConverged = seedsConverged(statisticalIndependence==1);
% seedMat        = seedMat(statisticalIndependence==1);
% circuitSizeMat = circuitSizeMat(statisticalIndependence==1);
% faultToleranceMat = faultToleranceMat(statisticalIndependence==1);
% degeneracyMat     = degeneracyMat(statisticalIndependence==1);
% degeneracy2Mat    = degeneracy2Mat(statisticalIndependence==1);
% redundancyMat     = redundancyMat(statisticalIndependence==1);
% complexityMat     = complexityMat(statisticalIndependence==1);
% complexityMat_AFT = complexityMat_AFT(statisticalIndependence==1);
% faultToleranceMat_AFT = faultToleranceMat_AFT(statisticalIndependence==1);

%% FILTER GIVEN CIRCUIT SIZE?
% inds = find(circuitSizeMat>5 & redundancyMat>0);
% seedsConverged = seedsConverged(inds);
% seedMat        = seedMat(inds);
% circuitSizeMat = circuitSizeMat(inds);
% faultToleranceMat = faultToleranceMat(inds);
% degeneracyMat     = degeneracyMat(inds);
% degeneracy2Mat    = degeneracy2Mat(inds);
% redundancyMat     = redundancyMat(inds);
% complexityMat     = complexityMat(inds);
% complexityMat_AFT = complexityMat_AFT(inds);
% faultToleranceMat_AFT = faultToleranceMat_AFT(inds);
%% PLOT
h=figure(1);
set(h, 'Position',  [100, 300, 1000, 1000])
axis tight manual % this ensures that getframe() returns a consistent size
alphaVec = ones(1,length(seedsConverged));
cmap     = parula(length(seedsConverged));
edgeMat  = cmap;
%REDUNDANCY VS DEGENERACY
subplot(2,2,1)
hold on;
scatter(redundancyMat,degeneracyMat,[],cmap,'filled');
xlabel('Redundancy','FontSize', 22);
ylabel('Degeneracy','FontSize', 22);
grid on;
%DEGENERACY VS COMPLEXITY
subplot(2,2,2)
hold on;
scatter(degeneracyMat,complexityMat,[],cmap,'filled');
xlabel('Degeneracy','FontSize', 22);
ylabel('Complexity','FontSize', 22);
grid on;
%CIRCUIT SIZE VS DEGENERACY
subplot(2,2,3)
hold on;
scatter(circuitSizeMat,degeneracyMat,[],cmap,'filled');
xlabel('Circuit Size','FontSize', 22);
ylabel('Degeneracy','FontSize', 22);
grid on;
%COMPLEXITY VS FAULT TOLERANCE
subplot(2,2,4)
hold on;
scatter(complexityMat_AFT,faultToleranceMat_AFT,[],cmap,'filled');
xlabel('Complexity','FontSize', 22);
ylabel('Fault Tolerance','FontSize', 22);
grid on;
saveas(h,['4plots_FINAL.png'])
% saveas(h,['4plots_FINAL_FILTER.png'])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% WITH NEGATIVE REDUNDANCY
% 
% inds      = find(redundancyMat<0);
% sInterest = seedMat(inds);
% sI        = statisticalIndependence(inds);
% load(['./cluster/AFTER_TOL_ALL_SEED_' num2str(sInterest(6)) '.mat']);
% 
% fittestStructure     = structuresMutated{fittestCircuitIdx};
% fittestTextCircuit   = textCircuitsMutated(cell2mat(textCircuitsMutated(:,1))==fittestCircuitIdx,:);
% [keepOutput,keepAllOutput]   = solvePerturbedCircuit(numOfInputs,1,fittestTextCircuit(:,2:3),fittestStructure,0);
% 
% figure
% connectionMatInitial = drawCircuit_text(fittestStructure,fittestTextCircuit,numOfOutputs,1);
% 
% 
% tbl=printTruthTable(fittestStructure,keepAllOutput,0)
% checkStatisticalIndependence(keepAllOutput,fittestStructure)
% %%
% sInterest = seedMat(redundancyMat<0);
% 
% load(['./cluster/AFTER_TOL_ALL_SEED_' num2str(sInterest(3)) '.mat']);
% 
% fittestStructure     = structuresMutated{fittestCircuitIdx};
% fittestTextCircuit   = textCircuitsMutated(cell2mat(textCircuitsMutated(:,1))==fittestCircuitIdx,:);
% [keepOutput,keepAllOutput]   = solvePerturbedCircuit(numOfInputs,1,fittestTextCircuit(:,2:3),fittestStructure,0);
% 
% figure
% connectionMatInitial = drawCircuit_text(fittestStructure,fittestTextCircuit,numOfOutputs,1);
% 
% 
% tbl=printTruthTable(fittestStructure,keepAllOutput,0)
% %%
% sInterest = seedMat(redundancyMat==0);
% 
% load(['./cluster/AFTER_TOL_ALL_SEED_' num2str(sInterest(1)) '.mat']);
% 
% fittestStructure     = structuresMutated{fittestCircuitIdx};
% fittestTextCircuit   = textCircuitsMutated(cell2mat(textCircuitsMutated(:,1))==fittestCircuitIdx,:);
% [keepOutput,keepAllOutput]   = solvePerturbedCircuit(numOfInputs,1,fittestTextCircuit(:,2:3),fittestStructure,0);
% 
% figure
% connectionMatInitial = drawCircuit_text(fittestStructure,fittestTextCircuit,numOfOutputs,1);
% 
% [degeneracy,degeneracy2,degeneracyUB,redundancy,complexity,circuitSize] = calculateDegeneracyOption(keepOutput,keepAllOutput,fittestStructure,0);
% tbl=printTruthTable(fittestStructure,keepAllOutput,0)
% checkStatisticalIndependence(keepAllOutput,fittestStructure)
% %%
% 
% h025 = -0.25*log2(0.25);
% h050 = -0.50*log2(0.50);
% h075 = -0.75*log2(0.75);
