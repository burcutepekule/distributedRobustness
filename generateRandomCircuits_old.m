function [keepCircuits,keepStructure,keepNumOfLayers,textCircuits,strAllText] = generateRandomCircuits(varargin)
disp('Circuits are being generated...');
warning('off')
if(length(varargin)==5)
    numOfInputs    = varargin{1};
    numOfOutputs   = varargin{2};
    numOfGates     = varargin{3};
    numOfSolutions = varargin{4};
    numOfCandidateSolutions = varargin{5};
    runSims        = 1;
elseif(length(varargin)==6)
    numOfInputs    = varargin{1};
    numOfOutputs   = varargin{2};
    numOfGates     = varargin{3};
    numOfSolutions = varargin{4};
    numOfLayers    = varargin{5};
    numOfCandidateSolutions = varargin{6};
    runSims        = 2;
elseif(length(varargin)==7)
    numOfInputs    = varargin{1};
    numOfOutputs   = varargin{2};
    numOfGates     = varargin{3};
    numOfSolutions = varargin{4};
    numOfLayers    = varargin{5};
    numOfGatesPerLayer = varargin{6};
    numOfCandidateSolutions = varargin{7};
    runSims        = 3;
else
    disp('Number of inputs doesnt make sense!')
    runSims        = 0;
end

