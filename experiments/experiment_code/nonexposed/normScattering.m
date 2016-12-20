function [ data,setting] = scatteringNorm(data,params)

if isfield(params,'med')
    setting.med=params.med;
    setting.v=params.v;
else
    setting.type='scattering';
    setting.ftrsNorm_scat_threshold=params.ftrsNorm_scat_threshold;
    setting.ftrsNorm_scat_selection=params.ftrsNorm_scat_selection;
    setting.ftrsNorm_scat_log=params.ftrsNorm_scat_log;
    setting.med = median(data,2);
    setting.v = var(data,[],2);
end

if params.ftrsNorm_scat_threshold~=0 
    data = bsxfun(@rdivide, data, setting.med)*params.ftrsNorm_scat_threshold;
end

if params.ftrsNorm_scat_selection~=1
    setting.v = setting.v/sum(setting.v);
    [~,i] = sort(-setting.v);
    cv = cumsum(setting.v(i));
    data =  data(i(cv<params.ftrsNorm_scat_selection),:);
end

if params.ftrsNorm_scat_log==1
    data = log1p(data);
end

end

