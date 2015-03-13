% 05-2012
% Victor Barres
% USC Brain Project
% Script to display the conductivities chosend for a simulation

function disp_cond(varargin)

if isempty(varargin)
    simName = getSimName();
else
    simName = varargin{1};
end

simPath = sprintf('simulations\\%s',simName);
load(sprintf('%s\\cond',simPath));
fprintf('Cond name: %s\n',cond.name);
fprintf('CondValues:\n');
disp(cond.vals);


end
