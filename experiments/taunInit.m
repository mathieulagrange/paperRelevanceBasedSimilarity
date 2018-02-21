function [config, store] = taunInit(config)                                      
% taunInit INITIALIZATION of the expLanes experiment talspStruct2016_unsupervised
%    [config, store] = taunInit(config)                                          
%      - config : expLanes configuration state                                   
%      -- store  : processing data to be saved for the other steps               
                                                                                 
% Copyright: gregoirelafay                                                       
% Date: 17-Dec-2016                                                              
                                                                                 
if nargin==0, talspStruct2016_unsupervised(); return; else store=[];  end        
