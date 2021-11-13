clear all;close all;clc;
fileinfoBefore = dir('BEFORE_TOL_FITTEST_CIRCUIT_*.mat');
fileinfoAfter  = dir('AFTER_TOL_FITTEST_CIRCUIT_*.mat');
totalNum       = size(fileinfoBefore,1)+size(fileinfoAfter,1);
%%
fitnessVals  =[];
toleranceVals=[];
goOn         =0;
for sim=1:totalNum
    sim
    % for sim=1
    if(sim <= size(fileinfoBefore,1))
        if(isfile(['BEFORE_TOL_FITTEST_CIRCUIT_' num2str(sim) '.mat']))
            load(['BEFORE_TOL_FITTEST_CIRCUIT_' num2str(sim) '.mat'])
            goOn = 1;
        end
    else
        if(isfile(['AFTER_TOL_FITTEST_CIRCUIT_' num2str(sim) '.mat']))
            load(['AFTER_TOL_FITTEST_CIRCUIT_' num2str(sim) '.mat'])
            goOn = 1;
        end
    end
    if(goOn==1)
        fittestStructure     = structuresMutated{fittestCircuitIdx};
        fittestTextCircuit   = textCircuitsMutated(cell2mat(textCircuitsMutated(:,1))==fittestCircuitIdx,:);
        fitnessVals          = [fitnessVals fitness(sim,fittestCircuitIdx)];
        if(~isempty(faultTolerance))
            toleranceVals  = [toleranceVals faultTolerance(sim,fittestCircuitIdx)];
        else
            toleranceVals  = [toleranceVals 0];
        end
        figure('visible','off')
        set(gcf, 'Position',  [100, 300, 1500, 400])
        subplot(1,2,1)
        connectionMatInitial = drawCircuit_text(fittestStructure,fittestTextCircuit,numOfOutputs);
        title('Fitest Circuit')
        axis off;
        subplot(1,2,2)
        plot(1:sim,fitnessVals,'ko-','MarkerFaceColor',[0 0 0],'MarkerSize',5)
        hold on;
        if(~isempty(faultTolerance))
            plot(1:sim,toleranceVals,'ro-','MarkerFaceColor',[1 0 0],'MarkerSize',5)
        else
            plot(1:sim,toleranceVals,'ro-','MarkerFaceColor',[1 1 1],'MarkerSize',5)
        end
        axis([0 totalNum+10 0 1.1])
        title('Fitness and Fault Tolerance')
        legend('Fitness','Fault Tolerance')
        saveas(gcf,['FIG_' num2str(sim)],'png')
    end
end
%%
for k = 66:102
    
    src = ['AFTER_TOL_FITTEST_CIRCUIT_' num2str(k) '.mat'];
    dst = ['AFTER_TOL_FITTEST_CIRCUIT_' num2str(k-1) '.mat'];
        movefile(src, dst);
end