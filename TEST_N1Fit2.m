
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

figure;
plot(Time,record,'-','color','k','LineWidth',2);
set(gcf,'color','white');
hold on
plot(Time,gammaRef,'-.','color','k','LineWidth',2)
box off

load('data\\SEDs\\Scherg N1\\Time')
load('data\\SEDs\\Scherg N1\\CondDeviant')

totalDur = 600;
timeRes = 1;
time = 0:timeRes:totalDur*2;


maxTime = 2;
minTime = 0;
numPoints = 100000; % High res gamma function.
res = (maxTime-minTime)/numPoints;
gammaTime = minTime:res:maxTime;

diff = sum(record);
vals = [0,0];
figure;
hold on
for mean = 0:0.2:1
    for std = 0:0.2:1
        
        var = std^2;
        theta = var/mean;
        k = mean/theta;
        gamma= gampdf(gammaTime,k,theta);
        gamma = gamma/max(gamma);
%         plot(gammaTime,gamma,'-.','color','k','LineWidth',0.5);
        
        onTime = 20;
        offTime = 82.5;
        on = find(time>=onTime,1,'first');
        off = find(time>=offTime,1,'first');
        
        cpTime = 62.5;
        L = cpTime*2;
        step = floor(numPoints/L);
        ind = 1:step:numPoints;
        dA = gamma(ind);
        f = zeros(length(time),1);
        f(on:on+length(dA)-1) = dA*M;
        plot(time,f,'-.','color','k','LineWidth',0.5);
        
        d = 0;
        for i=1:length(record)
            t = find(time>=Time(i),1,'first');
            d = d + abs(record(i)-gamma(t));
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
gammaRef= gampdf(time,k,theta);
gammaRef = gammaRef/max(gammaRef);

figure;
plot(Time,record,'-','color','k','LineWidth',2);
set(gcf,'color','white');
hold on
plot(time(1:totalDur),gammaRef(1:totalDur),'-.','color','k','LineWidth',2)
box off