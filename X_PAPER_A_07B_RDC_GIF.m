clear all;close all;clc;
fileinfoBefore = dir('BEFORE_TOL_FITTEST_CIRCUIT_*.mat');
fileinfoAfter  = dir('AFTER_TOL_FITTEST_CIRCUIT_*.mat');
% fileRDC        = dir('RDC_*.mat');
lastIdx        = size(fileinfoBefore,1);
seed           = 2;
load(['RDC_ALL_SEED_' num2str(seed) '.mat']);
totalNum = size(keepData,1);
%%
cmap     = parula(5);
cmap     = [cmap(1:3,:);0.7373    0.1924    0.7373;1.0000    0.4000    0.7176];
h=figure('visible','off');
set(h, 'Position',  [100, 300, 1500, 400])
axis tight manual % this ensures that getframe() returns a consistent size
filename = ['circuitsAnimated_SEED_' num2str(seed) '.gif'] ;
%%
for simIdx=1:totalNum
    simIdx
    circuitSizeVals      = keepData(1:simIdx,2);
    fitnessVals          = keepData(1:simIdx,3);
    toleranceVals        = keepData(1:simIdx,4);
    degeneracyVals       = log10(keepData(1:simIdx,5));
    degeneracyUBVals     = log10(keepData(1:simIdx,6));
    redundancyVals       = log10(keepData(1:simIdx,7));
    complexityVals       = log10(keepData(1:simIdx,8));
    
    if(simIdx <= size(fileinfoBefore,1))
        load(['BEFORE_TOL_FITTEST_CIRCUIT_SEED_' num2str(seed) '_' num2str(simIdx) '.mat']);
        titleText = {['Fittest circuit of size ' num2str(circuitSizeVals(end))], 'Optimizing for fitness only'};
        
    else
        load(['AFTER_TOL_FITTEST_CIRCUIT_SEED_' num2str(seed) '_' num2str(simIdx) '.mat']);
        titleText = {['Fittest circuit of size ' num2str(circuitSizeVals(end))], 'Optimizing for fitness and fault tolerance'};
    end
    
    fittestStructure     = structuresMutated{fittestCircuitIdx};
    fittestTextCircuit   = textCircuitsMutated(cell2mat(textCircuitsMutated(:,1))==fittestCircuitIdx,:);
    
    
    %     if(simIdx==totalNum)
    h=figure('visible','off');
    set(h, 'Position',  [100, 300, 1200, 1500])
    axis tight manual % this ensures that getframe() returns a consistent size
    s1=subplot(2,1,1);
    connectionMatInitial = drawCircuit_text(fittestStructure,fittestTextCircuit,numOfOutputs,0);
    title(titleText,'FontSize', 26);
    axis off;
    s2=subplot(2,1,2);
    plot(1:simIdx,fitnessVals,'o-','Color',cmap(1,:),'MarkerFaceColor',cmap(1,:),'MarkerEdgeColor',cmap(1,:),'MarkerSize',10,'linewidth',2)
    hold on;
    plot(1:simIdx,degeneracyVals,'o-','Color',cmap(2,:),'MarkerFaceColor',cmap(2,:),'MarkerEdgeColor',cmap(2,:),'MarkerSize',10,'linewidth',2)
    plot(1:simIdx,complexityVals,'o-','Color',cmap(3,:),'MarkerFaceColor',cmap(3,:),'MarkerEdgeColor',cmap(3,:),'MarkerSize',10,'linewidth',2)
    plot(1:simIdx,redundancyVals,'o-','Color',cmap(4,:),'MarkerFaceColor',cmap(4,:),'MarkerEdgeColor',cmap(4,:),'MarkerSize',10,'linewidth',2)
    if(~isempty(faultTolerance))
        plot(1:simIdx,toleranceVals,'o-','Color',cmap(5,:),'MarkerFaceColor',cmap(5,:),'MarkerEdgeColor',cmap(5,:),'MarkerSize',10,'linewidth',2)
        plot(1:lastIdx,toleranceVals(1:lastIdx),'o-','Color',cmap(5,:),'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',cmap(5,:),'MarkerSize',10,'linewidth',2)
    else
        plot(1:simIdx,toleranceVals,'o-','Color',cmap(5,:),'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',cmap(5,:),'MarkerSize',10,'linewidth',2)
    end
    grid on;
    axis([0 totalNum+1 -1 1.3])
    xlabel('Simulation Index', 'FontSize', 26);
    ylabel('Value', 'FontSize', 26);
     title('Quantitative measures', 'FontSize', 26);
    legend('Fitness','log_{10}(Degeneracy)', ...
        'log_{10}(Complexity)','log_{10}(Redundancy)','Fault Tolerance', 'FontSize', 24, 'Location', 'southeast');
    %     saveas(h,['FIG_' num2str(simIdx)],'png')
    %     end

    s2.FontSize = 26;
    % Capture the plot as an image
    frame = getframe(h);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    % Write to the GIF File
    if simIdx == 1
        imwrite(imind,cm,filename,'gif','DelayTime',0.25,'Loopcount',inf);
    else
        imwrite(imind,cm,filename,'gif','DelayTime',0.25,'WriteMode','append');
        if(simIdx == totalNum) % append the last frame a few times more so that one can see the final results for longer
            for rep=1:8
                imwrite(imind,cm,filename,'gif','DelayTime',0.25,'WriteMode','append');
            end
        end
    end
    
end