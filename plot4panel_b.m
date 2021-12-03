function [] = plot4panel_b(varargin)
if(length(varargin)==10)
    textCircuits    = varargin{1};
    keepStructure   = varargin{2};
    IsubOneVals     = varargin{3};
    IallFinalVals   = varargin{4};
    degeneracyVals  = varargin{5};
    redundancyVals  = varargin{6};
    IsubSumKeepVals = varargin{7};
    ind_min   = varargin{8};
    textOnAll = varargin{9};
    textOnMI  = varargin{10};
    numPanels = 2;
elseif(length(varargin)==11)
    textCircuits    = varargin{1};
    keepStructure   = varargin{2};
    IsubOneVals     = varargin{3};
    IallFinalVals   = varargin{4};
    degeneracyVals  = varargin{5};
    redundancyVals  = varargin{6};
    IsubSumKeepVals = varargin{7};
    ind_min   = varargin{8};
    ind_max   = varargin{9};
    textOnAll = varargin{10};
    textOnMI  = varargin{11};
    numPanels = 4;
else
    disp('Number of inputs doesnt make sense!')
    numPanels = 0;
end


close all;
if(numPanels>0)
    if(numPanels==4)
        [ha, ~] = tight_subplot(2,2,[0.08 0.05],[0.05 0.05],[0.03 0.02]);
        set(gcf, 'Position',  [100, 300, 1000, 800])
        
        fittestStructure_1     = keepStructure{ind_min};
        fittestTextCircuit_1   = textCircuits(cell2mat(textCircuits(:,1))==ind_min,:);
        degenval_1 = degeneracyVals(ind_min);
        redunval_1 = redundancyVals(ind_min);
        
        axes(ha(1))
        connectionMatInitial_1 = drawCircuit_text_MI(fittestStructure_1,fittestTextCircuit_1,IsubOneVals(ind_min,:),IallFinalVals(ind_min),degenval_1,redunval_1,textOnAll,textOnMI);
        axis off;
        sum(IsubOneVals(ind_min,:)./IallFinalVals(ind_min))
        
        fittestStructure_2     = keepStructure{ind_max};
        fittestTextCircuit_2   = textCircuits(cell2mat(textCircuits(:,1))==ind_max,:);
        degenval_2 = degeneracyVals(ind_max);
        redunval_2 = redundancyVals(ind_max);
        axes(ha(2))
        connectionMatInitial_2 = drawCircuit_text_MI(fittestStructure_2,fittestTextCircuit_2,IsubOneVals(ind_max,:),IallFinalVals(ind_max),degenval_2,redunval_2,textOnAll,textOnMI);
        axis off;
        sum(IsubOneVals(ind_max,:)./IallFinalVals(ind_max))
        
        valsMatmin=IsubSumKeepVals(:,:,ind_min);
        valsMatmax=IsubSumKeepVals(:,:,ind_max);
        bottom = min([valsMatmin(:);valsMatmax(:)]);
        top    = max([valsMatmin(:);valsMatmax(:)]);
        
        axes(ha(3))
        imagesc(valsMatmin)
        caxis([bottom top]);
        colormap bone
        colorbar
        title('$I(X_{i}^{k},O) + I(\hat{X}_{i}^{k},O) - I(X,O)$','interpreter','latex','Fontsize',16)
        xlabel('$k$','interpreter','latex','Fontsize',16)
        ylabel('$i$','interpreter','latex','Fontsize',16)
        
        axes(ha(4))
        imagesc(valsMatmax)
        caxis([bottom top]);
        colormap bone
        colorbar
        title('$I(X_{i}^{k},O) + I(\hat{X}_{i}^{k},O) - I(X,O)$','interpreter','latex','Fontsize',16)
        xlabel('$k$','interpreter','latex','Fontsize',16)
        ylabel('$i$','interpreter','latex','Fontsize',16)
    elseif(numPanels==2)
        [ha, ~] = tight_subplot(2,1,[0.08 0.05],[0.05 0.05],[0.055 0.02]);
        set(gcf, 'Position',  [100, 300, 600, 800])
        
        fittestStructure_1     = keepStructure{ind_min};
        fittestTextCircuit_1   = textCircuits(cell2mat(textCircuits(:,1))==ind_min,:);
        degenval_1 = degeneracyVals(ind_min);
        redunval_1 = redundancyVals(ind_min);
        
        axes(ha(1))
        connectionMatInitial_1 = drawCircuit_text_MI(fittestStructure_1,fittestTextCircuit_1,IsubOneVals(ind_min,:),IallFinalVals(ind_min),degenval_1,redunval_1,textOnAll,textOnMI);
        axis off;
        sum(IsubOneVals(ind_min,:)./IallFinalVals(ind_min))
        
        
        valsMatmin=IsubSumKeepVals(:,:,ind_min);
        bottom = min(valsMatmin(:));
        top    = max(valsMatmin(:));
        
        axes(ha(2))
        imagesc(valsMatmin)
        caxis([bottom top]);
        colormap bone
        colorbar
        title('$I(X_{i}^{k},O) + I(\hat{X}_{i}^{k},O) - I(X,O)$','interpreter','latex','Fontsize',16)
        xlabel('$k$','interpreter','latex','Fontsize',16)
        ylabel('$i$','interpreter','latex','Fontsize',16)
        
    end
    set(gcf,'InvertHardCopy','off','Color','white');
end

end

