% 05-2012
% Victor Barres
% USC Brain Project
% Select a subject name

function sedName = getSedName()

d = dir('data\\SEDs');
listSED= {d.name};

v=0;
while v==0
    prompt ='Select SED:';
    [sedIndex,v] = listdlg('PromptString',prompt,...
        'SelectionMode','single',...
        'ListString',listSED);
end
sedName = listSED{sedIndex};
end