
clear;clc;

SSRPath = 'data\Subj_Friederici8\SSR\Serial_AND\ELAN+P600';
dAPath = 'temp';

% % Baseline
% M{1} = 'dA_N100_Baseline';
% M{2} = 'dA_ELAN_Baseline';
% M{3} = 'dA_LAN_Baseline';
% M{4} = 'dA_N400_Baseline';
% M{5} = 'dA_P600_Baseline';

% % CondSem
% M{1} = 'dA_N100_Baseline';
% M{2} = 'dA_ELAN_Baseline';
% M{3} = 'dA_LAN_Baseline';
% M{4} = 'dA_N400_CondSem';
% M{5} = 'dA_P600_CondSem';
% 
% CondSyn
M{1} = 'dA_N100_Baseline';
M{2} = 'dA_ELAN_CondSyn';
M{3} = 'dA_LAN_CondSyn';
M{4} = 'dA_N400_CondSyn';
M{5} = 'dA_P600_CondSyn';

for i=1:5
    dA(i) = load(sprintf('%s\\%s',dAPath,M{i}));
end

load(sprintf('%s\\Time',dAPath));
load(sprintf('%s\\activ',SSRPath));
activ.time = Time;
activ.timeRes = Time(2)-Time(1);

% figure;
% hold
set(gcf,'color','white');
box off
set(gca,'FontSize',16);
for i=1:5
    activ.area(i).dA = dA(i).f2;
    activ.area(i).inputTime = [];
    activ.area(i).outputTime = [];
    activ.area(i).activityLevel = [];
    activ.area(i).boxcar = [];
    plot(activ.time,activ.area(i).dA,'-','color','k','LineWidth',3);
end

% save(sprintf('%s\\activ',SSRPath),'activ');


% load(sprintf('%s\\activ',SSRPath));
% figure
% hold
% for i=1:5
%     plot(activ.time,activ.area(i).dA,'color','k','LineWidth',3);
% end