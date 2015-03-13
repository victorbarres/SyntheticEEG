% 06-2012
% Victor Barres
% USC Brain Project
% Script to create the conductivity for a simulations

function data_cond(varargin)

if isempty(varargin)
    simName = getSimName();
else
    simName = varargin{1};
end

simPath = sprintf('simulations\\%s',simName);
fprintf('Simulations: %s\n',simName);
cond = getCondVals();
fprintf('Conductivity: %s\n',cond.name);
save(sprintf('%s\\cond',simPath),'cond');
disp_cond(simName);
end