if(runSims~=0)
    %     numOfGatesBetween  = numOfGates-numOfOutputs;
    numOfGatesBetween  = numOfGates;
    keepCircuits       = {};
    keepStructure      = {};
    circuitIdx         = 1;
    for tempCircuit=1:numOfSolutions
        
        % Randomly sample number of layers and gates per layer
        if(runSims==1)
            noNegative=0;
            while(noNegative==0)
                numOfLayers        = randi([1 numOfGatesBetween],1);
                %                 [tempCircuit numOfLayers]
                numOfGatesPerLayer = [];
                numOfGatesUsed     = 0;
                if(numOfLayers==1)
                    numOfGatesPerLayer = [1 numOfGatesBetween];
                else
                    
                    for layerIdx=numOfLayers:-1:2
                        % last layer before the output layer has to have ***AT MOST***
                        % 2*numOfOutputs gates so that all output of the last layer can be
                        % connected to the output layer
                        if(layerIdx==numOfLayers)
                            numOfGates         = randi([0 2*numOfOutputs],1);
                            numOfGatesPerLayer = [numOfGatesPerLayer;layerIdx numOfGates];
                            numOfGatesUsed     = numOfGatesUsed+numOfGates;
                        else
                            numOfGates         = randi([0 max(0,numOfGatesBetween-numOfGatesUsed)],1);
                            numOfGatesPerLayer = [numOfGatesPerLayer;layerIdx numOfGates];
                            numOfGatesUsed     = numOfGatesUsed+numOfGates;
                        end
                    end
                    numOfGatesPerLayer = sort(numOfGatesPerLayer,1);
                    numOfGatesPerLayer = [1 numOfGatesBetween-numOfGatesUsed;numOfGatesPerLayer];
                    % HERE
                    if(any(sign(numOfGatesPerLayer(:,2))<0))
                        noNegative=0;
                    else
                        noNegative=1;
                    end
                end
            end
            numOfGatesPerLayer(numOfGatesPerLayer(:,2)==0,:)=[]; % delete empty layers, recalculate num of layers
            numOfLayers            = size(numOfGatesPerLayer,1)+1;
            numOfGatesPerLayer(:,1)=1:size(numOfGatesPerLayer,1); % reset the layer indexes
            % add an additional row for the input layer
            numOfGatesPerLayer = [0,numOfInputs;numOfGatesPerLayer];
            numOfGatesPerLayer = [numOfGatesPerLayer;numOfLayers,numOfOutputs];
            
        elseif(runSims==2)
            
            noNegative=0;
            while(noNegative==0)
                %             numOfLayers  = randi([1 numOfGatesBetween],1);
                [tempCircuit numOfLayers]
                numOfGatesPerLayer = [];
                numOfGatesUsed     = 0;
                if(numOfLayers==1)
                    numOfGatesPerLayer = [1 numOfGatesBetween];
                else
                    
                    for layerIdx=numOfLayers:-1:2
                        % last layer before the output layer has to have ***AT MOST***
                        % 2*numOfOutputs gates so that all output of the last layer can be
                        % connected to the output layer
                        if(layerIdx==numOfLayers)
                            numOfGates         = randi([0 2*numOfOutputs],1);
                            numOfGatesPerLayer = [numOfGatesPerLayer;layerIdx numOfGates];
                            numOfGatesUsed     = numOfGatesUsed+numOfGates;
                        else
                            numOfGates         = randi([0 max(0,numOfGatesBetween-numOfGatesUsed)],1);
                            numOfGatesPerLayer = [numOfGatesPerLayer;layerIdx numOfGates];
                            numOfGatesUsed     = numOfGatesUsed+numOfGates;
                        end
                    end
                    numOfGatesPerLayer = sort(numOfGatesPerLayer,1);
                    numOfGatesPerLayer = [1 numOfGatesBetween-numOfGatesUsed;numOfGatesPerLayer];
                    if(any(sign(numOfGatesPerLayer(:,2))<0))
                        noNegative=0;
                    else
                        noNegative=1;
                    end
                end
            end
            numOfGatesPerLayer(numOfGatesPerLayer(:,2)==0,:)=[]; % delete empty layers, recalculate num of layers
            numOfLayers            = size(numOfGatesPerLayer,1)+1;
            numOfGatesPerLayer(:,1)=1:size(numOfGatesPerLayer,1); % reset the layer indexes
            % add an additional row for the input layer
            numOfGatesPerLayer = [0,numOfInputs;numOfGatesPerLayer];
            numOfGatesPerLayer = [numOfGatesPerLayer;numOfLayers,numOfOutputs];
            
            
        elseif(runSims==3)
            % Jumps to  maskMat
        end
        
        
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
        
        %%%%%%%%%% FIRST, MAKE SURE THAT LAST LAYER IS COVERED SINCE IT HAS
        %%%%%%%%%% ONLY THE OUTPUT LAYER TO BE CONNECTED TO, WHICH HAS
        %%%%%%%%%% FIXED NUMBER OF INPUT NODES = 2*NUM OF OUTPUTS
        keepConnections    = cell(size(maskMat));
        alreadyConnected   = [];
        
        layerCounter = size(numOfGatesPerLayer,1)-1;
        numOfNodes   = numOfGatesPerLayer(layerCounter,2);
        gates2connect= numOfGatesPerLayer(layerCounter+1:end,:);
        for nodeCounter = 1:numOfNodes
            keepconnected2 = [];
            for layerConnectIdx = 1:size(gates2connect,1)
                % connect to 1, 2, or both input nodes
                % encode as layerIndex*100 + gate index * 10 + node index
                layerConnect     = gates2connect(layerConnectIdx,1);
                % in the first layer, all needs to be connected to input
                possibleGates = gates2connect(layerConnectIdx,2);
                inpNodes      = setdiff(reshape(repmat(1000*layerConnect+10*(1:possibleGates)',1,2)+repmat((1:2),possibleGates,1),1,[]),alreadyConnected);
                if(~isempty(inpNodes))
                    connected2= datasample(inpNodes,1,'Replace',false);
                else
                    connected2=[];
                end
                alreadyConnected = [alreadyConnected,connected2];
                keepconnected2   = [keepconnected2,connected2];
            end
            keepConnections{layerCounter,nodeCounter} = keepconnected2;
        end
        
        % THEN FILL THE REST
        while(~isempty(setdiff(all2Connect,alreadyConnected)))
            for layerCounter=(size(numOfGatesPerLayer,1)-2):-1:1
                inpLayer      = numOfGatesPerLayer(layerCounter,1);
                numOfNodes    = numOfGatesPerLayer(layerCounter,2);
                gates2connect = numOfGatesPerLayer(layerCounter+1:end,:);
                for nodeCounter = 1:numOfNodes
                    keepconnected2 = [];
                    inpNodes       = [];
                    for layerConnectIdx = 1:size(gates2connect,1)
                        % encode input nodes as layerIndex*100 + gate index * 10 + node index
                        layerConnect     = gates2connect(layerConnectIdx,1);
                        possibleGates    = gates2connect(layerConnectIdx,2);
                        inpNodes = [inpNodes setdiff(reshape(repmat(1000*layerConnect+10*(1:possibleGates)',1,2)+repmat((1:2),possibleGates,1),1,[]),alreadyConnected)];
                    end
                    if(~isempty(inpNodes))
                        %                     numOfConnectionsUpperBound = length(inpNodes)-(numOfNodes-nodeCounter);
                        %                     if(numOfConnectionsUpperBound==0)
                        %                         1
                        %                     end
                        %                     numOfConnections2establish = randi(numOfConnectionsUpperBound);
                        %                     connected2 = datasample(inpNodes,numOfConnections2establish,'Replace',false);
                        connected2 = datasample(inpNodes,1,'Replace',false);
                    else
                        connected2=[];
                    end
                    alreadyConnected  = [alreadyConnected,connected2];
                    keepconnected2    = [keepconnected2,connected2];
                    connected2Already = keepConnections{layerCounter,nodeCounter};
                    keepConnections{layerCounter,nodeCounter} = [connected2Already keepconnected2];
                end
            end
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FIRST VERSION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %         layerCounter = size(numOfGatesPerLayer,1)-1;
        %         inpLayer     = numOfGatesPerLayer(layerCounter,1);
        %         numOfNodes   = numOfGatesPerLayer(layerCounter,2);
        %         gates2connect= numOfGatesPerLayer(layerCounter+1:end,:);
        %         for nodeCounter = 1:numOfNodes
        %             keepconnected2 = [];
        %             for layerConnectIdx = 1:size(gates2connect,1)
        %                 % connect to 1, 2, or both input nodes
        %                 % encode as layerIndex*100 + gate index * 10 + node index
        %                 layerConnect     = gates2connect(layerConnectIdx,1);
        %                 % in the first layer, all needs to be connected to input
        %                 possibleGates    = gates2connect(layerConnectIdx,2);
        %                 inpNodes = setdiff(reshape(repmat(1000*layerConnect+10*(1:possibleGates)',1,2)+repmat((1:2),possibleGates,1),1,[]),alreadyConnected);
        %                 if(~isempty(inpNodes))
        % %                     connected2= datasample(inpNodes,randi(max(1,round(length(inpNodes))),1),'Replace',false);
        %                     connected2= datasample(inpNodes,1,'Replace',false);
        %                 else
        %                     connected2=[];
        %                 end
        %                 alreadyConnected = [alreadyConnected,connected2];
        %                 keepconnected2   = [keepconnected2,connected2];
        %             end
        %             keepConnections{layerCounter,nodeCounter} = keepconnected2;
        %         end
        %
        %         % then connect all the other layers
        %         for layerCounter=1:size(numOfGatesPerLayer,1)-2
        %             inpLayer      = numOfGatesPerLayer(layerCounter,1);
        %             numOfNodes    = numOfGatesPerLayer(layerCounter,2);
        %             gates2connect = numOfGatesPerLayer(layerCounter+1:end,:);
        %             for nodeCounter = 1:numOfNodes
        %                 keepconnected2 = [];
        %                 for layerConnectIdx = 1:size(gates2connect,1)
        %                     % connect to 1, 2, or both input nodes
        %                     % encode as layerIndex*100 + gate index * 10 + node index
        %                     layerConnect     = gates2connect(layerConnectIdx,1);
        %                     possibleGates    = gates2connect(layerConnectIdx,2);
        %                     inpNodes = setdiff(reshape(repmat(1000*layerConnect+10*(1:possibleGates)',1,2)+repmat((1:2),possibleGates,1),1,[]),alreadyConnected);
        %                     if(~isempty(inpNodes))
        %                         %%%%%%%% IF YOU DO NOT LIMIT THE NUMBER OF RANDOMLY
        %                         %%%%%%%% CONNECTED NODES, THIS PART CAUSES EARLY
        %                         %%%%%%%% NODES TO CONNECT TO TOO MANY NODES BECAUSE
        %                         %%%%%%%% OF THE NUMBER OF LAYERS AHEAD OF
        %                         %%%%%%%% THEM.THAT'S WHY INITIALLY IT WAS THE FIRST
        %                         %%%%%%%% LINE BEFORE, THEN I DECIDED TO PUT AN IF
        %                         %%%%%%%% CONDITION DEPENDING ON THE NUMBER OF
        %                         %%%%%%%% POSSIBLE CONNECTIONS (MAX floor(numOfGatesBetween/2)).
        %                         %                         connected2= datasample(inpNodes,randi(length(inpNodes)+1)-1,'Replace',false);
        %                         numOfConnections2establish = randi(length(inpNodes)+1)-1;
        %                         if(numOfConnections2establish>floor(length(inpNodes)/4))
        %                             numOfConnections2establish=randi(floor(length(inpNodes)/4)+1)-1;
        %                         end
        %                         connected2 = datasample(inpNodes,numOfConnections2establish,'Replace',false);
        %                     else
        %                         connected2=[];
        %                     end
        %                     alreadyConnected = [alreadyConnected,connected2];
        %                     keepconnected2   = [keepconnected2,connected2];
        %                 end
        %                 keepConnections{layerCounter,nodeCounter} = keepconnected2;
        %             end
        %         end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FIRST VERSION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % check the open input nodes
        keepNodesUsed   = [];
        for(r=1:size(keepConnections,1))
            for(c=1:size(keepConnections,2))
                if(maskMat(r,c)==1)
                    keepNodesUsed = [keepNodesUsed,keepConnections{r,c}];
                end
            end
        end
        InpNodesNotUsed = setdiff(all2Connect,keepNodesUsed);
        for inIdx=1:length(InpNodesNotUsed)
            inpNode           = InpNodesNotUsed(inIdx);
            inpLayer          = floor(inpNode/1000);
            layersPrior       = 0:(inpLayer-1);
            % inverse weight them according to how many connections they have
            numOfOldConnections = [];
            for lp=1:layersPrior
                for lpr=1:size(keepConnections,2)
                    numOfOldConnections(lp) = numOfOldConnections(lp)+length(keepConnections{lp+1,lpr});
                end
            end
            propOfConnection  = 1./(numOfOldConnections+1); %+1 to prevent 1/0
            propOfConnection  = propOfConnection./sum(propOfConnection);
            layersPriorPick   = datasample(layersPrior,1,'Weights',propOfConnection);% pick a prior layer randomly
            nodesPrior        = numOfGatesPerLayer((numOfGatesPerLayer(:,1)==layersPriorPick),2);
            % inverse weight them according to how many connections they have
            numOfOldConnections = [];
            for np=1:nodesPrior
                numOfOldConnections(np) = length(keepConnections{layersPriorPick+1,np});
            end
            propOfConnection  = 1./(numOfOldConnections+1); %+1 to prevent 1/0
            propOfConnection  = propOfConnection./sum(propOfConnection);
            nodesPriorPick    = datasample(1:nodesPrior,1,'Weights',propOfConnection);% pick a prior gate randomly
            allConnectionsOldPick = keepConnections{layersPriorPick+1,nodesPriorPick};
            allConnectionsNewPick = [allConnectionsOldPick,inpNode];
            keepConnections{layersPriorPick+1,nodesPriorPick} = sort(allConnectionsNewPick);
        end
        
        OutputNodesNotUsed = [];
        for(r=1:size(keepConnections,1))
            for(c=1:size(keepConnections,2))
                if(maskMat(r,c)==1)
                    keepNodesUsed = [keepNodesUsed,keepConnections{r,c}];
                    if(isempty(keepConnections{r,c}))
                        OutputNodesNotUsed = [OutputNodesNotUsed;r-1,c];
                    end
                end
            end
        end
        
        % check whether valid circuit
        % condition 1 : are all output nodes of mid layers connected ?
        % condition 2 : are all input nodes used?
        keepNodesUsed   = [];
        allOutConnected = 1;
        allNodesUsed    = 1;
        for(r=1:size(keepConnections,1))
            for(c=1:size(keepConnections,2))
                if(maskMat(r,c)==1)
                    keepNodesUsed = [keepNodesUsed,keepConnections{r,c}];
                    if(isempty(keepConnections{r,c}))
                        allOutConnected = 0;
                    end
                end
            end
        end
        
        if(~isempty(setdiff(all2Connect,keepNodesUsed)))
            allNodesUsed = 0;
        end
        if(allOutConnected==1 && allNodesUsed==1)
            keepCircuits{circuitIdx}    = keepConnections;
            keepStructure{circuitIdx}   = numOfGatesPerLayer;
            keepNumOfLayers(circuitIdx) = size(numOfGatesPerLayer,1)-1;
            circuitIdx = circuitIdx + 1;
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

