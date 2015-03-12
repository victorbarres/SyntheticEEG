% 05-2012
% Victor Barres
% USC Brain Project
% Script to display the waveform for each dipoles

function disp_wave(varargin)

if isempty(varargin)
    subjName = getSubjName();
else
    subjName = varargin{1};
end

subjPath = sprintf('data\\%s',subjName);
load(sprintf('%s\\waveform',subjPath));
dBoxcar = waveform.dBoxcar;
time = dBoxcar(1).time';

numPlot = length(waveform.wave);
k=4;
numFig = ceil(numPlot/k);

for f=1:numFig
    figure;
    set(gcf,'name',sprintf('Dipole waveform for subj: %s',subjName));
    m =(f-1)*k+1;
    M =min(f*k,numPlot);
    for p=m:M      
        subplot(k,1,mod(p-1,k)+1);
        hold;
        plot(time,dBoxcar(p).boxcar,'Color','blue','LineWidth',2);
        plot(time,waveform.wave{p},'Color','red','LineWidth',2);
        names = dBoxcar(p).brainCircuits;
        bcName = [];
        for n=1:length(names)
            bcName = [bcName ' ' names{n}];
        end
        title(sprintf('Dipole %i: %s',p,bcName));
        set(gca,'FontSize',12);
        set(gcf,'Color','White');
        xlabel('time (ms)'); ylabel('Activation');
        legend('boxcar','waveform');
    end
end
end