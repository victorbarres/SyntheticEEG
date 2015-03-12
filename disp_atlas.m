% 05-2012
% Victor Barres
% USC Brain Project
% Script to display atlases

function disp_atlas(varargin)

if isempty(varargin)
    atlasName = getAtlasName();
    ansArea = getAreaName(atlasName);
    areaName = ansArea.areaName;
    areaIndex = ansArea.areaIndex;
else
    atlasName = varargin{1};
    areaIndex = varargin{2};
end

dataPath = 'data';
atlasPath = sprintf('%s\\atlas',dataPath);
load(sprintf('%s\\%s',atlasPath,atlasName));
brain = atlas.brain;

if areaIndex==0
    areaIndex = 1:length(atlas.area); % Select all the areas
end

numArea = length(areaIndex);
cmap = colormap(hsv(numArea));
cmap = [cmap;[1,1,1]];
colormap(cmap);

%Create mask
numVertices = size(brain.Vertices,1);
mask = ones(numVertices,1)*(numArea+1); % Color of the brain outside the defined areas.
c=1;
for i=areaIndex
    mask(atlas.area(i).Vertices) = c;
    c=c+1;
end

bnd.pnt = brain.Vertices;
bnd.tri = brain.Faces;

triplot(bnd.pnt,bnd.tri,mask,'surface');
set(gcf,'name',atlasName);
set(gcf,'color','white')
light('Position',[100 0 0],'Style','infinite');
light('Position',[0 0 100],'Style','infinite');
light('Position',[0 100 0],'Style','infinite');
lighting gouraud
end
