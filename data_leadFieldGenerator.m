% 05-2012
% Victor Barres
% USC Brain Project
% Script to create the leadfield for a given simulation
% Uses FieldTrip implementation of OpenMEEG
% Requires that is available for the simulation:
%       - meshes
%       - sensors
%       - dipoles (and therefore slabs)
% Conductivities can be chosen among the options offered by SynERP
% leadfield is saved in the simulation's folder.

function data_leadFieldGenerator(varargin)

diary on;

if isempty(varargin)
    simName = getSimName();
else
    simName = varargin{1};
end


% Load data
simPath = sprintf('simulations\\%s',simName);
load(sprintf('%s\\meshes.mat',simPath));
load(sprintf('%s\\dipoles.mat',simPath));
load(sprintf('%s\\sensors.mat',simPath));
load(sprintf('%s\\cond.mat',simPath));

%Define volume structure
vol = [];
for i=1:length(meshes.mesh)
    vol.bnd(i).pnt = meshes.mesh(i).Vertices;
    vol.bnd(i).tri = meshes.mesh(i).Faces;
end
vol.cond = cond.vals; % Here I take the mean value for each tissue.

%Defining sensors
disp('Creating electrode set');
fprintf('Sensors: %s\n',sensors.type);
sens.pnt = sensors.pos;
sens.label = {};
nsens = size(sens.pnt,1);
for i=1:nsens
    if isempty(sensors.name)
        sens.label{i} = sprintf('sens%03d', i);
    else
        sens.label{i} = sensors.name{i};
    end
end

%Defining dipoles
disp('Defining dipoles position');
pos = dipoles.dipCoord;

% Compute the BEM with OpenMEEG through FieldTrip
fprintf('Computing the BEM\n');
cfg.method = 'openmeeg';
vol = ft_prepare_headmodel(cfg, vol);

cfg.vol = vol;
cfg.grid.pos = pos;
cfg.elec = sens;

fprintf('Computing the lead field\n');
grid = ft_prepare_leadfield(cfg);

% Saving results
save(sprintf('%s\\cfg',simPath),'cfg');
save(sprintf('%s\\grid',simPath),'grid');

numDip = size(cfg.grid.pos,1);
data_leadfield(simName,1:numDip);
if ~strcmp(sensors.type,'Default elec cap')
    disp_leadfield(simName,1:numDip);
else
    disp('NO DISPLAY CREATED FOR DEFAULT CAPS YET!!!!')
end

diary(sprintf('%s\\leadFieldDiary.txt',simPath));
diary off;
end