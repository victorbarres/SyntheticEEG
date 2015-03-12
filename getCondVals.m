% 05-2012
% Victor Barres
% USC Brain Project
% Select a conductivity

function cond = getCondVals()

dataPath = 'data';
load(sprintf('%s\\conductivities\\conduct.mat',dataPath));
listCond = {conduct.cond.ref};
v=0;
while v==0
    prompt ='Select the conductivity:';
    [condIndex,v] = listdlg('PromptString',prompt,...
        'SelectionMode','single',...
        'ListString',listCond);
end
cond.index = condIndex;
cond.name = listCond{condIndex};
cond.vals = [mean(conduct.cond(condIndex).val,2)]'; % Here I take the mean value for each tissue.
end