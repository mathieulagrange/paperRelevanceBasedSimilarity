function [config, store, obs] = taun6best(config, setting, data)                                
% taun5metrics METRICS step of the expLanes experiment talspStruct2016_unsupervised                
%    [config, store, obs] = taun5metrics(config, setting, data)                                    
%      - config : expLanes configuration state                                                     
%      - setting   : set of factors to be evaluated                                                
%      - data   : processing data stored during the previous step                                  
%      -- store  : processing data to be saved for the other steps                                 
%      -- obs    : observations to be saved for analysis                                           
                                                                                                   
% Copyright: gregoirelafay                                                                         
% Date: 17-Dec-2016                                                                                
                                                                                                   
% Set behavior for debug mode                                                                      
if nargin==0, unsupervised('do', 6, 'mask', {0 0 2 0 [3 7 16] 1 0 5}); return; else store=[]; obs=[]; end

bestP = 0;
bestSetting = 0;
% find setting getting best pa9 among train
for k=1:length(data)
    if strcmp(data(k).info.setting.dataset, 'train') &&  data(k).pa9 > bestP
        bestP = data(k).pa9;
        bestSetting =  data(k).info.setting.infoId;
    end
end
bestSetting(5)
% select setting in test
bestSetting(1) = 2;
found=0;
for k=1:length(data)
   if bestSetting ==  data(k).info.setting.infoId
       found=1;
       break
   end
end
if found
    k2look=[1 2 3 4 5 6 7 8 9];
    
    for jj=k2look
        eval(['obs.pa' num2str(jj) '= data(k).pa' num2str(jj) ';']);
    end
else
%  unsupervised('do', 3:5, 'mask', num2cell(bestSetting));
%  [config, store, obs] = taun6best(config, setting, data);    
end
