function [ newOnsets,newOffsets] = overSeg(onsets,offsets,win,hop)

newOnsets=[];
newOffsets=[];

for jj=1:length(onsets)
   
    currentOnsets=onsets(jj);
    flag=1;
    it=0;
    
    while flag
        
        if win<=offsets(jj)-currentOnsets+1
            
            newOnsets=[newOnsets currentOnsets];
            newOffsets=[newOffsets currentOnsets+win-1];
            
            currentOnsets=currentOnsets+hop;
            
        else 
            
           flag=0; 
           
            newOnsets=[newOnsets currentOnsets];
            newOffsets=[newOffsets offsets(jj)];
           
        end
        
        if it>10000
            error('inf loop')
        else
            it=it+1;
        end
            
    end
    
end


end

