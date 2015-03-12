%% TEST COMPARING SERP

base = 'Baseline';
cond = 'ELAN+P600';
elec = 'PO3';

path = 'data\\Subj_Friederici8\\SSR\\Serial_AND';

load(sprintf('%s\\%s\\EEG_%s',path,base,elec));

time = EEG.time;
ERP1 = EEG.ERP;
elecName = EEG.electrode;

load(sprintf('%s\\%s\\EEG_%s',path,cond,elec));

ERP2 = EEG.ERP;
figure;
set(gcf,'color','white')
% title(sprintf('%s SERP %s',elec,cond));
hold
set(gca,'FontSize',16);
set(gca,'Ydir','reverse');
plot(time',ERP1','-','color','k','LineWidth',3);
plot(time',ERP2','-.','color','k','LineWidth',3);

% legend('Standard','Deviant')
% xlabel('Time (ms)');
% ylabel('Activation');