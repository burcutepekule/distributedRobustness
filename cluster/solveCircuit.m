function [keepAllOutput,keepOutput] = solveCircuit(varargin)
if(length(varargin)==3)
    numOfInputs    = varargin{1};
    textCircuits   = varargin{2};
    keepStructure  = varargin{3};
    if(iscell(keepStructure))
            tempCircuitIdxVec = 1:length(keepStructure);
    else
            tempCircuitIdxVec = 1:1;
    end
elseif(length(varargin)==4)
    numOfInputs    = varargin{1};
    textCircuits   = varargin{2};
    keepStructure  = varargin{3};
    tempCircuitIdx = varargin{4};
    tempCircuitIdxVec = tempCircuitIdx;
end

inpMat=[];
for i=0:(2^numOfInputs-1)
    inpMat = [inpMat;str2logicArray(dec2bin(i,numOfInputs))];
end
%%
keepOutput       = [];
keepAllOutput    = [];
counter          = 1;
%%

for tempCircuitIdx=tempCircuitIdxVec
% for tempCircuitIdx=7
    disp(['Solving for circuit : ' num2str(tempCircuitIdx)])
    
    for inpIdx=1:size(inpMat,1)
        %         inpIdx
        
        for i=1:numOfInputs
            inpGateNameTemp = ['i_' num2str(i) '3'];
            inpValTemp      = inpMat(inpIdx,i);
            assignin('base',string(sym(inpGateNameTemp)),inpValTemp)
            keepAllOutput{counter,1} = tempCircuitIdx;
            keepAllOutput{counter,2} = inpIdx;
            keepAllOutput{counter,3} = inpGateNameTemp;
            keepAllOutput{counter,4} = inpValTemp;
            counter=counter+1;
            
        end
        
        indStart         = find(cell2mat(textCircuits(:,1))==tempCircuitIdx, 1 );
        indEnd           = find(cell2mat(textCircuits(:,1))==tempCircuitIdx, 1, 'last' );
        tempCircuit      = textCircuits(indStart:indEnd,2:3);
        if(iscell(keepStructure))
            tempStructure = keepStructure{tempCircuitIdx};
        else
            tempStructure = keepStructure;
        end
        
        eqnKeep          = [];
        outSymKeep       = [];
        for r=2:size(tempStructure,1)
            layerTemp        = tempStructure(r,1);
            possibleGates    = tempStructure(r,2);
            for gateTemp=1:possibleGates
                inpNodes = unique(reshape(repmat(1000*layerTemp+10*(gateTemp)',1,2)+repmat((1:2),gateTemp,1),1,[]));
                outNode  = unique(reshape(repmat(1000*layerTemp+10*(gateTemp)',1,1)+repmat(3,gateTemp,1),1,[]));
                inpKeep = [];
                for p=1:length(inpNodes)
                    [rc,~]=findInCell(tempCircuit,inpNodes(p));
                    inpKeep = [inpKeep,cell2mat(tempCircuit(rc,1))];
                end
                inpSym_1   = sym(strcat('i_',sprintf('%d',inpKeep(1))));
                inpSym_2   = sym(strcat('i_',sprintf('%d',inpKeep(2))));
                outSym     = sym(strcat('i_',sprintf('%d',outNode(1))));
                eqnTemp    = outSym == ~(inpSym_1 & inpSym_2);
                eqnKeep    = [eqnKeep; eqnTemp];
                outSymKeep = [outSymKeep; outSym];
            end
        end
        %SOLVE THE CIRCUIT
        eqnTemp       = eqnKeep(1);
        eqnStr_output = extractBefore(char(eqnTemp)," ==");
        allSyms = symvar(eqnTemp);
        outSyms = sym(eqnStr_output);
        inpSyms = setdiff(allSyms,outSyms);
        
        assignin('base',string(outSyms),false)
        if(eval(subs(eqnTemp)))
            assignin('base',string(outSyms),false)
            keepAllOutput{counter,1} = tempCircuitIdx;
            keepAllOutput{counter,2} = inpIdx;
            keepAllOutput{counter,3} = string(outSyms);
            keepAllOutput{counter,4} = false;
            counter=counter+1;
        else
            assignin('base',string(outSyms),true)
            keepAllOutput{counter,1} = tempCircuitIdx;
            keepAllOutput{counter,2} = inpIdx;
            keepAllOutput{counter,3} = string(outSyms);
            keepAllOutput{counter,4} = true;
            counter=counter+1;
        end
        
        for eq=2:size(eqnKeep,1)
%             eq
            eqnTemp       = eqnKeep(eq);
            eqnStr_output = extractBefore(char(eqnTemp)," ==");
            allSyms = symvar(eqnTemp);
            outSyms = sym(eqnStr_output);
            inpSyms = setdiff(allSyms,outSyms);
            
            assignin('base',string(outSyms),false)
            if(eval(subs(eqnTemp)))
                assignin('base',string(outSyms),false)
                keepAllOutput{counter,1} = tempCircuitIdx;
                keepAllOutput{counter,2} = inpIdx;
                keepAllOutput{counter,3} = string(outSyms);
                keepAllOutput{counter,4} = false;
                counter=counter+1;
            else
                assignin('base',string(outSyms),true)
                keepAllOutput{counter,1} = tempCircuitIdx;
                keepAllOutput{counter,2} = inpIdx;
                keepAllOutput{counter,3} = string(outSyms);
                keepAllOutput{counter,4} = true;
                counter=counter+1;
            end
        end
        finalOutputGates    = unique(reshape(repmat(1000*tempStructure(end,1)+10*(1:tempStructure(end,2))',1,1)+repmat(3,gateTemp,1),1,[]));
        
        for o=1:length(finalOutputGates)
            keepOutput(inpIdx,o,tempCircuitIdx)=evalin('caller',strcat('i_',sprintf('%d',finalOutputGates(o))));
        end
        
        % for the global environment, one can use eval from syms
        %     finalOutputGatesSym = [];
        %     for o=1:tempStructure(end,2)
        %         finalOutputGatesSym = [finalOutputGatesSym,sym(strcat('i_',sprintf('%d',finalOutputGates(o))))];
        %     end
        %
        %     keepOutput(inpIdx,:)=eval(finalOutputGatesSym);
        
    end
end
disp(['Solved for all circuits.'])
end

