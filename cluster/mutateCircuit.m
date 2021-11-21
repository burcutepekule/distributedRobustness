function [textCircuitsTemp_mutated,structureTemp_mutated] = mutateCircuit(textCircuitsTemp,structureTemp,mutationIdx)

if(mutationIdx==1)
    [textCircuitsTemp_mutated,structureTemp_mutated] = mutation01(textCircuitsTemp,structureTemp);
elseif(mutationIdx==2)
    [textCircuitsTemp_mutated,structureTemp_mutated] = mutation02(textCircuitsTemp,structureTemp);
elseif(mutationIdx==3)
    [textCircuitsTemp_mutated,structureTemp_mutated] = mutation03(textCircuitsTemp,structureTemp);
else
    disp('Unknown mutation index')   
    textCircuitsTemp_mutated=[];
    structureTemp_mutated   =[];
end

end

