% 05-2012
% Victor Barres
% USC Brain Project
% Script to display the sensors

function disp_sensors(varargin)

if isempty(varargin)
    subjName = getSubjName();
else
    subjName = varargin{1};
end

% Loading data
path = sprintf('data\\%s',subjName);
load(sprintf('%s\\meshes.mat',path));
load(sprintf('%s\\sensors.mat',path));

headIndex = findMesh(meshes,'head');

bnd.pnt = meshes.mesh(headIndex).Vertices;
bnd.tri = meshes.mesh(headIndex).Faces;

pos = sensors.pos;

figure;
hold;
ft_plot_mesh(bnd,'facealpha',1,'facecolor','w');
plotElec(pos)
set(gcf,'name',sprintf('Sensors for %s: ',subjName));
set(gcf,'color','white')
light('Position',[100 0 0],'Style','infinite');
light('Position',[0 0 100],'Style','infinite');
light('Position',[0 100 0],'Style','infinite');
lighting gouraud
end

%% Functions
function plotElec(pos)
[pnt, tri] = icosahedron42;
n = size(pnt,1);
pnt = pnt./200;
for p=1:size(pos,1);
    center = pos(p,:);
    bnd.pnt = pnt + repmat(center,n,1);
    bnd.tri = tri;
    ft_plot_mesh(bnd,'facealpha',1,'facecolor','r');
end
end