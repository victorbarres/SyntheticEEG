% 05-2012
% Victor Barres
% USC Brain Project
% Script to display the waveform for each dipoles

function disp_wave2(varargin)

if isempty(varargin)
    simName = getSimName();
else
    simName = varargin{1};
end

simPath = sprintf('simulations\\%s',simName);
load(sprintf('%s\\waveform',simPath));
time = waveform(1).time';
res = waveform(1).time(2) - waveform(1).time(1);
totalDur = floor(waveform(1).totalDur/res);

numPlot = length(waveform);
k=4;
numFig = ceil(numPlot/k);

for f=1:numFig
    figure;
    set(gcf,'name',sprintf('Dipole dA for sim: %s',simName));
    m =(f-1)*k+1;
    M =min(f*k,numPlot);
    for p=m:M      
        subplot(k,1,mod(p-1,k)+1);
        hold;
        wave =waveform(p).dA;
        plot(time(1:totalDur),wave(1:totalDur),'Color','red','LineWidth',2);
        names = waveform(p).brainArea;
        areaName = [];
        for n=1:length(names)
            areaName = [areaName ' ' names{n}];
        end
        title(sprintf('Dipole %i: %s',p,areaName));
        set(gca,'FontSize',12);
        set(gcf,'Color','White');
        xlabel('time (ms)'); ylabel('Activation');
    end
end
end