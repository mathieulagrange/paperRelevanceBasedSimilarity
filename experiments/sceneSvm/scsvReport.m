function config = scsvReport(config)                      
% scsvReport REPORTING of the expLanes experiment sceneSvm
%    config = scsvInitReport(config)                      
%       config : expLanes configuration state             
                                                          
% Copyright: Mathieu Lagrange                             
% Date: 29-Jun-2016                                       
                                                          
if nargin==0, sceneSvm('report', 'r'); return; end        
                                                          
config = expExpose(config, 't', 'mask', {});                          
