% 05-2012
% Victor Barres
% USC Brain Project
% Script to create a random slab

function data_randSlab(varargin)

if isempty(varargin)
    subjName = input('Enter subject name:\n','s');
else
    subjName = varargin{1};
end

numVert = input('How many vertices?\n');
slabName = input('Enter slab name:\n','s');

dataPath = sprintf('data\\%s\\',subjName);

load(sprintf('%s\\meshes',dataPath));
cortex = meshes.realMesh(1);

%% Checking if some slabs exist for the subject
n = exist(sprintf('%s\\slabs.mat',dataPath),'file');
if n==2
    load(sprintf('%s\\slabs',dataPath))
else
    slabs.subj = subjName;
    slabs.slab = [];
end

numSlab = length(slabs.slab)+1;
slabs.slab(numSlab).name = slabName;
slabs.slab(numSlab).numVertices = numVert;

%% Generating random slab
i=1;
options = 1:size(cortex.Vertices(:,1));
vals = zeros(numVert,1);
    
while i<=numVert
    r = randi(length(options));
    vals(i) = options(r);
    options(r) = [];
    i=i+1;
end
vertVals = cortex.Vertices(vals,:);
mask = ones(length(cortex.Vertices(:,1)),1);
mask(vals) = 2;

slabs.slab(numSlab).Vertices = vertVals;
slabs.slab(numSlab).mask = mask;

save(sprintf('%s\\slabs',dataPath),'slabs');

disp_slab(subjName,slabName);
end