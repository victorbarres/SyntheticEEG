%% To get the value for an option
function option= getOption(listOption,prompt,mode)
v=0;
while v==0
   [optionIndex,v] = listdlg('PromptString',prompt,...
        'SelectionMode',mode,...
        'ListString',listOption);
end
option.ind = optionIndex;
option.name = listOption(optionIndex);
end