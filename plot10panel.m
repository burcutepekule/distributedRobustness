function [] = plot10panel_a(varargin)
if(length(varargin)==11)
    textCircuits    = varargin{1};
    keepStructure   = varargin{2};
    IsubOneVals     = varargin{3};
    IallFinalVals   = varargin{4};
    degeneracyVals  = varargin{5};
    redundancyVals  = varargin{6};
    IfinalVals      = varargin{7};
    IsubMatKeepVals = varargin{8};
    ind_min   = varargin{9};
    textOnAll = varargin{10};
    textOnMI  = varargin{11};
    numPanels = 5;
elseif(length(varargin)==12)
    textCircuits    = varargin{1};
    keepStructure   = varargin{2};
    IsubOneVals     = varargin{3};
    IallFinalVals   = varargin{4};
    degeneracyVals  = varargin{5};
    redundancyVals  = varargin{6};
    IfinalVals      = varargin{7};
    IsubMatKeepVals = varargin{8};
    ind_min   = varargin{9};
    ind_max   = varargin{10};
    textOnAll = varargin{11};
    textOnMI  = varargin{12};
    numPanels = 10;
else
    disp('Number of inputs doesnt make sense!')
    numPanels = 0;
end

cmap = [1 0.8 0.8 ;bone(100)];


close all;
if(numPanels>0)
    if(numPanels==10)
        [ha, ~] = tight_subplot(5,2,[0.08 0.05],[0.05 0.05],[0.055 0.02]);
        set(gcf, 'Position',  [100, 300, 1000, 1600])
        
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
        
        valsMatmin_1=IsubMatKeepVals(:,:,ind_min);
        valsMatmax_1=IsubMatKeepVals(:,:,ind_max);
        valsMatmin_2=IfinalVals(:,:,ind_min);
        valsMatmax_2=IfinalVals(:,:,ind_max);
        bottom = -0.2;
