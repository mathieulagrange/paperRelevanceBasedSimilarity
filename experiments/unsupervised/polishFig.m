names = {'RbQ-w, log-scattering', 'RbQ-a, log-scattering', 'RbQ-c, log-scattering', 'early, log-scattering',...
    'RbQ-w, mfcc', 'RbQ-a, mfcc', 'RbQ-c, mfcc', 'early, mfcc'};
    
legend(names,'interpreter','none')
legend('boxoff')
xlabel('k')
ylabel('p@k')
box off
ylim([0.25 .8])
xlim([.8 9.2])
set(gca, 'xticklabel', 1:9);
set(gcf,'Units','centimeters');
set(gcf,'PaperUnits','centimeters');
Position=get(gcf,'Position');
set(gcf, 'Position', [Position(1), Position(2),20,20]);
