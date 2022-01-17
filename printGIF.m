function [] = printGIF(totalNum,fitnessVals,toleranceVals,degeneracyVals,complexityVals,redundancyVals,circuitSizeVals,lastIdx,seed)

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
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    close all;
    figure
    set(gcf, 'Position',  [100, 300, 1000, 1400])
    [ha, ~] = tight_subplot(4,2,[0.08 0.05],[0.05 0.05],[0.075 0.02]);
    axis tight manual
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FIRST COLUMN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cmap     = bone(4);
    cmap     = [cmap(1:3,:);[255, 42, 38]./255;[255, 114, 111]./255];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cla(ha(3))
    
    cla(ha(1))
    axes(ha(1))
    connectionMatInitial = drawCircuit_text(fittestStructure,fittestTextCircuit,0);
    title(titleText,'FontSize', 14);
    axis off;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cla(ha(5))
    axes(ha(5))
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
%     xlabel('Simulation Index', 'FontSize', 14);
    ylabel('Value', 'FontSize', 14);
    title('Quantitative measures', 'FontSize', 14);
%     legend('Fitness','Fault Tolerance', 'FontSize', 14, 'Location', 'southeast');
        legend(['Fitness : ' num2str(round(fitnessVals(simIdx),3))],...
            ['Fault Tolerance : ' num2str(round(toleranceVals(simIdx),3))],...
            'FontSize', 14, 'Location', 'southeast');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cla(ha(7))
    axes(ha(7))
    plot(1:simIdx,degeneracyVals(1:simIdx),'o-','Color',cmap(2,:),'MarkerFaceColor',cmap(2,:),'MarkerEdgeColor',cmap(2,:),'MarkerSize',6,'linewidth',2)
    hold on;
    plot(1:simIdx,complexityVals(1:simIdx),'o-','Color',cmap(3,:),'MarkerFaceColor',cmap(3,:),'MarkerEdgeColor',cmap(3,:),'MarkerSize',6,'linewidth',2)
    plot(1:simIdx,redundancyVals(1:simIdx),'o-','Color',cmap(4,:),'MarkerFaceColor',cmap(4,:),'MarkerEdgeColor',cmap(4,:),'MarkerSize',6,'linewidth',2)
    grid on;
    axis([0 totalNum+1 0 max([degeneracyVals(:);complexityVals(:);redundancyVals(:)])+1])
    xlabel('Simulation Index', 'FontSize', 14);
    ylabel('Value', 'FontSize', 14);
