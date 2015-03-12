% 05-2012
% Victor Barres
% USC Brain Project
% Select a subject name

function subjName = getSubjName()

d = dir('data');
listSubj= {d.name};

v=0;
while v==0
    prompt ='Select subject:';
    [subjIndex,v] = listdlg('PromptString',prompt,...
        'SelectionMode','single',...
        'ListString',listSubj);
end
subjName = listSubj{subjIndex};
end