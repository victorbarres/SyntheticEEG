% 05-2012
% Victor Barres
% USC Brain Project
% Select an atlas

function atlasName = getAtlasName()

d = dir('data\\atlas');
listAtlas= {d.name};

done = false;
while ~done
    prompt ='Select atlas:';
    option= getOption(listAtlas,prompt,'single');
    done = option.ok;
end
atlasName = listAtlas{option.ind};
end