clear all;close all;clc;
fileinfoRDC    = dir(['./cluster/AFTER_TOL_ALL_SEED_*.mat']);
allNames       = {fileinfoRDC.name};
seedsConverged = str2double(extractBefore(extractAfter(allNames,'AFTER_TOL_ALL_SEED_'),'.mat'));

totalNumVec = [];
for seed = seedsConverged
    fileinfoBefore = dir(['./cluster/BEFORE_TOL_FITTEST_CIRCUIT_SEED_' num2str(seed) '_*.mat']);
    fileinfoAfter  = dir(['./cluster/AFTER_TOL_FITTEST_CIRCUIT_SEED_' num2str(seed) '_*.mat']);
    lastIdx        = size(fileinfoBefore,1);
    totalNumVec    = [totalNumVec size(fileinfoBefore,1)+size(fileinfoAfter,1)];
end
[~,i]      = sort(totalNumVec,'descend');
seedSorted = seedsConverged(i);
seedPick   = seedSorted(1:10);
%%
for seed = seedPick
    
    fitnessVals    = [];
    degeneracyVals = [];
    complexityVals = [];
    redundancyVals = [];
    toleranceVals  = [];
    
    fileinfoBefore = dir(['./cluster/BEFORE_TOL_FITTEST_CIRCUIT_SEED_' num2str(seed) '_*.mat']);
    fileinfoAfter  = dir(['./cluster/AFTER_TOL_FITTEST_CIRCUIT_SEED_' num2str(seed) '_*.mat']);
    lastIdx        = size(fileinfoBefore,1);
    totalNum       = size(fileinfoBefore,1)+size(fileinfoAfter,1);
    %%
    cmap     = parula(5);
    cmap     = [cmap(1:3,:);0.7373    0.1924    0.7373;1.0000    0.4000    0.7176];
    filename = ['circuitsAnimated_SEED_' num2str(seed) '.gif'] ;
    %%
    close all;
    figure
    set(gcf, 'Position',  [100, 300, 500, 1600])
    [ha, ~] = tight_subplot(3,1,[0.08 0.05],[0.05 0.05],[0.075 0.02]);
    axis tight manual

    for simIdx=1:totalNum
        [seed simIdx totalNum]
        if(simIdx <= lastIdx)
            load(['./cluster/BEFORE_TOL_FITTEST_CIRCUIT_SEED_' num2str(seed) '_' num2str(simIdx) '.mat']);
            titleText = {['Fittest circuit of size ' num2str(circuitSize)], 'Optimizing for fitness only'};
            
        else
            load(['./cluster/AFTER_TOL_FITTEST_CIRCUIT_SEED_' num2str(seed) '_' num2str(simIdx) '.mat']);
            titleText = {['Fittest circuit of size ' num2str(circuitSize)], 'Optimizing for fitness and fault tolerance'};
        end
        
        fittestStructure     = structuresMutated{fittestCircuitIdx};
        fittestTextCircuit   = textCircuitsMutated(cell2mat(textCircuitsMutated(:,1))==fittestCircuitIdx,:);
        
        fitnessVals    = [fitnessVals fitnessPick];
        degeneracyVals = [degeneracyVals (degeneracy)];
        complexityVals = [complexityVals (complexity)];
        redundancyVals = [redundancyVals (redundancy)];
        toleranceVals  = [toleranceVals faultTolerancePick];
        
        %         h=figure('visible','off');
        %         axis tight manual % this ensures that getframe() returns a consistent size

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        cla(ha(1))
        axes(ha(1))
        connectionMatInitial = drawCircuit_text(fittestStructure,fittestTextCircuit,numOfOutputs,0);
        title(titleText,'FontSize', 14);
        axis off;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        cla(ha(2))
        axes(ha(2))
        plot(1:simIdx,fitnessVals,'o-','Color',cmap(1,:),'MarkerFaceColor',cmap(1,:),'MarkerEdgeColor',cmap(1,:),'MarkerSize',6,'linewidth',2)
        hold on;
        if(simIdx > lastIdx)
            plot(1:simIdx,toleranceVals,'o-','Color',cmap(5,:),'MarkerFaceColor',cmap(5,:),'MarkerEdgeColor',cmap(5,:),'MarkerSize',6,'linewidth',2)
            plot(1:lastIdx,toleranceVals(1:lastIdx),'o-','Color',cmap(5,:),'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',cmap(5,:),'MarkerSize',6,'linewidth',2)
        else
            plot(1:simIdx,toleranceVals,'o-','Color',cmap(5,:),'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',cmap(5,:),'MarkerSize',6,'linewidth',2)
        end
        grid on;
        axis([0.3 totalNum+1 0 1.1])
        xlabel('Simulation Index', 'FontSize', 14);
        ylabel('Value', 'FontSize', 14);
        title('Quantitative measures', 'FontSize', 14);
        legend('Fitness','Fault Tolerance', 'FontSize', 14, 'Location', 'southeast');
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        cla(ha(3))
        axes(ha(3))
        plot(1:simIdx,degeneracyVals,'o-','Color',cmap(2,:),'MarkerFaceColor',cmap(2,:),'MarkerEdgeColor',cmap(2,:),'MarkerSize',6,'linewidth',2)
        hold on;
        plot(1:simIdx,complexityVals,'o-','Color',cmap(3,:),'MarkerFaceColor',cmap(3,:),'MarkerEdgeColor',cmap(3,:),'MarkerSize',6,'linewidth',2)
        plot(1:simIdx,redundancyVals,'o-','Color',cmap(4,:),'MarkerFaceColor',cmap(4,:),'MarkerEdgeColor',cmap(4,:),'MarkerSize',6,'linewidth',2)
        grid on;
        axis([0 totalNum+1 0 9.5])
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

