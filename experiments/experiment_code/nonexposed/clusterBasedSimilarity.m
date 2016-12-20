function [A] = clusterBasedSimilarity(clusterSim,params)

nbScenes=length(unique(params.indSample));
indScenes=params.indSample;
A=zeros(nbScenes,nbScenes);

for ii=1:nbScenes
    for jj=ii+1:nbScenes
        sTmp=clusterSim(indScenes==ii,indScenes==jj);
        sTmp=sTmp(:);
        sTmp=sTmp(sTmp~=0);
        if isempty(sTmp)
            sTmp=0;
        end
        switch params.histDist
            case 'average'
                A(ii,jj)=mean(sTmp(:));
            case 'furthest'
                A(ii,jj)=min(sTmp(:));
            case 'closest'
                A(ii,jj)=max(sTmp(:));
            case 'median'
                A(ii,jj)=median(sTmp(:));
        end
        A(jj,ii)=A(ii,jj);
    end
end

A(logical(eye(size(A)))) = 1;

end

