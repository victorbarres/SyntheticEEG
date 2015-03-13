%% To get the value for an option
function option= getOption(listOption,prompt,mode)
[optionIndex,v] = listdlg('PromptString',prompt,...
        'SelectionMode',mode,...
        'ListString',listOption);
option.ind = optionIndex;
option.name = listOption(optionIndex);
option.ok = v;
end