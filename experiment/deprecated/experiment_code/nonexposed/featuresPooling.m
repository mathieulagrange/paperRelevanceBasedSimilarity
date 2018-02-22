function [ftrs_pool,onsets,offsets] = featuresPooling(features,type,onsets,offsets,win,hop,hoptime)

ftrs_pool=[];

if win~=0
    win=round(win/hoptime);
    hop=round(hop/hoptime);
    [onsets,offsets] = overSeg(onsets,offsets,win,hop);
end

for jj=1:length(onsets)
    
    switch type
        
        case 'mean'
            ftrs_pool=[ftrs_pool mean(features(:,onsets(jj):offsets(jj)),2)];
        case 'max';
            ftrs_pool=[ftrs_pool max(features(:,onsets(jj):offsets(jj)),[],2)];
        otherwise
            error('wrong type argIn')
    end
    
    
end

