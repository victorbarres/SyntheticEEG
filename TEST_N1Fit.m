
load('data\\SEDs\\Scherg N1\\Time')
load('data\\SEDs\\Scherg N1\\CondDeviant')

indList = 3:10;% Visual isolation of the first peak.

Time = Time (indList);
Time = Time - Time(1);
Time = Time./Time(end);
record = record(indList);

M = min(record);
record = record/M;

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
final = Time(end)*2;
step = Time(2)-Time(1);
gammaTime = init:step:final;
numPointsGamma = length(gammaTime);

figure;
plot(Time,record,'-','color','k','LineWidth',2);
set(gcf,'color','white');
hold on
plot(Time,gammaRef,'-.','color','k','LineWidth',2)
box off

load('data\\SEDs\\Scherg N1\\Time')
load('data\\SEDs\\Scherg N1\\CondDeviant')

cpTimeRef = 62.5;

maxTime =gammaTime(end);
minTime = gammaTime(1);

cpTime = 62.5;

scale = cpTime/cpTimeRef;
numPoint = ceil(numPointsGamma*scale);
res = (maxTime-minTime)/numPoint;

time =  minTime:res:maxTime;
mean = vals(1);
std = vals(2);
var = std^2;
theta = var/mean;
k = mean/theta;
dA = gampdf(time,k,theta);
dA = dA/max(dA);


onTime = 20;
on = find(Time>=onTime,1,'first');

f = zeros(length(Time),1);
f(on+1:on+length(dA)) = dA*M;



figure;
subplot(2,1,1)
hold
plot(Time,record,'-','color','k','LineWidth',3);
set(gcf,'color','white');
set(gca,'FontSize',16);
set(gca,'Ydir','reverse');
plot(Time,f,'-.','color','k','LineWidth',3)
legend('N100','Gamma fit');
f2 = zeros(length(Time),1);
f2(on+1:on+length(dA)) = dA;
subplot(2,1,2)
plot(Time,f2,':','color','k','LineWidth',3)
box off
legend('N100','Gamma fit','dA');
set(gca,'FontSize',16);
legend('dA');

