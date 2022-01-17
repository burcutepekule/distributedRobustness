function [colIdxs] = gate2colIdx(gates,tempStructure)
colIdxs = [];
for l=1:length(gates)
    gatesTemp = gates(l);
    if(gatesTemp<1000)
        colIdxsTemp=0;
    else
        layerIdxTemp   = floor(gatesTemp./1000);
        gateIdxTemp    = floor((gatesTemp-layerIdxTemp.*1000)./10);
        nodeIdxTemp    = mod((gatesTemp-layerIdxTemp.*1000),10);
        startBlockIdxs = sum(tempStructure(2:layerIdxTemp,2))+1;
        blockIdxs      = startBlockIdxs+(gateIdxTemp-1);
        colIdxsTemp    = 3*(blockIdxs-1)+nodeIdxTemp;
    end
    colIdxs = [colIdxs colIdxsTemp];
end
end
