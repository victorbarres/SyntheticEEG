%%  TEST_SEDPLOT
% Test to plot contrast conditions on 1 electrode

clear;clc;

ERP1  = sed_ERP;
ERP2  = sed_ERP;

figure;
hold;
set(gcf,'color','white');
set(gca,'Ydir','reverse');
plot(ERP1.time,ERP1.timeCourse,'-','color','k','LineWidth',3);
plot(ERP2.time,ERP2.timeCourse,'-.','color','k','LineWidth',3);
% title(sprintf('%s, %s',ERP1.elecName,ERP1.sedName'),'FontSize',8);
% legend('Standard','Deviant');
set(gca,'FontSize',16);
% xlabel('Time (ms)');
% ylabel('Potential (microV)');

% figure;
% hold;
% set(gcf,'color','white');
% plot(ERP1.time,ERP1.poly,'-','color','k','LineWidth',2);
% plot(ERP2.time,ERP2.poly,'-.','color','k','LineWidth',2);
% title(sprintf('%s, %s',ERP1.elecName,ERP1.sedName'));
% % legend('Standard','Deviant');
% xlabel('Time (ms)');
% ylabel('Potential (microV)');