%     title('Quantitative measures', 'FontSize', 14);
%     legend('Degeneracy','Complexity','Redundancy','FontSize', 14, 'Location', 'southeast');
    legend(['Degeneracy : ' num2str(round(degeneracyVals(simIdx),3))],...
        ['Complexity : ' num2str(round(complexityVals(simIdx),3))],...
        ['Redundancy : ' num2str(round(redundancyVals(simIdx),3))],...
        'FontSize', 14, 'Location', 'southeast');

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    shrink2height     = 0.0;
    initialHeight     = ha(1).Position(4);
    ha(3).Position(4) = shrink2height;
    leftoverHeight    = initialHeight-shrink2height;
    
    
    ha(1).Position(4)=ha(1).Position(4)+2*leftoverHeight/3;
    ha(5).Position(4)=ha(5).Position(4)+1*leftoverHeight/3;
    ha(7).Position(4)=ha(7).Position(4)+1*leftoverHeight/3;
    
    ha(1).Position(2)=ha(1).Position(2)-2.75*leftoverHeight/3;
    ha(5).Position(2)=ha(5).Position(2)+1.25*leftoverHeight/3;
    ha(7).Position(2)=ha(7).Position(2)+0.50*leftoverHeight/3;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SECOND COLUMN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cmap    = [1 0.8 0.8 ;bone(100)];
    Ifinal  = IsubMatKeep+IsubHatMatKeep-repmat(IallFinal,size(IsubMatKeep,[1 2]));
    
    valsMatmin_1=IsubMatKeep;
    valsMatmin_2=Ifinal;
    bottom = -0.2;
    %         top    = max([valsMatmin_1(:);valsMatmin_2(:)]);
    top    = 1.4; % ALSO TO HAVE CONSISTENCY ACROSS FIGURES
    
    cla(ha(2))
    axes(ha(2))
    imagesc(valsMatmin_1')
    caxis([bottom top]);
    colormap(cmap)
    cb=colorbar;
    cb.TickLabels{1}='NA';
    title('$I(X_{i}^{k},O)$','interpreter','latex','Fontsize',16)
    ylabel('$k$','interpreter','latex','Fontsize',16)
    %         xlabel('$i$','interpreter','latex','Fontsize',16)
    
    cla(ha(4))
    axes(ha(4))
    tVals = round(nansum(valsMatmin_1'),2);
    t = num2cell(round(nansum(valsMatmin_1'),2)); % extact values into cells
    t = cellfun(@num2str, t, 'UniformOutput', false); % convert to string
    imagesc(nansum(valsMatmin_1'))
    x = 1:length(nansum(valsMatmin_1'));
    % we are only interested in the first value for redundancy and last
    % value because it is equal to I(X,O)
    endIdx = length(x);
    if(tVals(1)<0.6)
        text(1, 1, t{1}, 'HorizontalAlignment', 'Center','Color','White','Fontweight','Bold')
    else
        text(1, 1, t{1}, 'HorizontalAlignment', 'Center','Color','Black','Fontweight','Bold')
    end
    
    if(tVals(endIdx)<0.6)
        text(endIdx, 1, t{endIdx}, 'HorizontalAlignment', 'Center','Color','White','Fontweight','Bold')
    else
        text(endIdx, 1, t{endIdx}, 'HorizontalAlignment', 'Center','Color','Black','Fontweight','Bold')
    end
    
    caxis([bottom top]);
    colormap(cmap)
    cb=colorbar;
    cb.TickLabels{1}='NA';
    title('$\sum_{k} I(X_{i}^{k},O)$','interpreter','latex','Fontsize',16)
    %         ylabel('$k$','interpreter','latex','Fontsize',16)
    xlabel('$i$','interpreter','latex','Fontsize',16)
    
    cla(ha(6))
    axes(ha(6))
    imagesc(valsMatmin_2')
    caxis([bottom top]);
    colormap(cmap)
    cb=colorbar;
    cb.TickLabels{1}='NA';
    title('$I(X_{i}^{k},O) + I(\hat{X}_{i}^{k},O) - I(X,O)$','interpreter','latex','Fontsize',16)
    ylabel('$k$','interpreter','latex','Fontsize',16)
    %         xlabel('$i$','interpreter','latex','Fontsize',16)
    
    cla(ha(8))
    axes(ha(8))
    tVals = round(nanmean(valsMatmin_2'),2);
    t = num2cell(round(nanmean(valsMatmin_2'),2)); % extact values into cells
    t = cellfun(@num2str, t, 'UniformOutput', false); % convert to string
    imagesc(nanmean(valsMatmin_2'))
    x = 1:length(nanmean(valsMatmin_2'));
    y = ones(1,length(nanmean(valsMatmin_2')));
    for m=1:length(x)
        if(tVals(m)<0.6)
            text(x(m), y(m), t{m}, 'HorizontalAlignment', 'Center','Color','White','Fontweight','Bold')
        else
            text(x(m), y(m), t{m}, 'HorizontalAlignment', 'Center','Color','Black','Fontweight','Bold')
        end
    end
    caxis([bottom top]);
    colormap(cmap)
    cb=colorbar;
    cb.TickLabels{1}='NA';
    title('$<I(X_{i}^{k},O) + I(\hat{X}_{i}^{k},O) - I(X,O)>$','interpreter','latex','Fontsize',16)
    %         xlabel('$k$','interpreter','latex','Fontsize',16)
    ylabel('$i$','interpreter','latex','Fontsize',16)
    
    shrink2height = 0.025;
    initialHeight = ha(2).Position(4);
    ha(4).Position(4)=shrink2height;
    ha(8).Position(4)=shrink2height;
    leftoverHeight= 2*(initialHeight-shrink2height);
    
    ha(2).Position(4)=ha(2).Position(4)+leftoverHeight/2;
    ha(6).Position(4)=ha(6).Position(4)+leftoverHeight/2;
    
    ha(2).Position(2)=ha(2).Position(2)-1.75*leftoverHeight/3;
    ha(6).Position(2)=ha(6).Position(2)-1.50*leftoverHeight/3;
    ha(8).Position(2)=ha(8).Position(2)+0.25*leftoverHeight/3;
    
    set(gcf,'InvertHardCopy','off','Color','white');
    
    % Capture the plot as an image
    frame = getframe(gcf);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    % Write to the GIF File
    delayTime = 0.45;
    if simIdx == 1
        imwrite(imind,cm,filename,'gif','DelayTime',delayTime,'Loopcount',inf);
    else
        imwrite(imind,cm,filename,'gif','DelayTime',delayTime,'WriteMode','append');
        if(simIdx == totalNum) % append the last frame a few times more so that one can see the final results for longer
            for rep=1:8
                imwrite(imind,cm,filename,'gif','DelayTime',delayTime,'WriteMode','append');
            end
        end
    end
end
close(gcf)
end

