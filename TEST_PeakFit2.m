eCz = 10;
eF7 = 1;
ePz = 12;
eN100 = 1;

% ELAN
indList_ELAN_Baseline = 2:9;
onTime_ELAN_Baseline = 90;

indList_ELAN_CondSyn = 1:9;
onTime_ELAN_CondSyn = 90;

% N400
indList_N400_Baseline = 1:17;
onTime_N400_Baseline = 210;

indList_N400_CondSem = 1:21;
onTime_N400_CondSem = 210;

onTime_N400_CondSyn = 260;

% P600
indList_P600_Baseline = 12:27;
onTime_P600_Baseline = 455;

indList_P600_CondSyn = 9:30;
onTime_P600_CondSyn = 505;

onTime_P600_CondSem = 605;

% LAN
indList_LAN_Baseline = 5:10;
onTime_LAN_Baseline = 210;

indList_LAN_CondSyn = 5:11;
onTime_LAN_CondSyn = 260;

% N100
indList_N100_Baseline = 3:7;
onTime_N100_Baseline = 20;

indList_N100_Deviant = 2:9;

% CHECK STUFF
Path1 ='data\\SEDs\\Hahne and Friederici (Exp1)\\Time';
Path2 ='data\\SEDs\\Hahne and Friederici (Exp1)\\CondCorrect'; % Change that
e =eCz; % Change that
onTime = onTime_N400_Baseline;
indList = indList_N400_Baseline;
name = 'dA_N400_Baseline'; % Check this!!
component = 'N400 baseline';

load(Path1);
load(Path2);
record = record(e,:);
figure
hold
plot(Time, record)
plot(Time, record,'o')


Time = Time(indList);
Time = Time - Time(1);
Time = Time./Time(end);
record = record(indList);

offset = record(1);
record = record - offset;

M = min(record); % Change that if a Positivity
record = record/M; % Normalization

figure;
plot(Time,record,'-','color','k','LineWidth',2);
set(gcf,'color','white');
hold on

diff = sum(record);
vals = [0,0];
for mean = 0:0.1:1
    for std = 0:0.1:1
        var = std^2;
        % Note: mean = k*theta, var = k*theta^2
        theta = var/mean;
        k = mean/theta;
        gamma= gampdf(Time,k,theta);
        gamma = gamma/max(gamma);
        plot(Time,gamma,'-.','color','k','LineWidth',0.5)
        
        d = 0;
        for i=1:length(record)
            d = d + abs(record(i)-gamma(i));
        end
        
        if d<diff
            vals = [mean,std];
            diff = d;
        end     
    end
end

hold off

vals
mean = vals(1);
std = vals(2);
var = std^2;
theta = var/mean;
k = mean/theta;
gammaRef= gampdf(Time,k,theta);
gammaRef = gammaRef/max(gammaRef);
init = Time(1);
final = Time(end)*3;
step = Time(2)-Time(1);
gammaTime = init:step:final;
numPointsGamma = length(gammaTime);

figure;
plot(Time,record,'-','color','k','LineWidth',2);
set(gcf,'color','white');
hold on
plot(Time,gammaRef,'-.','color','k','LineWidth',2)
box off

% load('data\\SEDs\\Hahne and Friederici (Exp1)\\Time');
load(Path2);
load(Path1);


maxTime =1;
minTime =0;
numPoint = length(indList);

numPoint = ceil(numPointsGamma);
res = (maxTime-minTime)/numPoint;

time =  minTime:res:maxTime;
mean = vals(1);
std = vals(2);
var = std^2;
theta = var/mean;
k = mean/theta;
dA = gampdf(time,k,theta);
dA = dA/max(dA);

% f = zeros(length(Time),1)+offset;
% f(indList(1):indList(1)+length(dA)-1) = f(indList(1):indList(1)+length(dA)-1) + dA'*M;
f = zeros(length(Time),1);
f(indList(1):indList(1)+length(dA)-1) =dA'*M;
f = f(1:length(Time));

on = find(Time>=onTime,1,'first');

f2 = zeros(length(Time),1);
f2(on-1:on+length(dA)-2) = dA'*M*sign(M);
f2 = f2(1:length(Time));
dA = dA*M;

figure;
hold
plot(Time,record(e,:),'-','color','k','LineWidth',3);
box off
set(gcf,'color','white');
set(gca,'FontSize',16);
set(gca,'Ydir','reverse');
plot(Time,f,'-.','color','k','LineWidth',3)
legend(component,'gamma fit');

figure
plot(Time,f2,':','color','k','LineWidth',3)
box off
set(gcf,'color','white');
set(gca,'FontSize',16);
legend('dA');

save(sprintf('temp\\%s',name),'f2');
save(sprintf('temp\\%s_fit',name),'f');


