function [conn] = drawCircuit_text_Ind(fittestTextCircuit,fittestStructure,indPlot)
for k=1:length(indPlot)
    allInds          = unique(cell2mat(fittestTextCircuit(:,1)));
    structureTemp    = fittestStructure{indPlot(k)};
    textCircuitsTemp = fittestTextCircuit(cell2mat(fittestTextCircuit(:,1))==allInds(indPlot(k)),:);
    conn = drawCircuit_text(structureTemp,textCircuitsTemp,0);
end
end

