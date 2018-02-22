
files = dir('./*.mat');

for k=1:length(files)
    clear data
    load(files(k).name)
    if (exist('data', 'var'))
        csvwrite([files(k).name(1:end-3), 'csv'], data.meanData);
    end
    
    h=openfig([files(k).name(1:end-3) 'fig']);
    set(h, 'visible', 'on')
    ylabel('p@k (%)');
    legend('-DynamicLegend');
    lines = findobj(gcf,'Type','Line');
    for i = 1:numel(lines)
        lines(i).LineWidth = 2.0;
    end
    axis([1 9 10 100]);
    disp('edit');
    saveas(gcf, [files(k).name(1:end-3) 'png'])
end