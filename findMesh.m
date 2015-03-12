% Returns the index of a mesh in the Mesh struct

function meshIndex = findMesh(meshes,name)
meshIndex = 0;
for i=1:length(meshes.mesh)
    if strcmp(meshes.mesh(i).Comment,name)
        meshIndex = i;
    end
end

if meshIndex==0
    error('Could not find mesh');
end
end