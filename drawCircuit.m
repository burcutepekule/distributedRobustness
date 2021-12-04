function [] = drawCircuit(structureTemp,textCircuitsTemp,numOfOutputs)
ymax = 10+size(textCircuitsTemp,1);
xmax = 10+size(textCircuitsTemp,1);
ymin = 0;
xmin = 0;
xPlot= linspace(xmin,xmax,size(structureTemp,1)+1+2);
xPlot= xPlot(2:end-1);
outletPointsInp  = [];
inletPointsOut   = [];
inletPointsNAND  = [];
outletPointsNAND = [];

close all;figure();axis([xmin xmax ymin ymax]);hold on;
for l=1:size(structureTemp,1)
    layerTemp = structureTemp(l,1);
    gatesTemp = structureTemp(l,2);
    xPlotTemp = xPlot(l);
    yPlotTemp = linspace(ymin,ymax,gatesTemp+2);
    yPlotTemp = yPlotTemp(2:end-1);
    
    if(layerTemp==0) %input layer
        for i=1:gatesTemp
            outletPointsInpTemp = drawINPUT(xPlotTemp,yPlotTemp(i));
            outletPointsInp     = [outletPointsInp; repmat(layerTemp,1,1) repmat(i,1,1) outletPointsInpTemp];
        end
    else %mid layers
        for i=1:gatesTemp
            [inletPointsTemp,outletPointsTemp] = drawNAND(xPlotTemp,yPlotTemp(i));
            inletPointsNAND = [inletPointsNAND; repmat(layerTemp,2,1) repmat(i,2,1) inletPointsTemp];
            outletPointsNAND = [outletPointsNAND; repmat(layerTemp,1,1) repmat(i,1,1) outletPointsTemp];
        end
    end
end
% draw output layers
layerTemp = size(structureTemp,1)+1;
yPlotTemp = linspace(ymin,ymax,numOfOutputs+2);
yPlotTemp = yPlotTemp(2:end-1);
for i=1:numOfOutputs
    inletPointsOutTemp = drawOUTPUT(xPlot(end),yPlotTemp(i));
    inletPointsOut     = [inletPointsOut; repmat(layerTemp,1,1) repmat(i,1,1) inletPointsOutTemp];
end

connectionMat_x = [];
connectionMat_y = [];
for k=1:size(textCircuitsTemp,1)
    connectFrom = cell2mat(textCircuitsTemp(k,2));
    connectTo   = cell2mat(textCircuitsTemp(k,3));
    if(floor(connectFrom/1000)==0) % input layer
        for j=1:length(connectTo)
            inpConnectFrom  = floor(connectFrom/10);
            layer2connect   = floor(connectTo(j)/1000);
            gate2connect    = floor(mod(connectTo(j),1000)/10);
            inp2connect     = mod(connectTo(j),10);
            inpNANDIdxs     = inletPointsNAND(inletPointsNAND(:,1)==layer2connect & inletPointsNAND(:,2)==gate2connect,:);
            inpNANDIdx      = inpNANDIdxs(inp2connect,:);
            connectionMat_x = [connectionMat_x; outletPointsInp((outletPointsInp(:,2)==inpConnectFrom),3) inpNANDIdx(3)];
            connectionMat_y = [connectionMat_y; outletPointsInp((outletPointsInp(:,2)==inpConnectFrom),4) inpNANDIdx(4)];
        end
    else
        layerConnectFrom = floor(connectFrom/1000);
        gateConnectFrom  = floor(mod(connectFrom,1000)/10);
        for j=1:length(connectTo)
            layer2connect   = floor(connectTo(j)/1000);
            gate2connect    = floor(mod(connectTo(j),1000)/10);
            inp2connect     = mod(connectTo(j),10);
            
            outNANDIdxs     = outletPointsNAND(outletPointsNAND(:,1)==layerConnectFrom & outletPointsNAND(:,2)==gateConnectFrom,:);
            
            inpNANDIdxs     = inletPointsNAND(inletPointsNAND(:,1)==layer2connect & inletPointsNAND(:,2)==gate2connect,:);
            inpNANDIdx      = inpNANDIdxs(inp2connect,:);
            
            connectionMat_x = [connectionMat_x; outNANDIdxs(3) inpNANDIdx(3)];
            connectionMat_y = [connectionMat_y; outNANDIdxs(4) inpNANDIdx(4)];
        end
    end
end

layerConnectFrom = structureTemp(end,1);
outletGatesNAND  = outletPointsNAND(outletPointsNAND(:,1)==layerConnectFrom,2);
for k=outletGatesNAND'
    outNANDIdxs     = outletPointsNAND(outletPointsNAND(:,1)==layerConnectFrom & outletPointsNAND(:,2)==k,:);
    inpOutIdx       = inletPointsOut(k,:);
    connectionMat_x = [connectionMat_x; outNANDIdxs(3) inpOutIdx(3)];
    connectionMat_y = [connectionMat_y; outNANDIdxs(4) inpOutIdx(4)];
    
end

connectFrom      = cell2mat(textCircuitsTemp(end,3));
connectTo   = cell2mat(textCircuitsTemp(k,3));

cmap = lines(size(connectionMat_x,1));
for k=1:size(connectionMat_x,1)
    %     line(connectionMat_x(k,:),connectionMat_y(k,:),'Color',cmap(k,:))
    line(connectionMat_x(k,:),connectionMat_y(k,:),'Color','k')
end
axis tight
end

