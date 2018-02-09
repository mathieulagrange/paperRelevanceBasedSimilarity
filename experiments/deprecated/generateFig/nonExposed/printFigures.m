function [] = printFigures(nbFig,name,opt)

for jj=1:length(nbFig)
    colormap('gray')
    set(figure(nbFig(jj)),'PaperUnits','centimeters')
    set(figure(nbFig(jj)),'Units','centimeters')
    set(figure(nbFig(jj)),'PaperPositionMode','manual')
    set(figure(nbFig(jj)),'papersize',[opt.width,opt.height])
    set(figure(nbFig(jj)),'paperposition',[0,0,opt.width,opt.height])
  
    
    
    set(findall(figure(nbFig(jj)),'-property','FontSize'),'FontSize',opt.fontsize)
    set(findall(figure(nbFig(jj)),'-property','FontName'),'FontName','Arial')
    
    %%
    
    if isfield(opt,'markersize')
        set(findall(figure(nbFig(jj)),'-property','markersize'),'markersize',opt.markersize)
    end
    
    if isfield(opt,'linewidth')
        set(findall(figure(nbFig(jj)),'-property','linewidth'),'linewidth',opt.linewidth)
    end
    
    %% title
    
    if isfield(opt,'axesTitle')
        allAxesInFigure = findall(figure(nbFig(jj)),'type','axes');
        for ll=1:length(allAxesInFigure)
            allAxesInFigure(ll).Title.String=opt.axesTitle{jj}{length(allAxesInFigure)-ll+1}; % reverse order of axes
        end
    end

    print(['-f' num2str(nbFig(jj))],[name num2str(nbFig(jj))],'-depsc')
    print(['-f' num2str(nbFig(jj))],[name num2str(nbFig(jj))],'-dpdf')
end


end

