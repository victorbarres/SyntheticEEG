% 05-2012
% Victor Barres
% USC Brain Project
% Script to create the source wave for the dipoles


function data_sourceWave(varargin)

if isempty(varargin)
    simName = getSimName();
else
    simName = varargin{1};
end

simPath = sprintf('simulations\\%s',simName);

load(sprintf('%s\\dBoxcar',simPath));
load(sprintf('%s\\IRF',simPath));


time = dBoxcar(1).time;
impTime = IRF.impTime;
timeRes = time(2)-time(1);
impulseF = IRF.f;

a = find(impTime>=0,1,'first');
b = a+length(time)-1;

waveform.IRF = IRF;
waveform.dBoxcar = dBoxcar;

for d=1:length(dBoxcar)
    boxcar = dBoxcar(d).boxcar;
    w = conv(boxcar,impulseF)*timeRes;
    w = w(a:b);
    waveform.wave{d} = w';
end

save(sprintf('%s\\waveform',simPath),'waveform');

disp_wave(simName);
end