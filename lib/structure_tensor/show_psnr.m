function show_psnr(PSNR,b,lambda,ee)

co = [
    0         0.4470    0.7410;
    0.8500    0.3250    0.0980;
    0.9290    0.6940    0.1250;
    0.4940    0.1840    0.5560;
    0.4660    0.6740    0.1880;
    0.3010    0.7450    0.9330;
    0.6350    0.0780    0.1840];

linetype = {'--*','--*','--*','--*','--*','--*','--*'};

figure('pos',[0 0 850 800]);

for ll = 1:numel(lambda)
    plot(b,PSNR{ll}(ee,:),linetype{ll},'Color',co(ll,:),'LineWidth',5,'MarkerSize',12)
    hold on
end

xlim([b(1)-0.005,b(end)+0.005])
mm = min([PSNR{1}(ee,:),PSNR{2}(ee,:),PSNR{3}(ee,:),PSNR{4}(ee,:),PSNR{5}(ee,:),PSNR{6}(ee,:),PSNR{7}(ee,:)]);
MM = max([PSNR{1}(ee,:),PSNR{2}(ee,:),PSNR{3}(ee,:),PSNR{4}(ee,:),PSNR{5}(ee,:),PSNR{6}(ee,:),PSNR{7}(ee,:)]);
ylim([mm-0.2,MM+0.2])
xticks(b)
legend({'[1,0,0]','[0,1,0]','[0,0,1]','[1,1,0]','[1,0,1]','[0,1,1]','[1,1,1]'},'FontSize',24)
xlabel('$\mathbf{b}$','Interpreter','Latex','Fontsize',24)
ylabel('PSNR','Fontsize',24)
axis square
set(gca,'FontSize',24);
set(gca,'LooseInset',get(gca,'TightInset'))