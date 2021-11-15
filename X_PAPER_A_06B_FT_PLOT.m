clear all;close all;clc;
fileinfoBefore = dir('BEFORE_TOL_FITTEST_CIRCUIT_*.mat');
fileinfoAfter  = dir('AFTER_TOL_FITTEST_CIRCUIT_*.mat');
totalNum       = size(fileinfoBefore,1)+size(fileinfoAfter,1);
lastIdx        = size(fileinfoBefore,1);
fitnessVals    = [];
toleranceVals  = [];
h=figure('visible','off');
set(h, 'Position',  [100, 300, 1500, 400])
axis tight manual % this ensures that getframe() returns a consistent size
filename = 'circuitsAnimated.gif';
% for simIdx=1:totalNum
for simIdx=1:totalNum
    simIdx
    if(simIdx <= size(fileinfoBefore,1))
        load(['BEFORE_TOL_FITTEST_CIRCUIT_' num2str(simIdx) '.mat'])
    else
        load(['AFTER_TOL_FITTEST_CIRCUIT_' num2str(simIdx) '.mat'])
    end
    fittestStructure     = structuresMutated{fittestCircuitIdx};
    fittestTextCircuit   = textCircuitsMutated(cell2mat(textCircuitsMutated(:,1))==fittestCircuitIdx,:);
    if(~isempty(faultTolerance))
        fitnessVals          = [fitnessVals 1];
        toleranceVals  = [toleranceVals faultTolerance(simIdx,fittestCircuitIdx)];
    else
        fitnessVals          = [fitnessVals fitness(simIdx,fittestCircuitIdx)];
        toleranceVals  = [toleranceVals 0];
        
    end
    %     if(simIdx==totalNum)
    h=figure('visible','off');
    set(h, 'Position',  [100, 300, 1500, 400])
    axis tight manual % this ensures that getframe() returns a consistent size
    subplot(1,2,1)
    connectionMatInitial = drawCircuit_text(fittestStructure,fittestTextCircuit,numOfOutputs,0);
    title('Fittest Circuit','FontSize', 18);
    axis off;
    subplot(1,2,2)
    plot(1:simIdx,fitnessVals,'ko-','MarkerFaceColor',[0 0 0],'MarkerSize',5)
    hold on;
    if(~isempty(faultTolerance))
        plot(1:simIdx,toleranceVals,'ro-','MarkerFaceColor',[1 0 0],'MarkerSize',5)
        hold on;
        plot(1:lastIdx,toleranceVals(1:lastIdx),'ro-','MarkerFaceColor',[1 1 1],'MarkerSize',5)
    else
        plot(1:simIdx,toleranceVals,'ro-','MarkerFaceColor',[1 1 1],'MarkerSize',5)
    end
    grid on;
    axis([0 totalNum+10 0 1.1])
    xlabel('Simulation Index', 'FontSize', 18);
    ylabel('Value', 'FontSize', 18);
    title('Fitness and Fault Tolerance', 'FontSize', 18);
    legend('Fitness','Fault Tolerance', 'FontSize', 20, 'Location', 'southeast');
    %     saveas(h,['FIG_' num2str(simIdx)],'png')
    %     end
    
    % Capture the plot as an image
    frame = getframe(h);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    % Write to the GIF File
    if simIdx == 1
        imwrite(imind,cm,filename,'gif','DelayTime',0.2,'Loopcount',inf);
    else
        imwrite(imind,cm,filename,'gif','DelayTime',0.2,'WriteMode','append');
    end
    
end
%%
% for k = 109:114
% 
%     src = ['AFTER_TOL_FITTEST_CIRCUIT_' num2str(k) '.mat'];
%     dst = ['AFTER_TOL_FITTEST_CIRCUIT_' num2str(k-1) '.mat'];
%         movefile(src, dst);
% end