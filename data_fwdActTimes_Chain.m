% 05-2012
% Victor Barres
% USC Brain Project
% Create a activation times for chain forward processes
% e.g:
% A->B->D->E
% NOTE: Could be extended to divergent forward processes

function data_fwdActTimes_Chain()
disp('ONLY SUPPORTS CHAIN FORWARD PROCESSES A->B->D->E !!')
dataPath = 'data';
subjName = getSubjName();
subjPath = sprintf('%s\\%s',dataPath,subjName);
load(sprintf('%s\\slabs',subjPath));
load(sprintf('%s\\dipoles',subjPath));
slabNames = dipoles.slabNames;

totalDur = input('Total duration in (ms):\n');
timeRes = input('Time resolution (ms):\n');
time = 0:timeRes:totalDur;
fwdActiv.time = time;
fwdActiv.totalDur = totalDur;
fwdActiv.timeRes = timeRes;

s=0;
while ~isempty(slabNames)
    s=s+1;
    slab = getName(slabNames);
    fwdActiv.slabs(s).name = slab{1};
    if s==1
        fwdActiv.slabs(s).inTime = input('Input time (ms):\n');
    else
        inTime = fwdActiv.slabs(s-1).inTime + fwdActiv.slabs(s-1).compTime + fwdActiv.slabs(s-1).transfTime;
        fprintf('Input received from %s at t= %f\n',fwdActiv.slabs(s-1).name,inTime);
        fwdActiv.slabs(s).inTime = inTime;
    end
    fwdActiv.slabs(s).compTime = input('Computation duration (ms):\n');
    fwdActiv.slabs(s).actLevel = input('Activation level:\n');
    fwdActiv.slabs(s).transfTime = input('Transfer time to next slab (ms):\n');
    fwdActiv.slabs(s).boxcar = zeros(length(time),1);
    
    onTime = fwdActiv.slabs(s).inTime;
    offTime = onTime + fwdActiv.slabs(s).compTime;
    on = find(time>=onTime,1,'first');
    off = find(time>=offTime,1,'first');
    
    fwdActiv.slabs(s).boxcar(on:off)=fwdActiv.slabs(s).actLevel;
    
    % Deleting slab from choice
    f = strcmp(slabNames,slab);
    slabNames(f)=[];
end

save(sprintf('%s\\fwdActiv',subjPath),'fwdActiv');
disp_fwdActiv(subjName);
end

%% Functions
function slab = getName(listSlab)
v=0;
while v==0
    prompt ='Select slab:';
    [slabIndex,v] = listdlg('PromptString',prompt,...
        'SelectionMode','single',...
        'ListString',listSlab);
end
slab = listSlab(slabIndex);
end