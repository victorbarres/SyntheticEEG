% 05-2012
% Victor Barres
% USC Brain Project
% Select a subject name

function sedName = getSedName()

d = dir('data\\SEDs');
listSED= {d.name};

done = false;
while ~done
    prompt ='Select SED:';
    option = getOption(listSED,prompt,'single');
    done = option.ok;
end
sedName = listSED{option.ind};
end