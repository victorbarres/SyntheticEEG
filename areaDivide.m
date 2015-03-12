% Script to divide a brain area in anterior, middle and posterior.
% NOT A FINAL VERSION!!!!!

function areaDivide(areaName)
disp('THIS IS STILL A VERY AD HOC VERSION!!!!!')
atlasPath = 'data\\atlas';
load (sprintf('%s\\destrieux_15000V_Modified.mat',atlasPath));

f = strcmp({atlas.area.Label},areaName);

area = atlas.area(f);
numArea = length(atlas.area);

vertIndex = area.Vertices;
brain = atlas.brain;

areaCoord= brain.Vertices(vertIndex,:);

%% PCA to reorient the brain along the main axes of the brain region
% Centering
areaCenter = mean(areaCoord,1);
Ctr = repmat(areaCenter,size(areaCoord,1),1);
areaCoord_Ctr = areaCoord - Ctr;
[COEFF,SCORE] = princomp(areaCoord_Ctr);
areaCoord_PCA = areaCoord*COEFF;


% Defined boundaries on the main axis
xMin = min(areaCoord_PCA(:,1));
xMax = max(areaCoord_PCA(:,1));

l = (xMax-xMin)/3;
bnd1 = xMin + l;
bnd2 = bnd1 + l;

brain_PCA = brain;
brain_PCA.Vertices = brain_PCA.Vertices*COEFF;

bnd.pnt = brain_PCA.Vertices;
bnd.tri = brain_PCA.Faces;

ft_plot_mesh(bnd);
set(gcf,'color','white')
axis on
light('Position',[100 0 0],'Style','infinite');
light('Position',[0 0 100],'Style','infinite');
light('Position',[0 100 0],'Style','infinite');
lighting gouraud

outOfBound = min(brain_PCA.Vertices(:,1))-1;
numVert = size(brain.Vertices,1);
i = ones(numVert,1);
i(vertIndex) = 0;
i = logical(i);
coord = brain_PCA.Vertices(:,1); 
coord(i) = outOfBound; % Setting all the irrelevant vertices out of y boundaries.


postInd = find(coord>=xMin & coord<bnd1);
midInd = find(coord>=bnd1 & coord<bnd2);
antInd = find(coord>=bnd2 & coord<=xMax);

% create posterior region
numArea = numArea+1;
newName = [areaName '_posterior'];
atlas.area(numArea) = area;
atlas.area(numArea).Label = newName;
atlas.area(numArea).Vertices = postInd;

% create midle region
numArea = numArea+1;
newName = [areaName '_middle'];
atlas.area(numArea) = area;
atlas.area(numArea).Label = newName;
atlas.area(numArea).Vertices = midInd;

% create anterior region
numArea = numArea+1;
newName = [areaName '_anterior'];
atlas.area(numArea) = area;
atlas.area(numArea).Label = newName;
atlas.area(numArea).Vertices = antInd;

save (sprintf('%s\\destrieux_15000V_Modified.mat',atlasPath),'atlas');
end

