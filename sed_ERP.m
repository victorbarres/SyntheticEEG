% 2012-06
% Victor Barres
% USC Brain Project
% This script returns and plots ERP from SEDs

function ERP = sed_ERP(varargin)

if isempty(varargin)
    sedName = getSedName();
    condName = getCondName(sedName);
else
    sedName = varargin{1};
    condName = varargin{2};
end

sedPath = sprintf('data\\SEDs\\%s',sedName);
load(sprintf('%s\\Electrodes',sedPath));
load(sprintf('%s\\ElecSingle',sedPath));
load(sprintf('%s\\Time',sedPath));
load(sprintf('%s\\%s',sedPath,condName));

% Pick electrodes
fprintf('HERE ARE THE COMPONENTS AND THE MOST SIGNIFICANT ELECTRODES\n');
disp({ElecSingle.ERP});
disp({ElecSingle.elec});

prompt = 'Pick electrode';
listElec = Electrodes;
mode = 'single';
option = getOption(listElec,prompt,mode);
elecName = option.name{1};
f = strcmp(Electrodes,elecName);
find(f==1)
timeCourse = record(f,:)';

ERP.timeCourse = timeCourse;
ERP.time = Time;
ERP.elecName = elecName;
ERP.sedName = sedName;
ERP.condName = condName;

figure;
hold;
plot(Time,timeCourse,'Color', 'blue', 'LineWidth', 2);
set(gcf,'color','white');
title(sprintf('%s, %s, %s',elecName, condName, sedName));
xlabel('Time (ms)'); ylabel('Potential (microV)');

polyOrder = 4;
fprintf('ERP fitted with a polynomial\n');
fprintf('Poly order %i\n',polyOrder);
[P,S,MU] = polyfit(Time,timeCourse,10);
f = polyval(P,Time,S,MU);
plot(Time,f,'Color', 'red', 'LineWidth', 2);

legend('Real',sprintf('Poly order %i',polyOrder));

ERP.poly = f;
ERP.polyFit.polyOrder = polyOrder;
ERP.polyFit.P =P;
ERP.polyFit.S =S;
ERP.polyFit.MU =MU;
end

%% Function
function condName = getCondName(sedName)
sedPath = sprintf('data\\SEDs\\%s',sedName);
load(sprintf('%s\\Conditions',sedPath));
listCond = Conditions.cond;
prompt = 'Select experimental condition:';
mode = 'single';
option = getOption(listCond,prompt,mode);
condName = Conditions.files{option.ind};
end