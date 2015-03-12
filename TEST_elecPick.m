% To pick the most significant electrode


function [time2peak,nameElec] = TEST_elecPick

% clear;clc;
elecPath = 'data\\elec';
elecName = 'channel_10-10_65';
load(sprintf('%s\\%s',elecPath,elecName));

subjName = 'Subj_Friederici6';
base = 'Baseline';
cond = 'N400';
subjPath = sprintf('data\\%s',subjName);
load(sprintf('%s\\SSR\\serial_AND\\%s\\LFtimecourse',subjPath,base));
lf1 = lf;
load(sprintf('%s\\SSR\\serial_AND\\%s\\LFtimecourse',subjPath,cond));
lf2 = lf;



lf = lf2-lf1;

time = 400; % check the window
res = 25;
L = 0;

win = floor(time/res-L/res):ceil(time/res+L/res);

[vals,timeInd] = min(lf(:,win),[],2); % check the min or max

[~,elecInd] = min(vals); % check the min or max

time2peak  = (win(1)+(timeInd(elecInd)-1))*res;
figure;
hold on
plot(lf(elecInd,:),'color','k');
plot(lf1(elecInd,:),'color','b');
plot(lf2(elecInd,:),'color','r');
names = {elec.channel.Name};
nameElec = names{elecInd};
end