% 05-2012
% Victor Barres
% USC Brain Project
% Script to create a slab from atlas

function data_atlasSlab(varargin)

if isempty(varargin)
    simName = getSimName();
    slabName = inputSlabName();
    atlasName = getAtlasName();
    ansArea = getAreaName(atlasName);
    areaName = ansArea.areaName;
    areaIndex = ansArea.areaIndex;
elseif length(varargin)==1
    simName = varargin{1};
    slabName = inputSlabName();
    atlasName = getAtlasName();
    ansArea = getAreaName(atlasName);
    areaName = ansArea.areaName;
    areaIndex = ansArea.areaIndex;
else
    simName = varargin{1};
    slabName = varargin{2};
    atlasName = varargin{3};
    areaIndex = varargin{4};
end

fprintf('simulation selected: %s\n',simName);
fprintf('slab name: %s\n',slabName);
fprintf('atlas selected: %s\n',atlasName);
fprintf('Plotting slabs selected\n');
disp_atlas(atlasName,areaIndex);
a =  input('Continue (yes/no)?\n','s');
if ~strcmp(a,'yes')
    error('Slabe creation aborted');
end

dataPath = 'data';
atlasPath = sprintf('%s\\atlas',dataPath);
simPath = sprintf('simulations\\%s',simName);

load(sprintf('%s\\meshes',simPath));
load(sprintf('%s\\%s',atlasPath,atlasName));

%% Checking mesh compatibility
atlasBrain = atlas.brainModel;
simBrain = meshes.fromNames{1};

fprintf('Sim brain model: %s\n',simBrain);
fprintf('Atlas brain model: %s\n',atlasBrain);

if ~strcmp(atlasBrain,simBrain)
    error('Uncompatible brain meshes');
end

cortex = meshes.realMesh(1);

%% Checking if some slabs exist for the simect
n = exist(sprintf('%s\\slabs.mat',simPath),'file');
if n==2
    load(sprintf('%s\\slabs',simPath))
else
    slabs.sim = simName;
    slabs.slab = [];
end

%% Initializing new slab 
numSlab = length(slabs.slab)+1;
slabs.slab(numSlab).name = slabName;
slabs.slab(numSlab).atlasName = atlasName;
slabs.slab(numSlab).simName = simName;
slabs.slab(numSlab).areaName = areaName;
slabs.slab(numSlab).areaIndex = areaIndex;
%% Generating slab
vals = [];
area2slab ={};
num = 0;
for i=1:length(areaIndex)
    flag = true;
    ind = areaIndex(i);
    newVals = atlas.area(ind).Vertices;
    if flag
        area2slab.name = atlas.area(ind).Label;
        flag = false;
    end
    oldNum = num;
    num = num + length(newVals);
    area2slab.vertNum = (oldNum+1):num;
    slabs.slab(numSlab).area2slab(i) = area2slab;
    vals = [vals;newVals];
end

slabs.slab(numSlab).vertIndex = vals;
vertCoord = cortex.Vertices(vals,:);
mask = ones(size(cortex.Vertices,1),1);
mask(vals) = 2;

slabs.slab(numSlab).Vertices = vertCoord;
slabs.slab(numSlab).mask = mask;

save(sprintf('%s\\slabs',simPath),'slabs');

disp_slab(simName,numSlab);
end

%% Functions
function name = inputSlabName()
s = {};
while size(s)==0
    prompt = {'Enter slab name:'};
    dlg_title = 'Slab name';
    num_lines = 1;
    def = {'e.g. N400 generator'};
    options.Resize='on';
    options.WindowStyle='normal';
    s = inputdlg(prompt,dlg_title,num_lines,def,options);
end
name = s{1};
end