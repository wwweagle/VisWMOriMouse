function OriDataAnalysis(filename,axesNumber)

load(filename);
perf = zeros(1,length(Number));


for itr0 = 1:length(Number)
    pos = isnan(Result(itr0,:));   
    Result(itr0,pos) = [];  % delete NaN 
    perf(itr0) = sum(abs(Result(itr0,1:end-1)))/Number(itr0);
end
Result(:,length(Number)) = perf';
axes(axesNumber);
% subplot(3,3,6);
h1 = area(1:6,perf);
hold on;
% title('�Ƕ�����');
xlabel('ͼ������','FontSize',8);
ylabel('�����Ƕ�(ƽ��ֵ)','FontSize',8);
% % % xlabel('ͼ������');
% % % ylabel('�����Ƕ�(ƽ��ֵ)');
set(gca,'TickDir','out','YTickLabel',{'0','15','30','45','60','75','90'},...
    'YTick',[0 15 30 45 60 75 90],...
    'XTickLabel',{'1','2','3','4','5','6'},...
    'XTick',[1 2 3 4 5 6],...
    'FontSize',7)  ;

% maxofdiff = max(perf)*1.5;
% axis(axisNumber,[1 length(perf) 0 maxofdiff]);
box off
% % cd(dateSavePath);
saveas(gcf,filename(1:end-4),'fig');
fn=[filename(1:end-4),'.png'];
print(gcf,fn,'-dpng');
% % % % close 

