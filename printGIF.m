function [] = printGIF(totalNum,fitnessVals,toleranceVals,degeneracyVals,complexityVals,redundancyVals,circuitSizeVals,lastIdx,seed)
close all;
figure
set(gcf, 'Position',  [100, 300, 500, 1600])
[ha, ~] = tight_subplot(3,1,[0.08 0.05],[0.05 0.05],[0.075 0.02]);
axis tight manual


% cmap     = parula(5);
cmap     = bone(4);
cmap     = [cmap(1:3,:);[255, 42, 38]./255;[255, 114, 111]./255];
filename = ['./cluster_output/circuitsAnimated_SEED_' num2str(seed) '.gif'] ;

for simIdx=1:totalNum
    
    if(simIdx <= lastIdx)
        load(['./cluster_output/BEFORE_TOL_FITTEST_CIRCUIT_SEED_' num2str(seed) '_' num2str(simIdx) '.mat']);
        titleText = {['Fittest circuit of size ' num2str(circuitSizeVals(simIdx))], 'Optimizing for fitness only'};
        
    else
        load(['./cluster_output/AFTER_TOL_FITTEST_CIRCUIT_SEED_' num2str(seed) '_' num2str(simIdx) '.mat']);
        titleText = {['Fittest circuit of size ' num2str(circuitSizeVals(simIdx))], 'Optimizing for fitness and fault tolerance'};
    end
    fittestStructure     = structuresMutated{fittestCircuitIdx};
    fittestTextCircuit   = textCircuitsMutated(cell2mat(textCircuitsMutated(:,1))==fittestCircuitIdx,:);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cla(ha(1))
    axes(ha(1))
    connectionMatInitial = drawCircuit_text(fittestStructure,fittestTextCircuit,0);
    title(titleText,'FontSize', 14);
    axis off;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cla(ha(2))
    axes(ha(2))
    plot(1:simIdx,fitnessVals(1:simIdx),'o-','Color',cmap(1,:),'MarkerFaceColor',cmap(1,:),'MarkerEdgeColor',cmap(1,:),'MarkerSize',6,'linewidth',2)
    hold on;
    if(simIdx > lastIdx)
        plot(1:simIdx,toleranceVals(1:simIdx),'o-','Color',cmap(5,:),'MarkerFaceColor',cmap(5,:),'MarkerEdgeColor',cmap(5,:),'MarkerSize',6,'linewidth',2)
        plot(1:lastIdx,toleranceVals(1:lastIdx),'o-','Color',cmap(5,:),'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',cmap(5,:),'MarkerSize',6,'linewidth',2)
    else
        plot(1:simIdx,toleranceVals(1:simIdx),'o-','Color',cmap(5,:),'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',cmap(5,:),'MarkerSize',6,'linewidth',2)
    end
    grid on;
    axis([0 totalNum+1 min([toleranceVals(:);fitnessVals(:)])-0.05 1.1])
    xlabel('Simulation Index', 'FontSize', 14);
    ylabel('Value', 'FontSize', 14);
    title('Quantitative measures', 'FontSize', 14);
    legend('Fitness','Fault Tolerance', 'FontSize', 14, 'Location', 'southeast');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cla(ha(3))
    axes(ha(3))
    plot(1:simIdx,degeneracyVals(1:simIdx),'o-','Color',cmap(2,:),'MarkerFaceColor',cmap(2,:),'MarkerEdgeColor',cmap(2,:),'MarkerSize',6,'linewidth',2)
    hold on;
    plot(1:simIdx,complexityVals(1:simIdx),'o-','Color',cmap(3,:),'MarkerFaceColor',cmap(3,:),'MarkerEdgeColor',cmap(3,:),'MarkerSize',6,'linewidth',2)
    plot(1:simIdx,redundancyVals(1:simIdx),'o-','Color',cmap(4,:),'MarkerFaceColor',cmap(4,:),'MarkerEdgeColor',cmap(4,:),'MarkerSize',6,'linewidth',2)
    grid on;
    axis([0 totalNum+1 0 max([degeneracyVals(:);complexityVals(:);redundancyVals(:)])+1])
    xlabel('Simulation Index', 'FontSize', 14);
    ylabel('Value', 'FontSize', 14);
    title('Quantitative measures', 'FontSize', 14);
    legend('Degeneracy','Complexity','Redundancy','FontSize', 14, 'Location', 'southeast');
    
    % Capture the plot as an image
    frame = getframe(gcf);
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
close(gcf)
end

