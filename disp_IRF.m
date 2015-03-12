% 05-2012
% Victor Barres
% USC Brain Project
% Script to display the Impulse Response Function

function disp_IRF(varargin)

if isempty(varargin)
    subjName = getSubjName();
else
    subjName = varargin{1};
end

subjPath = sprintf('data\\%s',subjName);
load(sprintf('%s\\IRF',subjPath));
impulseF = IRF.f;
impTime = IRF.impTime;
param = IRF.param;
if ~isempty(param)
    fprintf('%s impulse function\n', IRF.type)
    fprintf('Mean = %f\tStd = %f\n',param(1),param(2));

figure;
set(gcf,'name',sprintf('Impulse Response function for subj: %s',subjName));
thresh = 10^-5;
ind1 = find(impulseF>thresh,1,'first');
ind2 = find(impulseF>thresh,1,'last');
plot(impTime(ind1:ind2),impulseF(ind1:ind2),'Color', 'red', 'LineWidth', 2)
title(sprintf('%s impulse function', IRF.type));
set(gcf,'color','white');
set(gca,'FontSize',12);
xlabel('Time (ms)'); ylabel('Activation');
end