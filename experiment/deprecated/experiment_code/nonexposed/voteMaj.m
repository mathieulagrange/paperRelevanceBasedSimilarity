function [newPred,newPred2] = voteMaj(prediction,indSample)

labSample=unique(indSample);
predLab=unique(prediction);
newPred=zeros(1,length(labSample));
newPred2=zeros(size(prediction));

for jj=1:length(labSample)
    count=hist(prediction(indSample==labSample(jj)),predLab);
    [~,newPred(jj)]=max(count);
    newPred2(indSample==labSample(jj))=newPred(jj);
end

