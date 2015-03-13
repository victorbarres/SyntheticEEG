% 05-2012
% Victor Barres
% USC Brain Project
% Select a mesh

function meshType = getMeshType(sim_name)
sim_path = 'simulations';
load(sprintf('%s\\%s\\meshes',sim_path, sim_name));
listMesh = {meshes.mesh.Comment};
listMesh{length(listMesh)+1} = 'fullhead';
listMesh{length(listMesh)+1} = 'realbrain';

done = false;
while ~done
    prompt ='Select mesh:';
    option = getOption(listMesh, prompt,'single');
    done = option.ok;
end
meshType= listMesh{option.ind};
end
