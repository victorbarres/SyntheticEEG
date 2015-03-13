% 05-2012
% Victor Barres
% USC Brain Project
% Select areas in an atlas

function ansArea = getAreaName(atlasName)

load(sprintf('data\\atlas\\%s',atlasName));
listArea = {atlas.area.Label};

% disp('Multiple selections not yet authorized');

done = false;
while ~done
    prompt = 'Select area:';
    option = getOption(listArea,prompt,'multiple');
    done = option.ok;
end
ansArea.areaName = listArea(option.ind);
ansArea.areaIndex = option.ind;
end
