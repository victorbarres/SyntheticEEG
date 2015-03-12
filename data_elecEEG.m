% 05-2012
% Victor Barres
% USC Brain Project
% Script to create the EEG signal for an electrode

function data_elecEEG(varargin)

if isempty(varargin)
    subjName = getSubjName();
else
    subjName = varargin{1};
end

subjPath = sprintf('data\\%s',subjName);
load(sprintf('%s\\waveform',subjPath));
load(sprintf('%s\\grid',subjPath));
load(sprintf('%s\\sensors',subjPath));
load(sprintf('%s\\dipoles',subjPath));
leadField = grid.leadfield;

listOption = sensors.name;
prompt = 'Choose electrode:';
option = getOption(listOption,prompt);

dipNorm = dipoles.dipNorm;
numDip = size(dipNorm,1);

EEG.electrode = option.name;
EEG.time = waveform.dBoxcar(1).time;
lfCoeff = zeros(numDip,1);
signals = zeros(numDip,length(EEG.time));

for i=1:numDip
    lfCoeff(i) = dipNorm(i,:)*leadField{i}(option.ind,:)';
    signals(i,:) = waveform.wave{i}*lfCoeff(i);
end
EEG.lfCoeff = lfCoeff;
EEG.signals = signals;
EEG.ERP = sum(signals,1);

fileName = sprintf('%s\\EEG_%s',subjPath,EEG.electrode);
save(fileName,'EEG');
disp_elecEEG(subjName,EEG.electrode);
end

%% Functions
function option= getOption(listOption,prompt)
v=0;
while v==0
   [optionIndex,v] = listdlg('PromptString',prompt,...
        'SelectionMode','single',...
        'ListString',listOption);
end
option.ind = optionIndex;
option.name = listOption{optionIndex};
end