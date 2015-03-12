%% TEST to create the ERPdAVal

ERPdAVal.totalDur = 1500;
ERPdAVal.timeRes = 1;

i=1;
ERPdAVal.area(i).name = 'N100circuit';
ERPdAVal.area(i).inputTime = 20;
ERPdAVal.area(i).computationTime = 62.5;
ERPdAVal.area(i).transfTime = 20;
ERPdAVal.area(i).outputTime = ERPdAVal.area(i).inputTime + ERPdAVal.area(i).computationTime;
ERPdAVal.area(i).activityLevel=1;

i=2;
ERPdAVal.area(i).name = 'ELANcircuit';
ERPdAVal.area(i).inputTime = ERPdAVal.area(i-1).outputTime + ERPdAVal.area(i-1).transfTime;
ERPdAVal.area(i).computationTime = 100;
ERPdAVal.area(i).transfTime = 20;
ERPdAVal.area(i).outputTime = ERPdAVal.area(i).inputTime + ERPdAVal.area(i).computationTime;
ERPdAVal.area(i).activityLevel=1;

i=3;
ERPdAVal.area(i).name = 'LANcircuit';
ERPdAVal.area(i).inputTime = ERPdAVal.area(i-1).outputTime + ERPdAVal.area(i-1).transfTime;
ERPdAVal.area(i).computationTime = 212.5;
ERPdAVal.area(i).transfTime = 20;
ERPdAVal.area(i).outputTime = ERPdAVal.area(i).inputTime + ERPdAVal.area(i).computationTime;
ERPdAVal.area(i).activityLevel=1;

i=4;
ERPdAVal.area(i).name = 'N400circuit';
ERPdAVal.area(i).inputTime = ERPdAVal.area(i-2).outputTime + ERPdAVal.area(i-2).transfTime;
ERPdAVal.area(i).computationTime = 250;
ERPdAVal.area(i).transfTime = 20;
ERPdAVal.area(i).outputTime = ERPdAVal.area(i).inputTime + ERPdAVal.area(i).computationTime;
ERPdAVal.area(i).activityLevel=1;

i=5;
ERPdAVal.area(i).name = 'P600circuit';
t1 = ERPdAVal.area(i-1).outputTime + ERPdAVal.area(i-1).transfTime;
t2 = ERPdAVal.area(i-2).outputTime + ERPdAVal.area(i-2).transfTime;
ERPdAVal.area(i).inputTime = max(t1,t2);
ERPdAVal.area(i).computationTime = 675;
ERPdAVal.area(i).transfTime = 0;
ERPdAVal.area(i).outputTime = ERPdAVal.area(i).inputTime + ERPdAVal.area(i).computationTime;
ERPdAVal.area(i).activityLevel=1;