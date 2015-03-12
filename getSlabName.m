% 05-2012
% Victor Barres
% USC Brain Project
% Select slabs

function ansSlab = getSlabName(subjName)

load(sprintf('data\\%s\\slabs',subjName));
listSlab = {slabs.slab.name};

v=0;
while v==0
    prompt ='Select slab:';
    [slabIndex,v] = listdlg('PromptString',prompt,...
        'SelectionMode','multiple',...
        'ListString',listSlab);
end
ansSlab.slabName = listSlab(slabIndex);
ansSlab.slabIndex = slabIndex;
end
