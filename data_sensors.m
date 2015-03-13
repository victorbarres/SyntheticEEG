% 05-2012
% Victor Barres
% USC Brain Project
% Script to create the sensors data structure for a simulation
% Requires for the simulation:
% - meshes

function data_sensors(varargin)

options  = {'Random sampling', 'Top head', 'Default elec cap'};

if isempty(varargin)
    simName = getSimName();
    choice = getChoice(options,'Select sensor type:','single');
elseif length(varargin)==1
    simName = varargin{1};
    choice = getChoice(options,'Select sensor type:','single');
else
    simName = varargin{1};
    choice = varargin{2};
end

% Loading data
simPath = sprintf('simulations\\%s',simName);
load(sprintf('%s\\meshes.mat',simPath));

headIndex = findMesh(meshes,'head');
head = meshes.mesh(headIndex);

sensors.simName = simName;
sensors.type = options{choice};
sensors.density = 1;

switch choice
    case 1
        d = input('Enter sensors density: \n');
        sensors.density = d;
        sens = getRandSensors(head,d);
        sensors.pos = sens.pos;
        sensors.vertList = sens.vertList; % This is for ease of display
        sensors.mask = sens.mask; % Unused
        sensors.name = {};
    case 2
        thresh = input('Enter z threshold in m (e.g. 0.05): \n');
        sensors.type = 'Top head';
        sensors.thresh= thresh;
        sens = getTopHead(head,thresh);
        sensors.pos = sens.pos;
        sensors.vertList = sens.vertList; % This is for ease of display
        sensors.mask = sens.mask; % Unused
        sensors.name = {};
    case 3
        elecName = getElecName();
        elecPath = 'data\\elec';
        load(sprintf('%s\\%s',elecPath,elecName));
        disp_elec(elecName);
        a =  input('Continue (yes/no)?\n','s');
        if ~strcmp(a,'yes')
            error('Sensor creation aborted');
        end
        
        %% Checking sim and head compatibility
        elecHead = elec.headName;
        elecSim = elec.simName;
        simHead = meshes.fromNames{4};
        
        fprintf('Current sim name: %s\n',simName);
        fprintf('Elec sim name: %s\n',elecSim);
        fprintf('Sim head model: %s\n',simHead);
        fprintf('Elec head model: %s\n',elecHead);       
        if ~strcmp(elecHead,simHead)
            error('Uncompatible elec and simulation');
        end
        
        prompt = 'Choose electrodes:';
        eInd = getElecIndex(elec,prompt);
        sensors.name = {elec.channel(eInd).Name};
        sensors.pos = getElecPos(elec,eInd);
             
    otherwise
        error('Invalid option');
end

save(sprintf('%s\\sensors.mat',simPath),'sensors');
disp_sensors(simName)

end

%% Functions
function choice = getChoice(listChoice,prompt,sMode)
v=0;
while v==0
    [choiceIndex,v] = listdlg('PromptString',prompt,...
        'SelectionMode',sMode,...
        'ListString',listChoice);
end
choice = choiceIndex;
end

function eInd = getElecIndex(elec,prompt)
listChoice = {elec.channel.Name};
eInd = getChoice(listChoice,prompt,'multiple');
end

function sens = getRandSensors(head,d)
sens.pos = [];
sens.vertList = [];
sens.mask = ones(size(head.Vertices,1),1);
for i=1:size(head.Vertices,1)
    if rand<d
        sens.pos = [sens.pos;head.Vertices(i,:)];
        sens.vertList= [sens.vertList;i];
        sens.mask(i) = 2;
    end
end
end

function sens = getTopHead(head,t)
sens.pos = [];
sens.vertList = [];
sens.mask = ones(size(head.Vertices,1),1);
for i=1:size(head.Vertices,1)
    if head.Vertices(i,3)>t
        sens.pos = [sens.pos;head.Vertices(i,:)];
        sens.vertList= [sens.vertList;i];
        sens.mask(i) = 2;
    end
end
end

function pos = getElecPos(elec,eInd)
pos = [];
for i=eInd
    pos = [pos;elec.channel(i).Loc'];
end
end