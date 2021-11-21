function [textCircuits,strAllText] = circuit2text(keepCircuits,keepStructure)
disp('Converting into text...')
textCircuits  = {};
rowCount      = 1;
for cir=1:size(keepCircuits,2)
    
    tempCircuit   = keepCircuits{cir};
    tempStructure = keepStructure{cir};
    for r=1:size(tempCircuit,1)
        for c=1:tempStructure(r,2)
            inpGateIdx = (r-1)*1000+10*c+3; % 3 denotes input
            outputGates= tempCircuit{r,c};
            textCircuits{rowCount,1}=cir;
            textCircuits{rowCount,2}=inpGateIdx;
            textCircuits{rowCount,3}=sort(outputGates);
            rowCount = rowCount+1;
        end
    end
end

strAllText =[ ];
textCircuitsIdxs = cell2mat(textCircuits(:,1));
for cellIdx=1:max(textCircuitsIdxs)
    
    tempIdxs= find(textCircuitsIdxs==cellIdx);
    textCircuitsTemp = textCircuits(tempIdxs,2:3);
%         strTemp = [];
%     for r=1:size(textCircuitsTemp,1)
%         for c=1:size(textCircuitsTemp,2)
%             strAdd  = strjoin(string(sort(textCircuitsTemp{r,c})));
%             strTemp = strcat(strTemp,strAdd);
%         end
%     end
    strTemp = circuit2str(textCircuitsTemp);
    strAllText{cellIdx,1}=strTemp;
end
disp('Done.')
end

