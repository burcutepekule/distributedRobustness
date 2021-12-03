clear all;close all;clc;
fileinfoRDC    = dir(['./cluster/RDC_ALL_SEED_*_BTOL.mat']);
allNames       = {fileinfoRDC.name};
seedsConverged = str2double(extractBefore(extractAfter(allNames,'RDC_ALL_SEED_'),'_BTOL.mat'));
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
%% GATHER DATA
seedMat               = [];
circuitSizeMat        = [];
fitnessMat            = [];
degeneracyMat         = [];
degeneracy2Mat        = [];
redundancyMat         = [];
complexityMat         = [];

circuitSizeMat_I      = [];
fitnessMat_I          = [];
degeneracyMat_I       = [];
degeneracy2Mat_I      = [];
redundancyMat_I       = [];
complexityMat_I       = [];


for s=seedsConverged
    % for s=35
    s
    load(['./cluster/RDC_ALL_SEED_' num2str(s) '_BTOL'])
    %     afterFT               = keepData(keepData(:,4)>0,:);
    seedMat               = [seedMat;s];
    
    circuitSizeMat        = [circuitSizeMat;keepData(end,2)];
    fitnessMat            = [fitnessMat;keepData(end,3)];
    degeneracyMat         = [degeneracyMat;keepData(end,5)];
    degeneracy2Mat        = [degeneracy2Mat;keepData(end,6)];
    redundancyMat         = [redundancyMat;keepData(end,8)];
    complexityMat         = [complexityMat;keepData(end,9)];
    
    
%     circuitSizeMat_I        = [circuitSizeMat_I;keepDataInitial(end,2)];
%     fitnessMat_I            = [fitnessMat_I;keepDataInitial(end,3)];
%     degeneracyMat_I         = [degeneracyMat_I;keepDataInitial(end,5)];
%     degeneracy2Mat_I        = [degeneracy2Mat_I;keepDataInitial(end,6)];
%     redundancyMat_I         = [redundancyMat_I;keepDataInitial(end,8)];
%     complexityMat_I         = [complexityMat_I;keepDataInitial(end,9)];
  
%     h=figure('visible','off');
%     set(h, 'Position',  [100, 300, 1200, 1000])
%     axis tight manual % this ensures that getframe() returns a consistent size
%     connectionMatBeforeTol = drawCircuit_text(fittestStructure,fittestTextCircuit,numOfOutputs,1);
%     saveas(h,['CIRCUIT_SEED_ ' num2str(seed) '_BEFORETOL.png'])
%     
%     
%     h=figure('visible','off');
%     set(h, 'Position',  [100, 300, 1200, 1000])
%     axis tight manual % this ensures that getframe() returns a consistent size
%     connectionMatInitial = drawCircuit_text(fittestStructureInitial,fittestTextCircuitInitial,numOfOutputs,1);
%     saveas(h,['CIRCUIT_SEED_ ' num2str(seed) '_INITIAL.png'])

end
%%
figure
scatter(degeneracyMat_I,degeneracyMat,20,'k','filled')
hold on;
plot([0 max([degeneracyMat_I;degeneracyMat])],[0 max([degeneracyMat_I;degeneracyMat])],'r','linewidth',2)
figure
scatter(redundancyMat_I,redundancyMat,20,'k','filled')
hold on;
plot([0 max([redundancyMat_I;redundancyMat])],[0 max([redundancyMat_I;redundancyMat])],'r','linewidth',2)
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
close all;
h=figure(1);
set(h, 'Position',  [100, 300, 1000, 1000])
axis tight manual % this ensures that getframe() returns a consistent size
alphaVec = ones(1,length(seedsConverged));
cmap     = parula(length(seedsConverged));
edgeMat  = cmap;
%REDUNDANCY VS DEGENERACY
subplot(2,2,1)
hold on;
% scatter(log(redundancyMat),log(degeneracyMat),[],cmap,'filled');
% xlabel('Redundancy','FontSize', 22);
% ylabel('Degeneracy','FontSize', 22);

scatter((redundancyMat),(degeneracyMat),[],cmap,'filled');
xlabel('Redundancy','FontSize', 22);
ylabel('Degeneracy','FontSize', 22);
grid on;
axis([0 max([redundancyMat(:);degeneracyMat(:)]) 0 max([redundancyMat(:);degeneracyMat(:)])])

%DEGENERACY VS COMPLEXITY
subplot(2,2,2)
hold on;
scatter(degeneracyMat,complexityMat,[],cmap,'filled');
xlabel('Degeneracy','FontSize', 22);
ylabel('Complexity','FontSize', 22);
grid on;
axis([0 max([complexityMat(:);degeneracyMat(:)]) 0 max([complexityMat(:);degeneracyMat(:)])])

%CIRCUIT SIZE VS DEGENERACY
subplot(2,2,3)
hold on;
scatter(circuitSizeMat,degeneracyMat,[],cmap,'filled');
xlabel('Circuit Size','FontSize', 22);
ylabel('Degeneracy','FontSize', 22);
grid on;
axis([min(circuitSizeMat(:)) max([circuitSizeMat(:);degeneracyMat(:)]) 0 max([circuitSizeMat(:);degeneracyMat(:)])])

% %COMPLEXITY VS FAULT TOLERANCE
% subplot(2,2,4)
% hold on;
% scatter(complexityMat_AFT,faultToleranceMat_AFT,[],cmap,'filled');
% xlabel('Complexity','FontSize', 22);
% ylabel('Fault Tolerance','FontSize', 22);
% grid on;
% saveas(h,['4plots_FINAL_BTOL.png'])
% % saveas(h,['4plots_FINAL_FILTER.png'])

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
