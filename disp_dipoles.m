% 05-2012
% Victor Barres
% USC Brain Project
% Script to display the dipoles

function disp_dipoles(varargin)

if isempty(varargin)
    simName = getSimName();
else
    simName = varargin{1};
end

%% Loading data
path = sprintf('simulations\\%s',simName);
load(sprintf('%s\\meshes.mat',path));
load(sprintf('%s\\slabs.mat',path));
load(sprintf('%s\\dipoles.mat',path));

pwddir = pwd;

addpath(sprintf('%s\\external\\display',pwddir)); % To get the arrow function

bnd(1).pnt = meshes.realMesh(1).Vertices;
bnd(1).tri = meshes.realMesh(1).Faces;

bnd(2).pnt = meshes.mesh(1).Vertices;
bnd(2).tri = meshes.mesh(1).Faces;

% %% Creating mask for the dipoles
% mask = ones(size(meshes.mesh(1).Vertices,1),1);
% mask(dipoles.vertList) = 2;

% %% Ploting on real brain
% figure('name',sprintf('Dipole plot for Sim: %s',simName));
% set(gcf,'color','white');
% hold;
% ft_plot_mesh(bnd(1));
% triplot(bnd(1).pnt, bnd(1).tri, mask, 'surface');
% for i =1:size(dipoles.dipCoord,1)
%     dipCoord = dipoles.dipCoord(i,:);
%     dipNorm = dipoles.dipNorm(i,:);
%     draw_arrow(dipCoord,dipNorm);
% end
% 
% hold off;
% light('Position',[100 0 0],'Style','infinite');
% light('Position',[0 0 100],'Style','infinite');
% light('Position',[0 100 0],'Style','infinite');
% lighting phong;

%% Ploting on brain hull
sF = input('Scale factor for dipoles ploting(1 for single dipoles):\n');
figure('name',sprintf('Dipole plot for Sim: %s',simName));
set(gcf,'color','white');
hold;
ft_plot_mesh(bnd(2),'facealpha',0,'facecolor','w');
for i =1:size(dipoles.dipCoord,1)
    dipCoord = dipoles.dipCoord(i,:);
    dipOrient = dipoles.dipOrient(i,:);
    dipLength = dipoles.dipLength(i);
    draw_arrow(dipCoord,dipOrient,dipLength,sF);
end

hold off;
light('Position',[100 0 0],'Style','infinite');
light('Position',[0 0 100],'Style','infinite');
light('Position',[0 100 0],'Style','infinite');
lighting phong;

end

%% Functions
function draw_arrow(dipCoord,dipOrient,dipLength,sF)
pos1 = dipCoord;
pos2 = pos1 + dipOrient*sqrt(dipLength)*sF;
Start = pos1;
End = pos2;
tipProp = 0.5;
tipWidth = 1;
color ='r';
arrow(Start,End,tipProp,tipWidth,color)
end