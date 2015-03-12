% 05-2012
% Victor Barres
% USC Brain Project
% Create dA for each area.
% This version uses the best gamma fit on Scherg for the dA shape.
% gamma: [0,1]->[0,1] mean = 0.4, std = 0.2;

function data_dA2(varargin)

if isempty(varargin)
    subjName = getSubjName();
else
    subjName = varargin{1};
end

dataPath = 'data';
subjPath = sprintf('%s\\%s',dataPath,subjName);
load(sprintf('%s\\ERPdAVal',subjPath));
load(sprintf('%s\\SEDs\\ERPShape\\Gamma',dataPath));

totalDur = ERPdAVal.totalDur;
timeRes = gamma.res;
time = 0:timeRes:totalDur*2;
activ.time = time;
activ.totalDur = totalDur;
activ.timeRes = timeRes;


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
    
    maxTime =gamma.time(end);
    minTime = gamma.time(1);
    
    scale = cpTime/gamma.cpTimeRef;
    numPoint = ceil(gamma.numPoints*scale);
    res = (maxTime-minTime)/numPoint;
    
    gammaTime =  minTime:res:maxTime;
    theta = gamma.theta;
    k = gamma.k;
    f = gampdf(gammaTime,k,theta);
    f = f/max(f);
    activ.area(i).dA(on:on+length(f)-1) = f*activ.area(i).activityLevel;
    activ.area(i).dA = activ.area(i).dA(1:length(time));
end

save(sprintf('%s\\activ',subjPath),'activ');
disp_areadA(subjName);
end