% 05-2012
% Victor Barres
% USC Brain Project
% Script to display a lead field

function disp_leadfield(varargin)

disp('THIS VERSION ONLY PLOTS THE LEADFIELD FOR A RANDOM OR TOP OF HEAD LEADFIELD!!!')
disp('FOR EACH DIPOLE THE REFERENCE POTENTIAL IS THE AVERAGE LEADFIELD OF THE DIPOLE!!!')
disp('FOR THE TOTAL LEADFIELD, THE REFERENCE POTENTIAL IS THE AVERAGE LEADFIELD!!!')

if isempty(varargin)
    simName = getSimName();
    path = sprintf('simulations\\%s\\',simName);
    load(sprintf('%s\\dipoles.mat',path));
    dipList = getDipList(dipoles);
else
    simName = varargin{1};
    dipList = varargin{2};
    path = sprintf('simulations\\%s\\',simName);
    load(sprintf('%s\\dipoles.mat',path));
end

load(sprintf('%s\\grid.mat',path));
load(sprintf('%s\\meshes.mat',path));
% load(sprintf('%s\\dipoles.mat',path));
load(sprintf('%s\\sensors.mat',path));

dipNorm = dipoles.dipNorm;
head = meshes.mesh(4);

%% Display leadfield for each dipole
leadfield = zeros(size(grid.leadfield{1},1),1);
% numFields = length(grid.leadfield);
numFields = length(dipList);
figure;
nR = floor(sqrt(numFields));
nC = ceil(numFields/nR);
for j=1:numFields
    i = dipList(j);
    N = dipNorm(i,:)';
    dipLf = grid.leadfield{i}*N;
    leadfield = leadfield + dipLf;
    % create mask
    meanVal = mean(dipLf); % Setting reference point
    dipLfCenter = dipLf-meanVal; % Centering the data
    
%     mask = ones(size(head.Vertices,1),1)*meanVal;
    mask = zeros(size(head.Vertices,1),1);
    mask(sensors.vertList) = dipLfCenter;
    subplot(nR,nC,j);
    triplot(head.Vertices, head.Faces, mask, 'surface');
    set(gcf,'color','white');
    set(gcf,'name','Dipoles fields');
    title(sprintf('D%i',i));
end

%% Display total leadfield
meanVal = mean(leadfield); % Setting reference point
leadfieldCenter = leadfield-meanVal; % Centering the data

% mask = ones(size(head.Vertices,1),1)*meanVal;
mask = zeros(size(head.Vertices,1),1);
mask(sensors.vertList) = leadfieldCenter;

figure;
triplot(head.Vertices, head.Faces, mask, 'surface');
set(gcf,'color','white');
set(gcf,'name','Total lead field');
end

function dipList = getDipList(dipoles)
for i=1:length(dipoles.dipCoord)
    listOption{i} = int2str(i);
end
prompt = 'Pick dipoles:';
mode = 'multiple';
option = getOption(listOption,prompt,mode);
dipList = option.ind;
end