function [config, store, obs] = taun5metrics(config, setting, data)                                
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
if nargin==0, unsupervised('do', 5, 'mask', {}); return; else store=[]; obs=[]; end
                                                                                                   
D=1-data.A/max(data.A(:));
k2look=[1 2 3 4 5 6 7 8 9];

for jj=k2look
    rm = rankingMetrics(D, data.class,jj);
    eval(['obs.pa' num2str(jj) '=rm.precisionAt' num2str(jj) ';']);
    eval(['store.pa' num2str(jj) '=rm.precisionAt' num2str(jj) ';']);
end