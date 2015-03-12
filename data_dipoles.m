% 05-2012
% Victor Barres
% USC Brain Project
% Script to create the dipoles data structure for a subject
% Requires for the subject:
% - meshes
% - slabs

function data_dipoles(varargin)

if isempty(varargin)
    subjName = getSubjName();
    ansSlab = getSlabName(subjName);
    slabName = ansSlab.slabName;
    slabIndex = ansSlab.slabIndex;
elseif length(varargin)==1
    subjName = varargin{1};
    ansSlab = getSlabName(subjName);
    slabName = ansSlab.slabName;
    slabIndex = ansSlab.slabIndex;
else
    subjName = varargin{1};
    slabIndex = varargin{2};
end

%% Loading data
path = sprintf('data\\%s',subjName);
load(sprintf('%s\\slabs.mat',path));
load(sprintf('%s\\meshes.mat',path));

dipoles.slabNames = slabName;
dipoles.slabIndex = slabIndex;
dipoles.density = 1;
dipoles.type = 'single';
dipoles.dip2slab = [];
dipoles.subjName = subjName;
dipoles.dipCoord = [];
dipoles.dipNorm = [];

%% Single dipole or density
fprintf('defining dipole type\n')
listType = {'single dipole', 'distributed dipoles'};
t = getType(listType);
dipoles.type = t;

opt = 0;
if strcmp(t,listType{1})
    disp('THIS OPTION HAS NOT BEEN IMPLEMENTED FOR MULTI AREA SLABS');
    opt = 1;
elseif strcmp(t,listType{2})
    d = inputDensity();
    dipoles.density = d;
    opt = 2;
end
    
%% Getting the depth
fprintf('Defining the depth\n');
depth = inputDepth();
dipoles.depth = depth;

%% Creating the dipoles.=
switch opt
    case 1
        % Single dipole per area
        cortex = meshes.realMesh(1);
        areaList = {};
        vertList = [];
        for i=1:length(slabIndex)
            slabName = dipoles.slabNames{i};
            ind = slabIndex(i);
            areas = {slabs.slab(ind).area2slab.name};
            for j=1:length(areas);
                areaName = areas{j};
                f = strcmp(areaName,areaList);
                if ~isempty(find(f,1))
                    l = length(dipoles.dip2slab(f).names);
                    dipoles.dip2slab(f).names{l+1} = slabName;
                else
                    n = length(areaList)+1;
                    areaList(n) = {areaName};
                    dipoles.dip2slab(n).names = {slabName};
                    v = slabs.slab(ind).area2slab(j).vertNum;
                    list = slabs.slab(ind).vertIndex(v);
                    dip = getDipCoord(cortex,list,dipoles.depth);
                    AvCoord = mean(dip.coord,1);
                    AvOrient = mean(dip.orient,1);
                    SumLength= sum(dip.length);
                    dipoles.dipCoord(n,:) = AvCoord;
                    dipoles.dipOrient(n,:) = AvOrient/norm(AvOrient);
                    dipoles.dipLength(n) = SumLength;
                    dipoles.dipNorm(n,:) = AvOrient*SumLength;
                    vertList = [vertList;list];
                end
            end
        end
        
        dipoles.vertList = vertList;
        
    case 2
        % Dipole density
        vertList = [];
        for i=1:length(slabIndex) % Going through the different slabs
            slabName = dipoles.slabNames{i};
            ind = slabIndex(i);
            v = slabs.slab(ind).vertIndex; % Getting the vertices number for this slab
            for j=1:length(v); % Going through the vertices
                flag = rand<dipoles.density;% Getting the density in
                if flag
                    f = find(vertList==v(j)); % Checking if we already selected this vertex (in another slab)
                    if f
                        dipoles.dip2slab(f).names = {dipoles.dip2slab(f),slabName}; % If yes, add the name of this slab as associated to this dipole
                    else
                        vertList = [vertList;v(j)]; % Otherwise, add this vertex to the list of vertices
                        dipoles.dip2slab(length(dipoles.dip2slab)+1).names = {slabName}; % Extend the dip2slab list.
                    end
                end
            end
        end
        
        cortex = meshes.realMesh(1);
        dip = getDipCoord(cortex,vertList,dipoles.depth); % Generating coordinates and retrieving normal vectors.
        
        dipoles.vertList = vertList;
        dipoles.dipCoord = dip.coord;
        dipoles.dipOrient = dip.orient;
        dipoles.dipLength = dip.length;
        dipoles.dipNorm = dip.norm;
    otherwise
        error('Unknown dipole type');
end

save(sprintf('%s\\dipoles.mat',path),'dipoles');
disp_dipoles(subjName);
end

%% Functions
function dip = getDipCoord(cortex,vertList,depth)
normVect = cortex.vertNorm(vertList,:);
move = zeros(size(normVect));
l = zeros(size(normVect,1),1);
orient = zeros(size(normVect));
for i=1:size(vertList,1)
    l(i) = norm(normVect(i,:));
    orient(i,:) = normVect(i,:)/l(i);
    move(i,:) = depth*orient(i,:); % Have to normalize the normVect
end
coord = cortex.Vertices(vertList,:) + move;
dip.length=l;
dip.orient = orient;
dip.norm = orient.*repmat(l,1,3);
dip.coord = coord;
end

function type = getType(listType)
v=0;
while v==0
    prompt ='Select dipole type:';
    [typeIndex,v] = listdlg('PromptString',prompt,...
        'SelectionMode','single',...
        'ListString',listType);
end
type = listType{typeIndex};
end

function d = inputDensity()
s = {};
while size(s)==0
    prompt = {'Enter dipole density:'};
    dlg_title = 'Dipole density';
    num_lines = 1;
    def = {'e.g. 0.1'};
    options.Resize='on';
    options.WindowStyle='normal';
    s = inputdlg(prompt,dlg_title,num_lines,def,options);
end
d = str2double(s{1});
end

function d = inputDepth()
s = {};
while size(s)==0
    prompt = {'Enter dipole depth in meter:'};
    dlg_title = 'Dipole depth';
    num_lines = 1;
    def = {'0.005'};
    options.Resize='on';
    options.WindowStyle='normal';
    s = inputdlg(prompt,dlg_title,num_lines,def,options);
end
d = str2double(s{1});
end