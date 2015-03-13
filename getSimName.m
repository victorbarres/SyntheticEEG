% 05-2012
% Victor Barres
% USC Brain Project
% Select a simulation name

function simName = getSimName()

d = dir('simulations');
listSim= {d.name};

done = false;
while ~done
    prompt ='Select simulation:';
    option = getOption(listSim,prompt,'single');
    done = option.ok;
end
simName = listSim{option.ind};
end