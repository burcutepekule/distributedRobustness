function [textCircuitsTemp_mutated,structureTemp_mutated] = mutateCircuit(textCircuitsTemp,structureTemp,mutationIdx)

if(mutationIdx==0)
%     disp('No mutation')   
    textCircuitsTemp_mutated = textCircuitsTemp;
    structureTemp_mutated    = structureTemp;
elseif(mutationIdx==1)
    [textCircuitsTemp_mutated,structureTemp_mutated] = mutation01(textCircuitsTemp,structureTemp);
elseif(mutationIdx==2)
    [textCircuitsTemp_mutated,structureTemp_mutated] = mutation02(textCircuitsTemp,structureTemp);
elseif(mutationIdx==3)
    [textCircuitsTemp_mutated,structureTemp_mutated] = mutation03(textCircuitsTemp,structureTemp);
elseif(mutationIdx==4)%kind of a resource allocation
    % add 1 gate first
    [textCircuitsTemp_mutated,structureTemp_mutated] = mutation03(textCircuitsTemp,structureTemp);
    % then remove one gate
    [textCircuitsTemp_mutated,structureTemp_mutated] = mutation02(textCircuitsTemp_mutated,structureTemp_mutated);
else
    disp('Unknown mutation index')   
    textCircuitsTemp_mutated=[];
    structureTemp_mutated   =[];
end

end

