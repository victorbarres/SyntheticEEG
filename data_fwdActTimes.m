% 05-2012
% Victor Barres
% USC Brain Project
% Create a activation times for a given brain circuit graph.

function data_fwdActTimes(varargin)

if isempty(varargin)
    subjName = getSubjName();
else
    subjName = varargin{1};
end

dataPath = 'data';
subjPath = sprintf('%s\\%s',dataPath,subjName);
load(sprintf('%s\\slabs',subjPath));
load(sprintf('%s\\dipoles',subjPath));
load(sprintf('%s\\bcGraph',subjPath));

namesBC = dipoles.slabNames;

totalDur = input('Total duration in (ms):\n');
timeRes = input('Time resolution (ms):\n');
time = 0:timeRes:totalDur;
fwdActiv.time = time;
fwdActiv.totalDur = totalDur;
fwdActiv.timeRes = timeRes;

prompt = 'Choose input brain circuit:';
mode = 'single';
option= getOption(namesBC,prompt,mode);
trav = bcGraph.traverse(option.ind,'Method','BFS');
t0 = input('Input time (ms):\n');
init = trav(1);
newBoxcar = zeros(length(time),1);

for t=trav
    name = namesBC{t};
    fprintf('Brain circuit: %s\n',name);
    fwdActiv.brainCircuit(t).name = name;
    if t~=init
        ancNodes = getancestors(bcGraph.Nodes(t),1);
        set(ancNodes(1),'Color',[.7 .7 1]);
        set(ancNodes(2:end),'Color',[1 .7 .7]);
%         bcGraph.view;
        
        actOpt = input('Choose activation option: 1-CONTINUOUS 2-SERIAL:\n');
        inComb = input('Choose information combination option: 1-AND 2-OR:\n');
        bcGraph.Nodes(t).userData.actOpt = actOpt;
        bcGraph.Nodes(t).userData.inComb = inComb;
        
        numAnc = length(ancNodes);
        switch actOpt
            case 1
                inTimes = [];
                outTimes = [];
                for p=1:numAnc
                    if ~strcmp(name,ancNodes(p).Label)
                        inTimes = [inTimes; ancNodes(p).UserData.inTime + ancNodes(p).UserData.transfTime];
                        outTimes = [outTimes; ancNodes(p).UserData.outTime + ancNodes(p).UserData.transfTime];
                    end
                end
                switch inComb
                    case 1
                        disp('Continuous AND');
                        disp('inTime = max[inTime(bc-1) + transfTime(bc-1)]');
                        inTime = max(inTimes); 
                        
                        disp('outTime = min[outTime(bc-1) + transfTime(bc-1)]');
                        outTime = min(outTimes);
                    case 2
                        disp('Continuous OR');
                        disp('inTime = min[inTime(bc-1) + transfTime(bc-1)]');
                        inTime = min(inTimes);  
                        
                        disp('outTime = nax[outTime(bc-1) + transfTime(bc-1)]');
                        outTime = max(outTimes);
                        
                    otherwise
                        error('Bad input combination option');
                end
                compTime=outTime-inTime;
            case 2
                inTimes = [];
                for p=1:numAnc                   
                    if ~strcmp(name,ancNodes(p).Label)
                        inTimes = [inTimes; ancNodes(p).UserData.outTime + ancNodes(p).UserData.transfTime];
                    end
                end
                switch inComb
                    case 1
                        disp('Serial AND');
                        disp('inTime = max[outTime(bc-1) + transfTime(bc-1)]');
                        inTime = max(inTimes); 
                    case 2
                        disp('Serial OR');
                        disp('inTime = min[outTime(bc-1) + transfTime(bc-1)]');
                        inTime = min(inTimes); 
                    otherwise
                        error('Bad input combination option');
                end               
                    compTime = input('Computation duration (ms):\n');
                    outTime = inTime +compTime;
            otherwise
                error('Bad input timing option');
        end       
        actLevel = input('Activation level:\n');
        transfTime = input('Transfer time to next slab (ms):\n');
        
        bcGraph.Nodes(t).userData.inTime = inTime;
        bcGraph.Nodes(t).userData.outTime = outTime;
        bcGraph.Nodes(t).userData.compTime = compTime;
        bcGraph.Nodes(t).userData.transfTime = transfTime;
        bcGraph.Nodes(t).userData.actLevel = actLevel;
        
        set(ancNodes,'Color',[1 1 .7]);        
    else
        bcGraph.Nodes(t).userData.inTime = t0;
        bcGraph.Nodes(t).userData.compTime = input('Computation duration (ms):\n');
        bcGraph.Nodes(t).userData.outTime = t0 + bcGraph.Nodes(t).userData.compTime;
        bcGraph.Nodes(t).userData.actLevel = input('Activation level:\n');
        bcGraph.Nodes(t).userData.transfTime = input('Transfer time to next slab (ms):\n');
        

    end
    
    fwdActiv.brainCircuit(t).inTime = bcGraph.Nodes(t).userData.inTime;
    fwdActiv.brainCircuit(t).outTime = bcGraph.Nodes(t).userData.outTime;
    fwdActiv.brainCircuit(t).compTime = bcGraph.Nodes(t).userData.compTime;
    fwdActiv.brainCircuit(t).transfTime = bcGraph.Nodes(t).userData.transfTime;
    fwdActiv.brainCircuit(t).actLevel = bcGraph.Nodes(t).userData.actLevel;
    
    fwdActiv.brainCircuit(t).boxcar = newBoxcar;
    
    onTime = fwdActiv.brainCircuit(t).inTime;
    offTime = onTime + fwdActiv.brainCircuit(t).compTime;
    on = find(time>=onTime,1,'first');
    off = find(time>=offTime,1,'first');
    fwdActiv.brainCircuit(t).boxcar(on:off)=fwdActiv.brainCircuit(t).actLevel;
    
    bcGraph.Nodes(t).userData.boxcar = fwdActiv.brainCircuit(t).boxcar;    
end

save(sprintf('%s\\fwdActiv',subjPath),'fwdActiv');
save(sprintf('%s\\bcGraph',subjPath),'bcGraph');
disp_fwdActiv(subjName);
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