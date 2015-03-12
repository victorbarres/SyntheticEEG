% 05-2012
% Victor Barres
% USC Brain Project
% Create dA for each area.

function data_dA(varargin)

if isempty(varargin)
    subjName = getSubjName();
else
    subjName = varargin{1};
end

dataPath = 'data';
subjPath = sprintf('%s\\%s',dataPath,subjName);
load(sprintf('%s\\ERPdAVal',subjPath));

totalDur = ERPdAVal.totalDur;
timeRes = ERPdAVal.timeRes;
time = 0:timeRes:totalDur*2;
activ.time = time;
activ.totalDur = totalDur;
activ.timeRes = timeRes;


% Defininin the reference gamma function

maxTime = 2;
minTime = 0;
numPoints = 100000; % High res gamma function.
res = (maxTime-minTime)/numPoints;
gammaTime = minTime:res:maxTime;
mean = 0.4;
std = 0.2;
var = std^2;
% Note: mean = k*theta, var = k*theta^2
theta = var/mean;
k = mean/theta;
gammaRef= gampdf(gammaTime,k,theta);
gammaRef = gammaRef/max(gammaRef);

% Defining the dA values
newdA = zeros(length(time),1);
for i =1:length(ERPdAVal.area)
    activ.area(i).name = ERPdAVal.area(i).name;
    activ.area(i).inputTime = ERPdAVal.area(i).inputTime;
    activ.area(i).computationTime = ERPdAVal.area(i).computationTime;
    activ.area(i).outputTime = ERPdAVal.area(i).outputTime;
    activ.area(i).activityLevel = ERPdAVal.area(i).activityLevel;
    activ.area(i).dA = newdA;
    activ.area(i).boxcar = newdA;
    
    onTime = activ.area(i).inputTime;
    offTime = activ.area(i).outputTime;
    on = find(time>=onTime,1,'first');
    off = find(time>=offTime,1,'first');
    activ.area(i).boxcar(on:off) = activ.area(i).activityLevel;
    
    cpTime = activ.area(i).computationTime;
    L = cpTime*2;
    step = floor(numPoints/L);
    ind = 1:step:numPoints;
    dA = gammaRef(ind);
    activ.area(i).dA(on:on+length(dA)-1) = dA*activ.area(i).activityLevel; 
end

save(sprintf('%s\\activ',subjPath),'activ');
disp_areadA(subjName);
end