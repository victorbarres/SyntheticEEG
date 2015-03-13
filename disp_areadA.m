% 05-2012
% Victor Barres
% USC Brain Project
% Script to display area dA functions

function disp_areadA(varargin)

if isempty(varargin)
    simName = getSimName();
else
    simName = varargin{1};
end

path = sprintf('simulations\\%s\\',simName);
load(sprintf('%s\\activ.mat',path));

numA = length(activ.area);

totalDur = floor(activ.totalDur/activ.timeRes);
time = activ.time;
figure;
set(gcf,'name',sprintf('Area dA for sim: %s',simName));

M = 0;
for i=1:numA
    a = max(activ.area(i).dA(1:totalDur));
    if a>M
        M=a;
    end
end

for s =1:numA
    subplot(numA,1,s);
    box off
    hold
    axis([0 activ.totalDur 0 M+0.1])
    axis manual
    plot(time(1:totalDur), activ.area(s).dA(1:totalDur),'-.','Color','k','LineWidth',3);
%     plot(time(1:totalDur), activ.area(s).boxcar(1:totalDur),'-','Color','k','LineWidth',2);
%     title(sprintf('Area: %s',activ.area(s).name),'FontSize',8);
    set(gca,'FontSize',16);
    set(gcf,'Color','White');
    if s==numA
        xlabel('time (ms)');
    end
end

end
