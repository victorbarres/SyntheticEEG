% 05-2012
% Victor Barres
% USC Brain Project
% Select an electrode system

function elecName = getElecName()

d = dir('data\\elec');
listElec= {d.name};

v=0;
while v==0
    prompt ='Select electrode system:';
    [elecIndex,v] = listdlg('PromptString',prompt,...
        'SelectionMode','single',...
        'ListString',listElec);
end
elecName = listElec{elecIndex};
end