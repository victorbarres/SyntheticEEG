% 05-2012
% Victor Barres
% USC Brain Project
% Select areas in an atlas

function ansArea = getAreaName(atlasName)

load(sprintf('data\\atlas\\%s',atlasName));
listArea = {atlas.area.Label};

% disp('Multiple selections not yet authorized');

v=0;
while v==0
    prompt ='Select area:';
    [areaIndex,v] = listdlg('PromptString',prompt,...
        'SelectionMode','multiple',...
        'ListString',listArea);
end
ansArea.areaName = listArea(areaIndex);
ansArea.areaIndex = areaIndex;
end
