% 06-2012
% Victor Barres
% USC Brain Project
% Script to find the most positive and most negative electrodes for a given lead field


function field2elec(varargin)

if isempty(varargin)
    simName = getSimName;
else
    simName = varargin{1};
end

dataPath = 'data';
simPath = 'simulations';
simFolder = sprintf('%s\\%s',simPath,simName);
elecPath = sprintf('%s\\elec',dataPath);

load(sprintf('%s\\leadfield',simFolder));
lf = leadfield.lf;
lf = lf-mean(lf);
disp('Reference for lead field is taken as the average potential');
if strcmp(leadfield.sensType,'Default elec cap')   
    [potMax,indMax] = max(lf);
    [potMin,indMin] = min(lf);
    nameMax = leadfield.sensName{indMax};
    nameMin = leadfield.sensName{indMin};
    
elseif strcmp(leadfield.sensType,'Top head')
    if length(varargin)==2
        elecName = varargin{2};
    else
        elecName = getElecName();
    end
    
    load(sprintf('%s\\%s',elecPath,elecName));
    loc = {elec.channel.Loc};
    names = {elec.channel.Name};
    numElec = length(names);
    elecLF = zeros(length(numElec),1);
    for i=1:numElec
        ind = nearestSens(loc{i}',leadfield.sensPos);
        elecLF(i) = lf(ind);
    end
    [potMax,indMax] = max(elecLF);
    [potMin,indMin] = min(elecLF);
    nameMax = names{indMax};
    nameMin = names{indMin};
else
    error('Unknown sensor type');
end

fprintf('Min potential = %f at electrode %s\n',potMin,nameMin);
fprintf('Max potential = %f at electrode %s\n',potMax,nameMax);
end


%% SubFunctions

function ind = nearestSens(loc,sensPos)
numSens = size(sensPos,1);
dist = zeros(size(sensPos,1),1);
for i=1:numSens
    dist(i)= norm(sensPos(i,:)-loc);
end

[~,ind] = min(dist);
end