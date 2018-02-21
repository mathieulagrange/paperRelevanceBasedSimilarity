function [ sceneFeatures ] = histFeatures(prediction,indSample,params)

c=1:params.nbc;
nbc=params.nbc;

sampleLabels=unique(indSample);
sceneFeatures=zeros(nbc,length(sampleLabels));

for jj=1:length(sampleLabels)
    sceneFeatures(:,jj)=hist(prediction(indSample==sampleLabels(jj)),c);
end

switch params.histType
    case 'pres'
        sceneFeatures(sceneFeatures>0)=1;
    case 'thresh'
        sceneFeatures(sceneFeatures<=params.thresh)=0;      
end
disp('')