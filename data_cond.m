% 06-2012
% Victor Barres
% USC Brain Project
% Script to create the conductivity for a subject

function data_cond(varargin)

if isempty(varargin)
    subjName = getSubjName();
else
    subjName = varargin{1};
end

subjPath = sprintf('data\\%s',subjName);
fprintf('Subject: %s\n',subjName);
cond = getCondVals();
fprintf('Conductivity: %s\n',cond.name);
save(sprintf('%s\\cond',subjPath),'cond');
disp_cond(subjName);
end