function [] = generateKeepData_ALL(seed)
if(isfile(['AFTER_TOL_ALL_SEED_' num2str(seed) '.mat']))
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
        [degeneracy,degeneracy2,degeneracyUB,redundancy,complexity,circuitSize] = calculateDegeneracy(keepOutput,keepAllOutput,numOfInputs,numOfOutputs,fittestStructure);
        
        if(~isempty(faultTolerance))
            fitness        = 1;
            faultTolerance = faultTolerance(simIdx,fittestCircuitIdx);
        else
            fitness        = fitness(simIdx,fittestCircuitIdx);
            faultTolerance = 0;
        end
        keepData = [keepData; simIdx circuitSize fitness ...
            faultTolerance degeneracy degeneracy2 degeneracyUB ...
            redundancy complexity]
        save(['RDC_' num2str(simIdx) '_SEED_' num2str(seed) '.mat']) %REDUNDANCY, DEGENERACY, COMPLEXITY
    end
    save(['RDC_ALL_SEED_' num2str(seed) '.mat']) %REDUNDANCY, DEGENERACY, COMPLEXITY
else
    disp('Sims not complete for this seed yet, havent saved anything.')
end
end

