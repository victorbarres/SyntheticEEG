% 05-2012
% Victor Barres
% USC Brain Project
% Select a conductivity

function cond = getCondVals()

dataPath = 'data';
load(sprintf('%s\\conductivities\\conduct.mat',dataPath));
listCond = {conduct.cond.ref};

done = false;
while ~done
    prompt ='Select the conductivity:';
    option= getOption(listCond,prompt,'single');
    done = option.ok;
end
cond.index = option.ind;
cond.name = listCond{option.ind};
cond.vals = [mean(conduct.cond(option.ind).val,2)]'; % Here I take the mean value for each tissue.
end