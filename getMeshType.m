% 05-2012
% Victor Barres
% USC Brain Project
% Select a mesh

function meshType = getMeshType(subjName)

load(sprintf('data\\%s\\meshes',subjName));
listMesh = {meshes.mesh.Comment};
listMesh{length(listMesh)+1} = 'fullhead';
listMesh{length(listMesh)+1} = 'realbrain';

v=0;
while v==0
    prompt ='Select mesh:';
    [meshIndex,v] = listdlg('PromptString',prompt,...
        'SelectionMode','single',...
        'ListString',listMesh);
end
meshType= listMesh{meshIndex};
end
