function manualDipoleSelec(varargin)

if isempty(varargin)
    subjName = getSubjName();
else
    subjName = varargin{1};
end

subjPath = sprintf('data\\%s',subjName);

load(sprintf('%s\\dipoles',subjPath));

switch (length(varargin)-1)
    case 1
        dipList = varargin{2};
        magnitude = getMagnitude();
    case 2
        dipList = varargin{2};
        magnitude = varargin{3};
    otherwise
        [dipList,bcSize,density] = getDipList(dipoles);
        fprintf('Surface of the brain circuit selected: %f cm2\n',(bcSize/density)*10^4);
        magnitude = getMagnitude();
end

newDipoles = dipoles;
newDipoles.density = 1;
newDipoles.type = 'Manual';

list = ones(size(dipoles.vertList));
list(dipList) = 0;
list = logical(list);

newDipoles.dip2slab(list) = [];
newDipoles.dipCoord(list,:) = [];
newDipoles.dipNorm(list,:) = [];
newDipoles.vertList(list) = [];
newDipoles.dipOrient(list,:) = [];
newDipoles.dipLength(list) = [];

newDipoles.dipLength = repmat(magnitude,size(newDipoles.dipLength));
newDipoles.dipNorm = newDipoles.dipOrient.*repmat(newDipoles.dipLength,1,3);

save(sprintf('%s\\OldDipoles',subjPath),'dipoles');
dipoles = newDipoles;
save(sprintf('%s\\dipoles',subjPath),'dipoles');
end

%% SubFunctions
function [ind,bcSize,density] = getDipList(dipoles)

bcSize = 0;

for i=1:size(dipoles.vertList,1)
listOption{i} = int2str(i);
bcSize = bcSize + dipoles.dipLength(i);
end

density = dipoles.density;
prompt = 'Choose your dipoles:';
mode = 'multiple';
option = getOption(listOption,prompt,mode);
ind = option.ind;
end

function val = getMagnitude()
p = 'Enter dipole magnitude in cm2:';
t = 'Magnitude';
d = '3';
val = getInput(p,t,d);
val = val*10^-4;
end