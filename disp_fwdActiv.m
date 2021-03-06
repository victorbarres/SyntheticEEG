% 05-2012
% Victor Barres
% USC Brain Project
% Script to display fwdActive

function disp_fwdActiv(varargin)

if isempty(varargin)
    simName = getSimName();
else
    simName = varargin{1};
end

path = sprintf('simulations\\%s\\',simName);
load(sprintf('%s\\fwdActiv.mat',path));

numBC = length(fwdActiv.brainCircuit);

time = fwdActiv.time;
figure;
set(gcf,'name',sprintf('Area boxcar for sim: %s',simName));
for s =1:numBC
    subplot(numBC,1,s);
    plot(time, fwdActiv.brainCircuit(s).boxcar,'Color','blue','LineWidth',2);
    title(sprintf('Circuit: %s',fwdActiv.brainCircuit(s).name));
    set(gca,'FontSize',12);
    set(gcf,'Color','White');
    xlabel('time (ms)'); ylabel('Activation');    
end
end