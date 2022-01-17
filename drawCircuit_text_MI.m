function [connectionMat_text] = drawCircuit_text_MI(structureTemp,textCircuitsTemp,IsubOneVals,IallFinalVals,degenval,redunval,compval,textOnAll,textOnMI)
ymax = 10+size(textCircuitsTemp,1);
xmax = 10+size(textCircuitsTemp,1);
ymin = 0;
xmin = 0;
xPlot= linspace(xmin,xmax,size(structureTemp,1)+1+2);
xPlot= xPlot(2:end-1);
outletPointsInp  = [];
centerPointsInp  = [];
inletPointsOut   = [];
inletPointsNAND  = [];
outletPointsNAND = [];

numOfInputs  = structureTemp(1,2);
numOfOutputs = structureTemp(end,2);


axis([xmin xmax ymin ymax]);hold on;
for l=1:size(structureTemp,1)
    layerTemp = structureTemp(l,1);
    gatesTemp = structureTemp(l,2);
    xPlotTemp = xPlot(l);
    yPlotTemp = linspace(ymin,ymax,gatesTemp+2);
    yPlotTemp = yPlotTemp(2:end-1);
    
    if(layerTemp==0) %input layer
        for i=1:gatesTemp
            outletPointsInpTemp = drawINPUT(xPlotTemp,yPlotTemp(i),1);
            outletPointsInp     = [outletPointsInp; repmat(layerTemp,1,1) repmat(i,1,1) outletPointsInpTemp];
            centerPointsInp     = [centerPointsInp; repmat(layerTemp,1,1) repmat(i,1,1) [xPlotTemp yPlotTemp(i)]];
        end
    else %mid layers
        for i=1:gatesTemp
            [inletPointsTemp,outletPointsTemp] = drawNAND(xPlotTemp,yPlotTemp(i),1);
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
    inletPointsOutTemp = drawOUTPUT(xPlot(end),yPlotTemp(i),1);
    inletPointsOut     = [inletPointsOut; repmat(layerTemp,1,1) repmat(i,1,1) inletPointsOutTemp];
end

inpLabelMat_x = [];
inpLabelMat_y = [];
inpLabelMat_text = [];

for i=1:numOfInputs
    inpLabelMat_x = [inpLabelMat_x; 0.95*centerPointsInp((centerPointsInp(:,2)==i),3)];
    inpLabelMat_y = [inpLabelMat_y; centerPointsInp((centerPointsInp(:,2)==i),4)];
    inpLabelMat_text = [inpLabelMat_text; ['I_' num2str(i-1)]];
end

connectionMat_x = [];
connectionMat_y = [];
connectionMat_text = [];


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
            
            connectionMat_x = [connectionMat_x; outletPointsInp((outletPointsInp(:,2)==inpConnectFrom),3) inpNANDIdx(3) ];
            connectionMat_y = [connectionMat_y; outletPointsInp((outletPointsInp(:,2)==inpConnectFrom),4) inpNANDIdx(4) ];
            connectionMat_text = [connectionMat_text; string(connectFrom) string(connectTo(j))];
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
            connectionMat_text = [connectionMat_text; string(connectFrom) string(connectTo(j))];
            
        end
    end
end

layerConnectFrom = structureTemp(end,1);
outletGatesNAND  = outletPointsNAND(outletPointsNAND(:,1)==layerConnectFrom,2);
for k=outletGatesNAND'
    connectFrom     = layerConnectFrom*1000+k*10+3;
    outNANDIdxs     = outletPointsNAND(outletPointsNAND(:,1)==layerConnectFrom & outletPointsNAND(:,2)==k,:);
    inpOutIdx       = inletPointsOut(k,:);
    connectionMat_x = [connectionMat_x; outNANDIdxs(3) inpOutIdx(3)];
    connectionMat_y = [connectionMat_y; outNANDIdxs(4) inpOutIdx(4)];
    connectionMat_text = [connectionMat_text; string(connectFrom) ['O_' num2str(k)]];
end


middleGates = sort(cell2mat(textCircuitsTemp((numOfInputs+1:end),2)))';

for k=1:size(connectionMat_x,1)
    %     line(connectionMat_x(k,:),connectionMat_y(k,:),'Color',cmap(k,:))
    line(connectionMat_x(k,:),connectionMat_y(k,:),'Color','k')
    if(textOnAll==1)
        %         text(connectionMat_x(k,1),connectionMat_y(k,1),connectionMat_text(k,1),'FontWeight','bold','Fontsize',12)
        %         text(connectionMat_x(k,2),connectionMat_y(k,2),connectionMat_text(k,2),'FontWeight','bold','Fontsize',12)
        text(connectionMat_x(k,1),connectionMat_y(k,1),connectionMat_text(k,1),'Fontsize',11)
        text(connectionMat_x(k,2),connectionMat_y(k,2),connectionMat_text(k,2),'Fontsize',11)
        gateTemp = str2double(connectionMat_text(k,1));
        if(ismember(gateTemp,middleGates))
            IsubTemp = IsubOneVals((gateTemp==middleGates));
            portion  = round(100*(IsubTemp/IallFinalVals),2);
            text(connectionMat_x(k,1),0.5+connectionMat_y(k,1),[num2str(portion) '%'],'Color',[255, 114, 111]./255,'FontWeight','bold','Fontsize',13)
        end
        
        numOfInputs = structureTemp(1,2);
        for k=1:size(inpLabelMat_x,1)
            text(inpLabelMat_x(k),inpLabelMat_y(k),inpLabelMat_text(k,:),'Fontsize',11)
            text(inpLabelMat_x(k),inpLabelMat_y(k),inpLabelMat_text(k,:),'Fontsize',11)
        end
        
    elseif(textOnMI==1)
        gateTemp = str2double(connectionMat_text(k,1));
        if(ismember(gateTemp,middleGates))
            IsubTemp = IsubOneVals((gateTemp==middleGates));
            portion  = round(100*(IsubTemp/IallFinalVals),2);
            text(connectionMat_x(k,1),0.5+connectionMat_y(k,1),[num2str(portion) '%'],'Color',[255, 114, 111]./255,'FontWeight','bold','Fontsize',13)
        end
    end
end
axis tight
th=title(['$R_{Z}(X) : $ ', num2str(redunval,3) ,'$, D_{Z}(X) : $ ' num2str(degenval,3),'$, C_{Z}(X) : $ ' num2str(compval,3)  ,'$, I(X,O) : $ ' , num2str(IallFinalVals,3)],'Fontsize',16,'interpreter','latex');
% th=title(['$D_{Z}(X) : $ ', num2str(degenval,3) ,'$, R_{Z}(X) : $ ' num2str(redunval,3),'$, C_{Z}(X) : $ ' num2str(compval,3)  ,'$, I(X,O) : $ ' , num2str(IallFinalVals,3)],'Fontsize',16,'interpreter','latex');
titlePos = get( th , 'position');
% change the x value  to 0
titlePos(2) = titlePos(2)+0.25;
% update the position
set( th , 'position' , titlePos);
% title(['D : ', num2str(degenval) ,' R :  ' num2str(redunval)],'Fontsize',14)

end

