% 05-2012
% Victor Barres
% USC Brain Project
% Script to create the EEG signal for an electrode
% This second version works with the output of the sequence:
% data_dA, data_dipdA

function data_elecEEG2(varargin)

if isempty(varargin)
    simName = getSimName();
else
    simName = varargin{1};
end

simPath = sprintf('simulations\\%s',simName);
load(sprintf('%s\\waveform',simPath));
load(sprintf('%s\\leadfield',simPath));
load(sprintf('%s\\sensors',simPath));

listOption = sensors.name;
prompt = 'Choose electrode:';
option = getOption(listOption,prompt);

numDip = length(leadfield.dipLF);

res = waveform(1).time(2) - waveform(1).time(1);
totalDur = floor(waveform(1).totalDur/res);
EEG.electrode = option.name;
EEG.time = waveform(1).time(1:totalDur);
dipLF = leadfield.dipLF;
signals = zeros(numDip,length(EEG.time));

for i=1:numDip
    signals(i,:) = waveform(i).dA(1:totalDur)*dipLF{i}(option.ind);
end
EEG.signals = signals;
EEG.ERP = sum(signals,1);

fileName = sprintf('%s\\EEG_%s',simPath,EEG.electrode);
save(fileName,'EEG');
disp_elecEEG(simName,EEG.electrode);
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