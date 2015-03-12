%% TEST to create the ERPdAVal

ERPdAVal.totalDur = 600;
ERPdAVal.timeRes = 1;

i=1;
ERPdAVal.area(i).name = 'N100circuit';
ERPdAVal.area(i).inputTime = 20;
ERPdAVal.area(i).computationTime = 100;
ERPdAVal.area(i).transfTime = 20;
ERPdAVal.area(i).outputTime = ERPdAVal.area(i).inputTime + ERPdAVal.area(i).computationTime;
ERPdAVal.area(i).activityLevel=2.1;