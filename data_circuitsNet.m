% 05-2012
% Victor Barres
% USC Brain Project
% Create the network of brain circuits

function data_circuitsNet(varargin)

if isempty(varargin)
    simName = getSimName();
else
    simName = varargin{1};
end

simPath = sprintf('simulations\\%s',simName);
load(sprintf('%s\\slabs',simPath));
load(sprintf('%s\\dipoles',simPath));
namesBC = dipoles.slabNames;
numBC = length(namesBC);
listOption = namesBC;
netGraph = zeros(numBC);
count = 0;

while count<(numBC-1)
    prompt = 'Choose brain circuit:';
    mode = 'single';    
    option= getOption(listOption,prompt,mode);   
    bcInd = option.ind;
    listOption{bcInd}='-';
    
    mode = 'multiple';
    prompt = 'Choose output brain circuits:';
    option= getOption(listOption,prompt,mode); 
    
    outInd = option.ind;
    
    netGraph(bcInd,outInd)=1;
    
    % Deleting chosen BC from choice
    count = count+length(bcInd);
end

bcGraph = biograph(netGraph);

for i=1:numBC
    bcGraph.Nodes(i).Label = namesBC{i};
end
save(sprintf('%s\\bcGraph',simPath),'bcGraph');
disp_bcGraph(simName);
end
%% Functions
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