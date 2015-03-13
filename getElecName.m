% 05-2012
% Victor Barres
% USC Brain Project
% Select an electrode system

function elecName = getElecName()

d = dir('data\\elec');
listElec= {d.name};

done = false;
while ~done
    prompt ='Select electrode system:';
    option = getOption(listElec,prompt,'single');
    done = option.ok;
end
elecName = listElec{option.ind};
end