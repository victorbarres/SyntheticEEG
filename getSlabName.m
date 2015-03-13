% 05-2012
% Victor Barres
% USC Brain Project
% Select slabs

function ansSlab = getSlabName(sim_name)
load(sprintf('simulations\\%s\\slabs', sim_name));
listSlab = {slabs.slab.name};

done = false;
while ~done
    prompt ='Select slab:';
    option = getOption(listSlab,prompt,'multiple');
    done = option.ok;
end
ansSlab.slabName = listSlab(option.ind);
ansSlab.slabIndex = option.ind;
end