%         top    = max([valsMatmin_1(:);valsMatmax_1(:);valsMatmin_2(:);valsMatmax_2(:)]);
        top    = 1.4; % ALSO TO HAVE CONSISTENCY ACROSS FIGURES

        
        axes(ha(3))
        imagesc(valsMatmin_1')
        caxis([bottom top]);
        colormap(cmap)
        cb=colorbar;
        cb.TickLabels{1}='NA';
        title('$I(X_{i}^{k},O)$','interpreter','latex','Fontsize',16)
        ylabel('$k$','interpreter','latex','Fontsize',16)
%         xlabel('$i$','interpreter','latex','Fontsize',16)
        
        axes(ha(4))
        imagesc(valsMatmax_1')
        caxis([bottom top]);
        colormap(cmap)
        cb=colorbar;
        cb.TickLabels{1}='NA';
        title('$I(X_{i}^{k},O)$','interpreter','latex','Fontsize',16)
        ylabel('$k$','interpreter','latex','Fontsize',16)
%         xlabel('$i$','interpreter','latex','Fontsize',16)
        
        axes(ha(5))
        imagesc(nansum(valsMatmin_1,2)')
        caxis([bottom top]);
        colormap(cmap)
        cb=colorbar;
        cb.TickLabels{1}='NA';
        title('$\sum_{k} I(X_{i}^{k},O)$','interpreter','latex','Fontsize',16)
%         ylabel('$k$','interpreter','latex','Fontsize',16)
        xlabel('$i$','interpreter','latex','Fontsize',16)
        
        
        axes(ha(6))
        imagesc(nansum(valsMatmax_1,2)')
        caxis([bottom top]);
        colormap(cmap)
        cb=colorbar;
        cb.TickLabels{1}='NA';
        title('$\sum_{k} I(X_{i}^{k},O)$','interpreter','latex','Fontsize',16)
%         ylabel('$k$','interpreter','latex','Fontsize',16)
        xlabel('$i$','interpreter','latex','Fontsize',16)
      
        axes(ha(7))
        imagesc(valsMatmin_2')
        caxis([bottom top]);
        colormap(cmap)
        cb=colorbar;
        cb.TickLabels{1}='NA';
        title('$I(X_{i}^{k},O) + I(\hat{X}_{i}^{k},O) - I(X,O)$','interpreter','latex','Fontsize',16)
        ylabel('$k$','interpreter','latex','Fontsize',16)
%         xlabel('$i$','interpreter','latex','Fontsize',16)
        
        axes(ha(8))
        imagesc(valsMatmax_2')
        caxis([bottom top]);
        colormap(cmap)
        cb=colorbar;
        cb.TickLabels{1}='NA';
        title('$I(X_{i}^{k},O) + I(\hat{X}_{i}^{k},O) - I(X,O)$','interpreter','latex','Fontsize',16)
        ylabel('$k$','interpreter','latex','Fontsize',16)
%         xlabel('$i$','interpreter','latex','Fontsize',16)
        
        axes(ha(9))
        imagesc(nanmean(valsMatmin_2,2)')
        caxis([bottom top]);
        colormap(cmap)
        cb=colorbar;
        cb.TickLabels{1}='NA';
        title('$<I(X_{i}^{k},O) + I(\hat{X}_{i}^{k},O) - I(X,O)>$','interpreter','latex','Fontsize',16)
%         ylabel('$k$','interpreter','latex','Fontsize',16)
        xlabel('$i$','interpreter','latex','Fontsize',16)
        
        
        axes(ha(10))
        imagesc(nanmean(valsMatmax_2,2)')
        caxis([bottom top]);
        colormap(cmap)
        cb=colorbar;
        cb.TickLabels{1}='NA';
        title('$<I(X_{i}^{k},O) + I(\hat{X}_{i}^{k},O) - I(X,O)>$','interpreter','latex','Fontsize',16)
%         ylabel('$k$','interpreter','latex','Fontsize',16)
        xlabel('$i$','interpreter','latex','Fontsize',16)
        
        shrink2height = 0.025;
        initialHeight = ha(7).Position(4);
        ha(5).Position(4)=shrink2height;
        ha(6).Position(4)=shrink2height;
        ha(9).Position(4)=shrink2height;
        ha(10).Position(4)=shrink2height;
        leftoverHeight= 2*(initialHeight-shrink2height);

        ha(1).Position(4)=ha(1).Position(4)+leftoverHeight/1.8;
        ha(2).Position(4)=ha(2).Position(4)+leftoverHeight/1.8;
        ha(3).Position(4)=ha(3).Position(4)+leftoverHeight/3;
        ha(4).Position(4)=ha(4).Position(4)+leftoverHeight/3;
        ha(7).Position(4)=ha(7).Position(4)+leftoverHeight/3;
        ha(8).Position(4)=ha(8).Position(4)+leftoverHeight/3;
        
        ha(1).Position(2)=ha(1).Position(2)-1.75*leftoverHeight/3;
        ha(2).Position(2)=ha(2).Position(2)-1.75*leftoverHeight/3;
        ha(3).Position(2)=ha(3).Position(2)-2.2*leftoverHeight/3;
        ha(4).Position(2)=ha(4).Position(2)-2.2*leftoverHeight/3;
        ha(5).Position(2)=ha(5).Position(2)-0.5*leftoverHeight/3;
        ha(6).Position(2)=ha(6).Position(2)-0.5*leftoverHeight/3;
        ha(7).Position(2)=ha(7).Position(2)-1.75*leftoverHeight/3;
        ha(8).Position(2)=ha(8).Position(2)-1.75*leftoverHeight/3;

        
    elseif(numPanels==5)
        [ha, ~] = tight_subplot(5,1,[0.08 0.05],[0.05 0.05],[0.065 0.02]);
        set(gcf, 'Position',  [100, 300, 600, 1600])
        
        fittestStructure_1     = keepStructure{ind_min};
        fittestTextCircuit_1   = textCircuits(cell2mat(textCircuits(:,1))==ind_min,:);
        degenval_1 = degeneracyVals(ind_min);
        redunval_1 = redundancyVals(ind_min);
        
        axes(ha(1))
        connectionMatInitial_1 = drawCircuit_text_MI(fittestStructure_1,fittestTextCircuit_1,IsubOneVals(ind_min,:),IallFinalVals(ind_min),degenval_1,redunval_1,textOnAll,textOnMI);
        axis off;
        sum(IsubOneVals(ind_min,:)./IallFinalVals(ind_min))
        
        
        valsMatmin_1=IsubMatKeepVals(:,:,ind_min);
        valsMatmin_2=IfinalVals(:,:,ind_min);
        bottom = -0.2;
%         top    = max([valsMatmin_1(:);valsMatmin_2(:)]);
        top    = 1.4; % ALSO TO HAVE CONSISTENCY ACROSS FIGURES
        
        axes(ha(2))
        imagesc(valsMatmin_1')
        caxis([bottom top]);
        colormap(cmap)
        cb=colorbar;
        cb.TickLabels{1}='NA';
        title('$I(X_{i}^{k},O)$','interpreter','latex','Fontsize',16)
        ylabel('$k$','interpreter','latex','Fontsize',16)
%         xlabel('$i$','interpreter','latex','Fontsize',16)
        
        axes(ha(3))
        imagesc(nansum(valsMatmin_1,2)')
        caxis([bottom top]);
        colormap(cmap)
        cb=colorbar;
        cb.TickLabels{1}='NA';
        title('$\sum_{k} I(X_{i}^{k},O)$','interpreter','latex','Fontsize',16)
%         ylabel('$k$','interpreter','latex','Fontsize',16)
        xlabel('$i$','interpreter','latex','Fontsize',16)
        
        
        axes(ha(4))
        imagesc(valsMatmin_2')
        caxis([bottom top]);
        colormap(cmap)
        cb=colorbar;
        cb.TickLabels{1}='NA';
        title('$I(X_{i}^{k},O) + I(\hat{X}_{i}^{k},O) - I(X,O)$','interpreter','latex','Fontsize',16)
        ylabel('$k$','interpreter','latex','Fontsize',16)
%         xlabel('$i$','interpreter','latex','Fontsize',16)
        
        axes(ha(5))
        imagesc(nanmean(valsMatmin_2,2)')
        caxis([bottom top]);
        colormap(cmap)
        cb=colorbar;
        cb.TickLabels{1}='NA';
        title('$<I(X_{i}^{k},O) + I(\hat{X}_{i}^{k},O) - I(X,O)>$','interpreter','latex','Fontsize',16)
%         xlabel('$k$','interpreter','latex','Fontsize',16)
        ylabel('$i$','interpreter','latex','Fontsize',16)
        
        shrink2height = 0.025;
        initialHeight = ha(4).Position(4);
        ha(3).Position(4)=shrink2height;
        ha(5).Position(4)=shrink2height;
        leftoverHeight= 2*(initialHeight-shrink2height);

        ha(1).Position(4)=ha(1).Position(4)+leftoverHeight/1.8;
        ha(2).Position(4)=ha(2).Position(4)+leftoverHeight/3;
        ha(4).Position(4)=ha(4).Position(4)+leftoverHeight/3;
        
        ha(1).Position(2)=ha(1).Position(2)-1.75*leftoverHeight/3;
        ha(2).Position(2)=ha(2).Position(2)-2.2*leftoverHeight/3;
        ha(3).Position(2)=ha(3).Position(2)-0.5*leftoverHeight/3;
        ha(4).Position(2)=ha(4).Position(2)-1.75*leftoverHeight/3;
        
    end
    set(gcf,'InvertHardCopy','off','Color','white');
end

end

