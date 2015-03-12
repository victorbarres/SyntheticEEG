% 05-2012
% Victor Barres
% USC Brain Project
% Script to create a default mesh structure based on MNI_Colin27 using
% BrainStorm meshes
% The mesh struct contains the various meshes composing the head model.

function data_defaultMesh()

confirm = input('ARE YOU SURE YOU WANT TO CREATE A NEW DEFAULT MESH?(yes,no)\n','s');

if ~strcmp(confirm,'yes')
    error('Exit');
end

clear;clc;

subjName = 'MNI_Colin27';

path1 = 'data\\';
path2 = sprintf('external\\brainStorm\\defaults\\anatomy\\%s\\',subjName);

folder = sprintf('%s%s',path1,subjName);
n = exist(folder,'dir');
if n==0
    mkdir(folder);
end

fileName = sprintf('%s\\meshes.mat',folder);
n = exist(fileName,'file');
if n==2
    fprintf('The default mesh has already been created\n');
else
    meshNames = {'tess_fs_tcortex_15000V.mat','tess_innerskull.mat','tess_outerskull.mat','tess_head.mat'};
    meshes.fromPath = path2;
    meshes.fromNames = meshNames;
    meshes.realMesh = [];
    meshes.cHullMesh = [];
    meshes.name = {};
    meshes.subjName = subjName;
    meshes.coord2MNI = [];
    meshes.coord = '';
    meshes.notes = 'The cHullMesh field defines the convex hull for each real mesh. the mesh fields defines the boundaries.';
    for i=1:length(meshNames)
        m = load(sprintf('%s%s',path2,meshNames{i}));
        [vertNorm,faceNorm,barycenters] = defineNorm(m);
%         normals = defineNorm(m);
        m.vertNorm = vertNorm;
        m.barycenters = barycenters;
        m.faceNorm = faceNorm;
        
        mCHull = m;
        mCHull.Faces = convhull(mCHull.Vertices);
        cleanHull = cleanCHull(mCHull.Faces,mCHull.Vertices);
        mCHull.Vertices = cleanHull.Vertices;
        mCHull.Faces = cleanHull.Faces;
        [vertNorm,faceNorm,barycenters] = defineNorm(mCHull);
%         normals = defineNorm(mCHull);
        mCHull.vertNorm = vertNorm;
        mCHull.barycenters = barycenters;
        mCHull.faceNorm = faceNorm;
        
        
        meshes.realMesh = [meshes.realMesh m];
        meshes.cHullMesh= [meshes.cHullMesh mCHull];
        meshes.name{i} = m.Comment;
    end
    
    % Creating the compartment boundaries
    fprintf('Creating comparment boundaries\n');
    fprintf('The default is:\n brain_convHull\n innerskull_convHull\n outerskull_convHull\n head_real\n');
    meshes.mesh(1) = meshes.cHullMesh(1);
    meshes.mesh(2) = meshes.cHullMesh(2);
    meshes.mesh(3) = meshes.cHullMesh(3);
    meshes.mesh(4) = meshes.realMesh(4);
    
    % Save and display
    save(sprintf('%s\\meshes',folder),'meshes');
    disp_mesh(subjName,'fullhead');
    disp_mesh(subjName,'realbrain');
    
    
    a = input('Would you like to check for downsampling?(yes/no)\n','s');
    if strcmp(a,'yes')
        downSample(meshes,subjName,folder);
    elseif ~strcmp(a,'no')
        error('Wrong input');
    end
end
end

%% Functions
function cleanHull = cleanCHull(Faces,Vertices) % Remove the unused vertices

uniqueVert = unique(Faces);
newVertices = zeros(length(uniqueVert),3);
newFaces = zeros(size(Faces));

for i=1:length(uniqueVert)
    v = uniqueVert(i);
    newVertices(i,:)=Vertices(v,:);
    newFaces(Faces==v)=i;
end

cleanHull.Vertices = newVertices;
cleanHull.Faces = newFaces;
end
