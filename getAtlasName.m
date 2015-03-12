% 05-2012
% Victor Barres
% USC Brain Project
% Select an atlas

function atlasName = getAtlasName()

d = dir('data\\atlas');
listAtlas= {d.name};

v=0;
while v==0
    prompt ='Select atlas:';
    [atlasIndex,v] = listdlg('PromptString',prompt,...
        'SelectionMode','single',...
        'ListString',listAtlas);
end
atlasName = listAtlas{atlasIndex};
end