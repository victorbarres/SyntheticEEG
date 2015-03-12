% 05-2012
% Victor Barres
% USC Brain Project
% Script to display electrodes

function disp_elec(varargin)

if isempty(varargin)
    elecName = getElecName();
else
    elecName = varargin{1};
end

dataPath = 'data';
elecPath = sprintf('%s\\elec',dataPath);
load(sprintf('%s\\%s',elecPath,elecName));

prompt = 'Choose electrodes to plot:';
eInd = getElecIndex(elec,prompt);

bnd.pnt = elec.head.Vertices;
bnd.tri = elec.head.Faces;

pos = {elec.channel.Loc};

pos = pos(eInd);
figure;
hold;
ft_plot_mesh(bnd,'facealpha',1,'facecolor','b');
plotElec(pos)
set(gcf,'name',elecName);
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
for p=1:length(pos);
    center = pos{p}';
    bnd.pnt = pnt + repmat(center,n,1);
    bnd.tri = tri;
    ft_plot_mesh(bnd,'facealpha',1,'facecolor','r');
end
end

function eInd = getElecIndex(elec,prompt)
listChoice = {elec.channel.Name};
e = getOption(listChoice,prompt,'multiple');
eInd = e.ind;
end

function option= getOption(listOption,prompt,mode)
v=0;
while v==0
   [optionIndex,v] = listdlg('PromptString',prompt,...
        'SelectionMode',mode,...
        'ListString',listOption);
end
option.ind = optionIndex;
option.name = listOption(optionIndex);
end