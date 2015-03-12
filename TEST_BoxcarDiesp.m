time = 1:1232;

f = zeros(length(time),1);

for i=1:5
    b(i).boxcar = f;
    sem(i).boxcar = f;
    syn(i).boxcar = f;
end

b(1).boxcar(20:70) = 1;
b(2).boxcar(90:190) = 1;
b(3).boxcar(210:397) = 1.3;
b(4).boxcar(210:435) = 1;
b(5).boxcar(455:980) = 1;

sem(1).boxcar(20:70) = 1;
sem(2).boxcar(90:190) = 1;
sem(3).boxcar(210:397) = 1.3;
sem(4).boxcar(210:585) = 1;
sem(5).boxcar(605:1130) = 1;

syn(1).boxcar(20:70) = 1;
syn(2).boxcar(90:240) = 1;
syn(3).boxcar(260:447) = 1.3;
syn(4).boxcar(260:485) = 1;
syn(5).boxcar(505:1230) = 1;



% Plot sem vs baseline

figure;
subplot(3,1,1)
hold
box off
set(gcf,'color','white');
set(gca,'FontSize',16);
for i=1:5
%     plot(time, b(i).boxcar,'-', 'color','k','LineWidth',3);
    area(time, b(i).boxcar,'FaceColor',[.2 .2 .2]*i)
end
legend('N100','ELAN','LAN','N400','P600');
axis([0 1232 0 1.4])

subplot(3,1,2)
hold
box off
set(gcf,'color','white');
set(gca,'FontSize',16);
for i=1:5
%     plot(time, sem(i).boxcar,'-', 'color','k','LineWidth',3);
    area(time, sem(i).boxcar,'FaceColor',[.2 .2 .2]*i)
end
axis([0 1232 0 1.4])
subplot(3,1,3)
hold
box off
set(gcf,'color','white');
set(gca,'FontSize',16);
for i=1:5
%     plot(time, syn(i).boxcar,'-', 'color','k','LineWidth',3);
    area(time, syn(i).boxcar,'FaceColor',[.2 .2 .2]*i)
end
axis([0 1232 0 1.4])
