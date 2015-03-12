maxTime = 2;
minTime = 0;
numPoints = 100000;
res = (maxTime-minTime)/numPoints;
time = minTime:res:maxTime;


mean = 0.5;
std = 0.3;
var = std^2;
% Note: mean = k*theta, var = k*theta^2
theta = var/mean;
k = mean/theta;
gammaRef= gampdf(time,k,theta);
gammaRef = gammaRef/max(gammaRef);
param = [mean,std];

inputTime = 100;
cpTime = 212.5;

n = numPoints/2;
step = floor(n/cpTime);

ind = 1:step:numPoints;
dA = gammaRef(ind);
newTime = ind*res;
length(ind)
plot(ind*res*cpTime,dA);
plot(dA);

fullTime = 0:1:1500;
timeCourse = zeros(length(fullTime),1);

timeCourse(inputTime:inputTime+length(dA)-1) = dA;
plot(timeCourse);




