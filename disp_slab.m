% 05-2012
% Victor Barres
% USC Brain Project
% Script to display a slab

function disp_slab(varargin)

if isempty(varargin)
    subjName = getSubjName();
    ansSlab = getSlabName(subjName);
    slabName = ansSlab.slabName;
    slabIndex = ansSlab.slabIndex;
else
    subjName = varargin{1};
    slabIndex = varargin{2};
end

path = sprintf('data\\%s\\',subjName);
load(sprintf('%s\\slabs.mat',path));
load(sprintf('%s\\meshes.mat',path));

brain = meshes.realMesh(1);

if slabIndex==0
    slabIndex = 1:length(slabs.slab); % Select all the slabs
end

numSlabs = length(slabIndex);
cmap = colormap(hsv(numSlabs));
cmap = [cmap;[1,1,1]];
colormap(cmap);

%Create mask
numVertices = size(brain.Vertices,1);
mask = ones(numVertices,1)*(numSlabs+1); % Color of the brain outside the defined areas.
c=1;
for i=slabIndex
    list = slabs.slab(i).mask==2;
    mask(list) = c;
    c=c+1;
end

bnd.pnt = brain.Vertices;
bnd.tri = brain.Faces;

% Plotting
disp('DOES NOT HANDLE PROPERLY SLABS THAT OVERLAP');
triplot(bnd.pnt, bnd.tri, mask, 'surface'); 
triplot(bnd.pnt, bnd.tri, mask,'edges');
set(gcf,'name',sprintf('Slabs for subj: %s',subjName));
set(gcf,'color','white')
light('Position',[100 0 0],'Style','infinite');
light('Position',[0 0 100],'Style','infinite');
light('Position',[0 100 0],'Style','infinite');
% lighting gouraud
lighting flat
end