% 06-2012
% Victor Barres
% USC Brain Project
% Script to create the final leadfield from the grid output.

function data_leadfield(varargin)

if isempty(varargin)
    subjName = getSubjName();
    path = sprintf('data\\%s\\',subjName);
    load(sprintf('%s\\dipoles.mat',path));
    dipList = getDipList(dipoles);
elseif length(varargin)==1
    subjName = varargin{1};
    path = sprintf('data\\%s\\',subjName);
    load(sprintf('%s\\dipoles.mat',path));
    dipList = getDipList(dipoles);
else
    subjName = varargin{1};
    dipList = varargin{2};
    path = sprintf('data\\%s\\',subjName);
    load(sprintf('%s\\dipoles.mat',path));
end

load(sprintf('%s\\grid.mat',path));
load(sprintf('%s\\meshes.mat',path));
load(sprintf('%s\\sensors.mat',path));

dipNorm = dipoles.dipNorm;

%% create the field for each dipole and the total leadfield
lf= zeros(size(grid.leadfield{1},1),1);
numFields = length(dipList);
dipLF = {};

for j=1:numFields
    i = dipList(j);
    N = dipNorm(j,:)';
    dipLF{j} = grid.leadfield{i}*N;
    lf = lf+ dipLF{j};
end

leadfield.lf = lf;
leadfield.dipLF = dipLF;
leadfield.sensName = sensors.name;
leadfield.sensPos = sensors.pos;
leadfield.sensType = sensors.type;
save(sprintf('%s\\leadfield',path),'leadfield');
end

function dipList = getDipList(dipoles)
for i=1:size(dipoles.dipCoord,1);
    listOption{i} = int2str(i);
end
prompt = 'Pick dipoles:';
mode = 'multiple';
option = getOption(listOption,prompt,mode);
dipList = option.ind;
end