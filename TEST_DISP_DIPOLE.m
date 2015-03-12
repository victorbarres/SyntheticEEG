% 05-2012
% Victor Barres
% USC Brain Project
% Script to display dipoles

function TEST_DISP_DIPOLE(varargin)

if isempty(varargin)
    subjName = getSubjName();
else
    subjName = varargin{1};
end

%% Loading data
path = sprintf('data\\%s',subjName);
load(sprintf('%s\\meshes.mat',path));
load(sprintf('%s\\slabs.mat',path));
load(sprintf('%s\\dipoles.mat',path));

pwddir = pwd;

addpath(sprintf('%s\\external\\display',pwddir)); % To get the arrow function

bnd.pnt = meshes.realMesh(1).Vertices;
bnd.tri = meshes.realMesh(1).Faces;

%% Ploting on brain
sF = input('Scale factor for dipoles ploting(1 for single dipoles):\n');
figure('name',sprintf('Dipole plot for Subj: %s',subjName));
set(gcf,'color','white');
hold;
% ft_plot_mesh(bnd(1),'facealpha',1,'facecolor','w','edgecolor','k','vertexcolor','b');
disp_slab(subjName,1)

for i =1:size(dipoles.dipCoord,1)
    dipCoord = dipoles.dipCoord(i,:);
    dipOrient = dipoles.dipOrient(i,:)*(-1);
    dipLength = dipoles.dipLength(i);
    draw_arrow(dipCoord,dipOrient,dipLength,sF);
end

hold off;
% light('Position',[100 0 0],'Style','infinite');
% light('Position',[0 0 100],'Style','infinite');
% light('Position',[0 100 0],'Style','infinite');

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