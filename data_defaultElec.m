% 05-2012
% Victor Barres
% USC Brain Project
% Script to create the default electrodes structure based on FreeSurfer using
% BrainStorm default EEG elec pos and MNI_Colin27 brain.

function data_defaultElec()

confirm = input('ARE YOU SURE YOU WANT TO CREATE A NEW DEFAULT ELECTRODE DATA?(yes,no)\n','s');

if ~strcmp(confirm,'yes')
    error('Exit');
end

clear;clc;

subjName = 'MNI_Colin27';
dataPath = 'data\\';
defaultPath = 'external\\brainStorm\\defaults';
elecPath = sprintf('%s\\eeg\\%s',defaultPath,subjName);
d = dir(elecPath);
listElec= {d.name};

folder = sprintf('%s%s',dataPath,'elec');
n = exist(folder,'dir');
if n==0
    mkdir(folder);
end

% Select the elec to create
v=0;
while v==0
    prompt ='Select the default electrode system to create:';
    [elecIndex,v] = listdlg('PromptString',prompt,...
        'SelectionMode','single',...
        'ListString',listElec);
end
elecName = listElec{elecIndex};
defaultElec = load(sprintf('%s\\%s',elecPath,elecName));

%Loading head
headName = 'tess_head.mat';
defaultHead = load(sprintf('%s\\anatomy\\%s\\%s',defaultPath,subjName,headName));

fileName = sprintf('%s\\%s.mat',folder,elecName);
n = exist(fileName,'file');
if n==2
    fprintf('This default electrode system has already been created\n');
else
    
    res = input('Enter resolution in m:\n');
    elec.channel = defaultElec.Channel;
    elec.comment = defaultElec.Comment;
    elec.subjName = subjName;
    elec.headName = headName;
    elec.elecName = elecName;
    elec.head.Vertices = defaultHead.Vertices;
    elec.head.Faces = defaultHead.Faces;
    f =  createFields(defaultHead,defaultElec,res); % I could remove/improve that,it might be useful to measure on a few vertices rather than on 1 point.
    elec.res = res;
    elec.mask = f.mask;
    elec.elec2head = f.elec2head;
    save(sprintf('%s\\%s',folder,elecName),'elec');
    disp_elec(elecName);
end

end

%% Functions
function f = createFields(head,elec,res)
f.mask= zeros(size(head.Vertices,1),1);
for e=1:length(elec.Channel)
    f.elec2head(e).name = elec.Channel(e).Name;
    loc = elec.Channel(e).Loc';
    ind = findNearestPnt(head.Vertices,loc,res);
    f.elec2head(e).vertIndex = ind;
    f.mask(ind)=1;
end
end

% Find pnt such as dist(pnt,loc)<=res
function ind = findNearestPnt(pnt,loc,res)
n = size(pnt,1);
dist = zeros(n,1);
for i=1:n
    dist(i) = norm(pnt(i,:)-loc);
end
ind = find(dist<=res);
end