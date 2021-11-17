clear all;close all;clc;
% parpool('local')
seed             = 2;
fileinfoBefore   = dir(['BEFORE_TOL_FITTEST_CIRCUIT_SEED_' num2str(seed) '_*.mat']);
fileinfoAfter    = dir(['AFTER_TOL_FITTEST_CIRCUIT_SEED_' num2str(seed) '_*.mat']);
totalNum         = size(fileinfoBefore,1)+size(fileinfoAfter,1);
lastIdx          = size(fileinfoBefore,1);
keepData         = [];
plotOn           = 0;
for simIdx=1:totalNum
    if(simIdx <= size(fileinfoBefore,1)) 
        load(['BEFORE_TOL_FITTEST_CIRCUIT_SEED_' num2str(seed) '_' num2str(simIdx) '.mat']);
    else
        load(['AFTER_TOL_FITTEST_CIRCUIT_SEED_' num2str(seed) '_' num2str(simIdx) '.mat']);
    end
    fittestStructure             = structuresMutated{fittestCircuitIdx};
    fittestTextCircuit           = textCircuitsMutated(cell2mat(textCircuitsMutated(:,1))==fittestCircuitIdx,:);
    [keepOutput,keepAllOutput]   = solvePerturbedCircuit(numOfInputs,1,fittestTextCircuit(:,2:3),fittestStructure,0);
    [degeneracy,degeneracyUB,redundancy,complexity,circuitSize] = calculateDegeneracy(keepOutput,keepAllOutput,numOfInputs,numOfOutputs,fittestStructure);
    
    if(~isempty(faultTolerance))
        fitness        = 1;
        faultTolerance = faultTolerance(simIdx,fittestCircuitIdx);
    else
        fitness        = fitness(simIdx,fittestCircuitIdx);
        faultTolerance = 0;
    end
    keepData = [keepData; simIdx circuitSize fitness ...
        faultTolerance degeneracy degeneracyUB ...
        redundancy complexity]
    
    %     if(plotOn==1)
    %         h=figure('visible','off');
    %         set(h, 'Position',  [100, 300, 1500, 400])
    %         axis tight manual % this ensures that getframe() returns a consistent size
    %         subplot(1,2,1)
    %         connectionMatInitial = drawCircuit_text(fittestStructure,fittestTextCircuit,numOfOutputs,0);
    %         title('Fittest Circuit','FontSize', 18);
    %         axis off;
    %         subplot(1,2,2)
    %         plot(1:simIdx,fitnessVals,'ko-','MarkerFaceColor',[0 0 0],'MarkerSize',5)
    %         hold on;
    %         if(~isempty(faultTolerance))
    %             plot(1:simIdx,toleranceVals,'ro-','MarkerFaceColor',[1 0 0],'MarkerSize',5)
    %             hold on;
    %             plot(1:lastIdx,toleranceVals(1:lastIdx),'ro-','MarkerFaceColor',[1 1 1],'MarkerSize',5)
    %         else
    %             plot(1:simIdx,toleranceVals,'ro-','MarkerFaceColor',[1 1 1],'MarkerSize',5)
    %         end
    %         hold on;
    %         plot(1:simIdx,degeneracyVals,'bo-','MarkerFaceColor',[0 0 1],'MarkerSize',5)
    %         grid on;
    %         axis([0 totalNum+10 0 10])
    %         xlabel('Simulation Index', 'FontSize', 18);
    %         ylabel('Value', 'FontSize', 18);
    %         title('Fitness, fault Tolerance, and degeneracy', 'FontSize', 18);
    %         legend('Fitness','Fault Tolerance','Degeneracy', 'FontSize', 20, 'Location', 'northwest');
    %         %     saveas(h,['FIG_' num2str(simIdx)],'png')
    %
    %         % Capture the plot as an image
    %         frame = getframe(h);
    %         im = frame2im(frame);
    %         [imind,cm] = rgb2ind(im,256);
    %         % Write to the GIF File
    %         if simIdx == 1
    %             imwrite(imind,cm,filename,'gif','DelayTime',0.2,'Loopcount',inf);
    %         else
    %             imwrite(imind,cm,filename,'gif','DelayTime',0.2,'WriteMode','append');
    %         end
    %     end
    save(['RDC_' num2str(simIdx) '_SEED_' num2str(seed) '.mat']) %REDUNDANCY, DEGENERACY, COMPLEXITY
end
 save(['RDC_ALL_SEED_' num2str(seed) '.mat']) %REDUNDANCY, DEGENERACY, COMPLEXITY
%%

% for k = 1:113
%     src = ['RDC_' num2str(k) '.mat'];
%     dst = ['RDC_' num2str(k) '_SEED_1.mat'];
% %     src = ['BEFORE_TOL_FITTEST_CIRCUIT_' num2str(k) '.mat'];
% %     dst = ['BEFORE_TOL_FITTEST_CIRCUIT_SEED_1_' num2str(k) '.mat'];
%         movefile(src, dst);
% end