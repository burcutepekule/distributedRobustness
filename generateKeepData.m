function [] = generateKeepData(seed)
if(isfile(['AFTER_TOL_ALL_SEED_' num2str(seed) '.mat']))
    fileinfoBefore   = dir(['BEFORE_TOL_FITTEST_CIRCUIT_SEED_' num2str(seed) '_*.mat']);
    fileinfoAfter    = dir(['AFTER_TOL_FITTEST_CIRCUIT_SEED_' num2str(seed) '_*.mat']);
    
%     totalNum         = size(fileinfoBefore,1)+size(fileinfoAfter,1);
%     keepData       = [];
%     simIdx           = totalNum;
%     load(['AFTER_TOL_FITTEST_CIRCUIT_SEED_' num2str(seed) '_' num2str(simIdx) '.mat']);

%     if(~isempty(faultTolerance))
%         fitness        = 1;
%         faultTolerance = faultTolerance(simIdx,fittestCircuitIdx);
%     else
%         fitness        = fitness(simIdx,fittestCircuitIdx);
%         faultTolerance = 0;
%     end

    load(['AFTER_TOL_ALL_SEED_' num2str(seed) '.mat']);
    faultTolerance               = faultTolerance(end,fittestCircuitIdx);
    fitness                      = fitness(end,fittestCircuitIdx);
    keepData                     = [];
    fittestStructure             = structuresMutated{fittestCircuitIdx};
    fittestTextCircuit           = textCircuitsMutated(cell2mat(textCircuitsMutated(:,1))==fittestCircuitIdx,:);
    [keepOutput,keepAllOutput]   = solvePerturbedCircuit(numOfInputs,1,fittestTextCircuit(:,2:3),fittestStructure,0);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FOR OPTION 0 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [degeneracy,degeneracy2,degeneracyUB,redundancy,complexity,circuitSize] = calculateDegeneracy(keepOutput,keepAllOutput,fittestStructure);
    keepData = [keepData; size(fitness,1) circuitSize fitness ...
        faultTolerance degeneracy degeneracy2 degeneracyUB ...
        redundancy complexity];
    save(['RDC_ALL_SEED_' num2str(seed) '.mat']) %REDUNDANCY, DEGENERACY, COMPLEXITY
    
    % save before and after photos?
    
    % INITIAL
    load(['BEFORE_TOL_FITTEST_CIRCUIT_SEED_' num2str(seed) '_1.mat'])
    fittestStructure             = structuresMutated{fittestCircuitIdx};
    fittestTextCircuit           = textCircuitsMutated(cell2mat(textCircuitsMutated(:,1))==fittestCircuitIdx,:);
    
    h=figure('visible','off');
    set(h, 'Position',  [100, 300, 1200, 1000])
    axis tight manual % this ensures that getframe() returns a consistent size
    connectionMatInitial = drawCircuit_text(fittestStructure,fittestTextCircuit,numOfOutputs,1);
    saveas(h,['CIRCUIT_SEED_ ' num2str(seed) '_0.png'])
    
    % FIT1
    load(['BEFORE_TOL_FITTEST_CIRCUIT_SEED_' num2str(seed) '_' num2str(size(fileinfoBefore,1)) '.mat'])
    fittestStructure             = structuresMutated{fittestCircuitIdx};
    fittestTextCircuit           = textCircuitsMutated(cell2mat(textCircuitsMutated(:,1))==fittestCircuitIdx,:);
    
    h=figure('visible','off');
    set(h, 'Position',  [100, 300, 1200, 1000])
    axis tight manual % this ensures that getframe() returns a consistent size
    connectionMatInitial = drawCircuit_text(fittestStructure,fittestTextCircuit,numOfOutputs,1);
    saveas(h,['CIRCUIT_SEED_ ' num2str(seed) '_F.png'])
    
    % FIT1 + FT1
    load(['AFTER_TOL_FITTEST_CIRCUIT_SEED_' num2str(seed) '_' num2str(size(fileinfoBefore,1)+1) '.mat'])
    fittestStructure             = structuresMutated{fittestCircuitIdx};
    fittestTextCircuit           = textCircuitsMutated(cell2mat(textCircuitsMutated(:,1))==fittestCircuitIdx,:);
    
    h=figure('visible','off');
    set(h, 'Position',  [100, 300, 1200, 1000])
    axis tight manual % this ensures that getframe() returns a consistent size
    connectionMatInitial = drawCircuit_text(fittestStructure,fittestTextCircuit,numOfOutputs,1);
    saveas(h,['CIRCUIT_SEED_ ' num2str(seed) '_FT.png'])
    
else
    disp('Sims not complete for this seed yet, havent saved anything.')
end
end

