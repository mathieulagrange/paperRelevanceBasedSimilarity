function [ data,leg ] = parseTable(d)

disp('')
leg=fieldnames(d.rows{1});

tmp=cellfun(@(x) struct2cell(x),d.rows,'UniformOutput',false);

data=cell(length(tmp{1}),length(tmp));

for ii=1:size(data,1)
    for jj=1:size(data,2)
        data{ii,jj}=tmp{jj}{ii};
    end
end

