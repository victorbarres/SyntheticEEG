% 05-2012
% Victor Barres
% USC Brain Project
% Script to create the impulse response function.


function data_IRF(varargin)

if isempty(varargin)
    simName = getSimName;
else
    simName = varargin{1};
end

simPath = sprintf('simulations\\%s',simName);
load(sprintf('%s\\fwdActiv',simPath));

time = fwdActiv.time;
timeRes = time(2)-time(1);

listOption = {'None', 'Gamma', 'Gaussian'};
prompt = 'Choose impulse function:';
option = getOption(listOption,prompt);
impChoice = option.ind;

switch impChoice
    case 1
        fprintf('Boxcar function will be used as source waveform\n');
        impTime = time;
        impulseF = ones(length(time),1);
        param = [];
    case 2
        disp('NOTE: choose var<mean^2');  
        mean = input('Input mean of Gamma function in ms (default 50 ms):\n');
        std = input('Input std of Gamma function in ms(default 10 ms):\n');
        var = std^2;
        % Note: mean = k*theta, var = k*theta^2
        theta = var/mean;
        k = mean/theta;
        impTime = 0:timeRes:(mean+var*2);
        impulseF = gampdf(impTime,k,theta);
        param = [mean,std];
      
    case 3
        mean = input('Input mean of Gaussian function in (ms):\n');
        std = input('Input std of Gaussian function in (ms):\n');
        var = std^2;
        impTime = (mean-var*4):timeRes:(mean+var*4);
        impulseF = normpdf(impTime,mean,std);
        param = [mean,std];
    otherwise
        error('Unknown choice')
end

IRF.type = option.name;
IRF.f = impulseF;
IRF.impTime = impTime;
IRF.param = param;

save(sprintf('%s\\IRF',simPath),'IRF');
disp_IRF(simName);
end

%% Functions
function option= getOption(listOption,prompt)
v=0;
while v==0
   [optionIndex,v] = listdlg('PromptString',prompt,...
        'SelectionMode','single',...
        'ListString',listOption);
end
option.ind = optionIndex;
option.name = listOption{optionIndex};
end