% 05-2012
% Victor Barres
% USC Brain Project
% Script to create the default atalases structure based on FreeSurfer using
% BrainStorm default atlases and MNI_Colin27 brain.

function data_defaultAtlas()

confirm = input('ARE YOU SURE YOU WANT TO CREATE A NEW DEFAULT ATLAS?(yes,no)\n','s');

if ~strcmp(confirm,'yes')
    error('Exit');
end

clear;clc;

listAtlas = {
    'scout_freesurfer_brodmann_15000V';...
    'scout_freesurfer_brodmann_hi-res';...
    'scout_freesurfer_desikan-killiany_15000V';...
    'scout_freesurfer_desikan-killiany_hi-res';...
    'scout_freesurfer_destrieux_15000V';...
    'scout_freesurfer_destrieux_hi-res'};

dataPath = 'data\\';
atlasPath= 'external\\brainStorm\\defaults\\anatomy\\MNI_Colin27';

folder = sprintf('%s%s',dataPath,'atlas');
n = exist(folder,'dir');
if n==0
    mkdir(folder);
end

% Select the atlas to create
v=0;
while v==0
    prompt ='Select the default atlas to create:';
    [atlasIndex,v] = listdlg('PromptString',prompt,...
        'SelectionMode','single',...
        'ListString',listAtlas);
end
atlasName = listAtlas{atlasIndex};
defaultAtlas = load(sprintf('%s\\%s.mat',atlasPath,atlasName));

fileName = sprintf('%s\\%s.mat',folder,atlasName);
n = exist(fileName,'file');
if n==2
    fprintf('This default atlas has already been created\n');
else
    atlas.area = defaultAtlas.Scout;
    atlas.name = atlasName;
    tesselation = defaultAtlas.Tesselation;
    brainModel = tesselation(find(tesselation=='/')+1:end);
    atlas.brainModel = brainModel;
    brain = load(sprintf('%s\\%s',atlasPath,brainModel));
    atlas.brain.Vertices = brain.Vertices;
    atlas.brain.Faces = brain.Faces;
    save(sprintf('%s\\%s',folder,atlasName),'atlas');
    disp_atlas(atlasName);
end
end

