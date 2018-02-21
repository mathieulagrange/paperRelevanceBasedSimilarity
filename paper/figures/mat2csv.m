
files = dir('./*.mat')

for k=1:length(files)
    clear data
   load(files(k).name) 
   if (exist('data', 'var'))
     csvwrite([files(k).name(1:end-3), 'csv'], data.meanData); 
   end
end