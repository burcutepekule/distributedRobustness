function [keepCircuits,keepStructure,keepNumOfLayers,textCircuits,strAllText] = generateRandomCircuits(varargin)
disp('Circuits are being generated...');
warning('off')
if(length(varargin)==4)
    numOfInputs    = varargin{1};
    numOfOutputs   = varargin{2};
    numOfGates     = varargin{3};
    numOfCandidateSolutions = varargin{4};
    runSims        = 1;
else
    disp('Number of inputs doesnt make sense!')
    runSims        = 0;
end

counter = 1;
if(runSims~=0)
    %     numOfGatesBetween  = numOfGates-numOfOutputs;
    numOfGatesBetween  = numOfGates;
    keepCircuits       = {};
    keepStructure      = {};
    circuitIdx         = 1;
    strAll             = [ ];
    %     for tempCircuit=1:numOfSolutions
    while(circuitIdx<numOfCandidateSolutions+1)
        % Randomly sample number of layers and gates per layer
        [numOfGatesPerLayer,numOfLayers] = generateRandomStructure(numOfGatesBetween,numOfInputs,numOfOutputs);
        % BUILDING THE CIRCUIT
        % at each layer, there are n gates and 2*n input nodes in total
        maskMat            = zeros(numOfLayers, max(numOfGatesPerLayer(:,2)));
        for(r=1:size(maskMat,1))
            for(c=1:size(maskMat,2))
                maskMat(r,1:numOfGatesPerLayer(r,2))=1;
            end
        end
        % input node code : layerIdx, gateIdx (input nodes layer idx 0)
        all2Connect        = [];
        for layerCounter=1:size(numOfGatesPerLayer,1)
            inpLayer      = numOfGatesPerLayer(layerCounter,1);
            numOfNodes    = numOfGatesPerLayer(layerCounter,2);
            % gates2connect = numOfGatesPerLayer(layerCounter+1:end,:);
            % spare the output nodes for now
            gates2connect = numOfGatesPerLayer(layerCounter+1:end,:);
            for layerConnectIdx = 1:size(gates2connect,1)
                % connect to 1, 2, or both input nodes
                % encode as layerIndex*100 + gate index * 10 + node index
                layerConnect     = gates2connect(layerConnectIdx,1);
                possibleGates    = gates2connect(layerConnectIdx,2);
                inpNodes         = reshape(repmat(1000*layerConnect+10*(1:possibleGates)',1,2)+repmat((1:2),possibleGates,1),1,[]);
                all2Connect      = [all2Connect,inpNodes];
            end
        end
        all2Connect = unique(all2Connect);
        %%%%%%%%%% WIRE THE CIRCUIT %%%%%%%%%%
        
        %%%%%%%%%% FIRST, MAKE SURE THAT THE INPUTS OF THE LAST LAYER BEFORE
        %%%%%%%%%% THE OUTPUT LAYER IS COVERED
        
        keepConnections    = cell(size(maskMat));
        alreadyConnected   = [];
        
        layerCounter = size(numOfGatesPerLayer,1)-1;
        numOfNodes   = numOfGatesPerLayer(layerCounter,2);
        gates2connect= numOfGatesPerLayer(layerCounter+1:end,:);
        keepconnected2 = [];
        openNodes      = 1:numOfNodes;
        %%%% NEW
        % connect to 1, 2, or both input nodes
        % encode as layerIndex*100 + gate index * 10 + node index
        layerConnect     = gates2connect(1,1);
        % in the first layer, all needs to be connected to input
        possibleGates = gates2connect(1,2);
        inpNodes      = setdiff(reshape(repmat(1000*layerConnect+10*(1:possibleGates)',1,2)+repmat((1:2),possibleGates,1),1,[]),alreadyConnected);
        % first, fill everything to be sure
        num2fill = sum(maskMat(layerCounter,:));
        for connect2node=1:num2fill
            connected2       = datasample(inpNodes,1,'Replace',false);
            alreadyConnected = [alreadyConnected,connected2];
            keepconnected2   = [keepconnected2,connected2];
            oldConnections   = keepConnections{layerCounter,connect2node};
            keepConnections{layerCounter,connect2node} = [oldConnections connected2];
            inpNodes  = setdiff(inpNodes,connected2);
        end
        % if there is any left
%         while (~isempty(inpNodes))
        while (any(cellfun(@isempty,keepConnections(layerCounter,maskMat(layerCounter,:)==1))))
            connected2       = datasample(inpNodes,1,'Replace',false);
            alreadyConnected = [alreadyConnected,connected2];
            keepconnected2   = [keepconnected2,connected2];
            connect2node     = datasample(openNodes,1);
            oldConnections   = keepConnections{layerCounter,connect2node};
            keepConnections{layerCounter,connect2node} = [oldConnections connected2];
            inpNodes  = setdiff(inpNodes,connected2);
        end
        
        inpNodes = setdiff(all2Connect,alreadyConnected);
        
        for layerCounter=size(numOfGatesPerLayer,1)-2:-1:1
            num2fill = sum(maskMat(layerCounter,:));
            
            possibleInpNodes = inpNodes(inpNodes>1000*layerCounter);
            
            for colIdx=1:num2fill
                connected2       = datasample(possibleInpNodes,1,'Replace',false);
                alreadyConnected = [alreadyConnected,connected2];
                keepconnected2   = [keepconnected2,connected2];
                oldConnections   = keepConnections{layerCounter,colIdx};
                keepConnections{layerCounter,colIdx} = [oldConnections connected2];
                inpNodes         = setdiff(inpNodes,connected2);
                possibleInpNodes = setdiff(possibleInpNodes,connected2);
                if(colIdx<num2fill & isempty(possibleInpNodes))
                    0;
                end
            end
            
        end
        
        % THEN FILL THE REST TOTALLY AT RANDOM
        
        while (~isempty(inpNodes))
            % randomly choose a cell from maskmat==1
            rcPick = sampleRandomPosition(maskMat);
            rowIdx = rcPick(1,1);
            colIdx = rcPick(1,2);
            possibleInpNodes = inpNodes(inpNodes>1000*rowIdx);
            if(~isempty(possibleInpNodes))
                connected2       = datasample(possibleInpNodes,1,'Replace',false);
                alreadyConnected = [alreadyConnected,connected2];
                keepconnected2   = [keepconnected2,connected2];
                oldConnections   = keepConnections{rowIdx,colIdx};
                keepConnections{rowIdx,colIdx} = [oldConnections connected2];
                inpNodes  = setdiff(inpNodes,connected2);
                possibleInpNodes = setdiff(possibleInpNodes,connected2);
            end
        end
        
        
        % check whether valid circuit
        % condition 1 : are all output nodes of mid layers connected ?
        % condition 2 : are all input nodes used?
        % condition 3 : any backward connections?
        
        keepNodesUsed   = [];
        allOutConnected = 1;
        allNodesUsed    = 1;
        noBackwardConn  = 1;
        
        for(r=1:size(keepConnections,1))
            for(c=1:size(keepConnections,2))
                if(maskMat(r,c)==1)
                    keepNodesUsed = [keepNodesUsed,keepConnections{r,c}];
                    if(isempty(keepConnections{r,c}))
                        allOutConnected = 0;
                    end
                    
                    nodesTemp = keepConnections{r,c};
                    if(any(nodesTemp<1000*r))
                        noBackwardConn = 0;
                    end
                end
            end
        end
        
        if(~isempty(setdiff(all2Connect,keepNodesUsed)))
            allNodesUsed = 0;
        end
        
        % below should all be satisfied with the way circuits are built
        % anyway
        %         disp(sprintf('%d %d %d %d',counter,allNodesUsed,allOutConnected,noBackwardConn))
        counter=counter+1;
        if(allOutConnected==1 && allNodesUsed==1 && noBackwardConn==1)
            keepCircuits{circuitIdx}    = keepConnections;
            keepStructure{circuitIdx}   = numOfGatesPerLayer;
            keepNumOfLayers(circuitIdx) = size(numOfGatesPerLayer,1)-1;
            %add and check whether it's unique?
            strAll  =[ ];
            for cellIdx=1:size(keepCircuits,2)
                strTemp = [];
                keepCircuitsTemp = keepCircuits{1,cellIdx};
                for r=1:size(keepCircuitsTemp,1)
                    for c=1:size(keepCircuitsTemp,2)
                        strAdd  = strjoin(string(sort(keepCircuitsTemp{r,c})));
                        strTemp = strcat(strTemp,strAdd);
                    end
                end
                strAll{cellIdx,1}=strTemp;
            end
            [~,idx] = unique(cellfun(@num2str,strAll,'uni',0));
            if(circuitIdx<=length(idx)) %if the new one is unique, keep
                disp(sprintf('Found circuit number %d',circuitIdx))
                circuitIdx = circuitIdx + 1;
            else% remove
                keepCircuits{circuitIdx}    = [];
                keepStructure{circuitIdx}   = [];
                keepNumOfLayers(circuitIdx) = [];
            end
        end
    end
    %% find the unique structures
    strAll =[ ];
    for cellIdx=1:size(keepCircuits,2)
        
        strTemp = [];
        keepCircuitsTemp = keepCircuits{1,cellIdx};
        for r=1:size(keepCircuitsTemp,1)
            for c=1:size(keepCircuitsTemp,2)
                strAdd  = strjoin(string(sort(keepCircuitsTemp{r,c})));
                strTemp = strcat(strTemp,strAdd);
            end
        end
        strAll{cellIdx,1}=strTemp;
    end
    %% GET THE UNIQUE STRINGS -> UNIQUE CIRCUIT LABELS
    if(isempty(strAll))
        disp('No circuits found, try to increase numOfSolutions');
        convert = 0;
    else
        convert = 1;
        [~,idx] = unique(cellfun(@num2str,strAll,'uni',0));
        % GET THE UNIQUE CIRCUITS, SAVE ORIGINAL MATS FIRST
        keepCircuitsKeep    = keepCircuits;
        keepStructureKeep   = keepStructure;
        keepNumOfLayersKeep = keepNumOfLayers;
        keepCircuits        = keepCircuitsKeep(idx);
        keepStructure       = keepStructureKeep(idx);
        keepNumOfLayers     = keepNumOfLayersKeep(idx);
        disp('Circuits generated.');
    end
else
    disp('Getting out of this function with no output');
    keepCircuits        = [];
    keepStructure       = [];
    keepNumOfLayers     = [];
end

if(convert==1)
    % Convert circuit structure to text
    if(size(keepNumOfLayers,2)<numOfCandidateSolutions)
        disp('Not enough candidate solutions, increase numOfRuns')
        [textCircuits,strAllText] = circuit2text(keepCircuits,keepStructure);
    else
        keepIdxs        = datasample(1:length(keepCircuits),numOfCandidateSolutions,'Replace',false);
        keepCircuits    = keepCircuits(keepIdxs);
        keepStructure   = keepStructure(keepIdxs);
        keepNumOfLayers = keepNumOfLayers(keepIdxs);
        [textCircuits,strAllText] = circuit2text(keepCircuits,keepStructure);
    end
    
else
    textCircuits=[];
    strAllText =[];
    keepCircuits=[];
    keepStructure=[];
    keepNumOfLayers=[];
end

end


