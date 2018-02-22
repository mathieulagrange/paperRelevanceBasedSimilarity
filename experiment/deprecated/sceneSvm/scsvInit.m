function [config, store] = scsvInit(config)                        
% scsvInit INITIALIZATION of the expLanes experiment sceneSvm      
%    [config, store] = scsvInit(config)                            
%      - config : expLanes configuration state                     
%      -- store  : processing data to be saved for the other steps 
                                                                   
% Copyright: Mathieu Lagrange                                      
% Date: 29-Jun-2016                                                
                                                                   
if nargin==0, sceneSvm(); return; else store=[];  end              
