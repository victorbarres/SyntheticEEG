% 05-2012
% Victor Barres
% USC Brain Project
% Script to display the EEG signal for an electrode

function disp_elecEEG(varargin)

if isempty(varargin)
    subjName = getSubjName();
    subjPath = sprintf('data\\%s',subjName);
    sensName = getSensorName(subjPath);
else
    subjName = varargin{1};
    subjPath = sprintf('data\\%s',subjName);
    sensName = varargin{2};
end

load(sprintf('%s\\EEG_%s',subjPath,sensName));
ERP = EEG.ERP;
time = EEG.time';

figure;
set(gcf,'name',sprintf('%s',sensName));
plot(time,ERP,'Color','black','LineWidth',2);
title(sprintf('%s',sensName));
set(gca,'FontSize',12);
set(gcf,'Color','White');
xlabel('time (ms)'); ylabel('Activation');
end

%% Function
function sensName = getSensorName(subjPath)
d = dir(subjPath);
listFile= {d.name};
c=0;
for i=1:length(listFile)
    if length(listFile{i})>3 && strcmp(listFile{i}(1:4),'EEG_')
        c = c+1;
        l = length(listFile{i});
        listOption{c} = listFile{i}(5:l-4);
    end
end

v=0;
while v==0
    prompt ='Select sensor Name:';
    [optionIndex,v] = listdlg('PromptString',prompt,...
        'SelectionMode','single',...
        'ListString',listOption);
end
sensName = listOption{optionIndex};
end