clear all
addpath(genpath('functions'))

%% settings

dataset='test'; 
dataPath={['~/projets/ass_features/report/figures/supervised_earlyInt_' dataset]};

linewidth=2;
markersize=10;
markerLeg={'diamond','o','*','x','^'};
%% load data

data=cell(1,length(dataPath));
leg=cell(1,length(dataPath));

for jj=1:length(dataPath)
    d=load(dataPath{jj});
    [data{jj},leg{jj}]=parseTable(d.data(1).tables{end});
end

acc=str2double(data{1}(10:14,:));
m_acc=mean(acc,1);
std_acc=std(acc,[],1);

scat=strcmp('scatT',data{1}(1,:));
mfcc=strcmp('mfcc',data{1}(1,:));
mfcc_rank=strcmp('40',data{1}(3,:));
mfcc_c0=strcmp('1',data{1}(4,:));
fr=strcmp('27,5_1000',data{1}(2,:));
stand=strcmp('stand',data{1}(6,:));
gaussian=strcmp('gaussian_full',data{1}(7,:));
inner=strcmp('inner_full',data{1}(7,:));
nn_10_mfcc=strcmp('0.10',data{1}(8,:));
nn_40_scat=strcmp('0.40',data{1}(8,:));
scat_log=strcmp('1',data{1}(5,:));

%% best acc
leg2={'ei-mfcc-linear','ei-scat-linear','ei-scat-logComp-linear',...
    'ei-mfcc-rbf','ei-scat-rbf','ei-scat-logComp-rbf'};

sel{1}= mfcc_rank & mfcc_c0  & stand & fr & mfcc & inner;
sel{2}= ~scat_log & stand & scat & inner;
sel{3}= scat_log & stand & scat & inner;
sel{4}= mfcc_rank & mfcc_c0  & stand & fr & mfcc & gaussian & nn_10_mfcc;
sel{5}= ~scat_log & stand & scat & gaussian & nn_40_scat;
sel{6}= scat_log & stand & scat & gaussian & nn_40_scat;

acc_f=[];

for jj=1:length(leg2)
    disp([leg2{jj} ' : acc=' num2str(m_acc(sel{jj})) ', std=' num2str(std_acc(sel{jj})) ])
    acc_f=[acc_f acc(:,sel{jj})];
end

sel_fig1=logical([1 1 1 0 0 0]);

figure(1)
clf
hold on
for jj=1:size(acc_f,1)
    plot(acc_f(jj,sel_fig1),'marker',markerLeg{jj},'markersize',markersize,'linewidth',linewidth)
end
hold off
set(gca,'xtick',1:sum(sel_fig1),'xticklabel',leg2(sel_fig1),'xticklabelrotation',45)
legend('f1','f2','f3','f4','f5','orientation','horizontal','location','north')
legend boxoff
xlim([0.8 sum(sel_fig1)+.2])
ylim([0.2 1])
disp('')

sel_fig2=logical([0 0 0 1 1 1]);

figure(2)
clf
hold on
for jj=1:size(acc_f,1)
    plot(acc_f(jj,sel_fig2),'marker',markerLeg{jj},'markersize',markersize,'linewidth',linewidth)
end
hold off
set(gca,'xtick',1:sum(sel_fig2),'xticklabel',leg2(sel_fig2),'xticklabelrotation',45)
legend('f1','f2','f3','f4','f5','orientation','horizontal','location','north')
legend boxoff
xlim([0.8 sum(sel_fig2)+.2])
ylim([0.2 1])
disp('')

%% print
figOpt.fontsize=16;
figOpt.height=15;
figOpt.width=20;

printFigures(1,['~/papers/paperStructureScene16/paper/gfx/supervised_linear_' dataset],figOpt)
printFigures(2,['~/papers/paperStructureScene16/paper/gfx/supervised_rbf_' dataset],figOpt)