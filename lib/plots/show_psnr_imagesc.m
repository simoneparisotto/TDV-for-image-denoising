function show_psnr_imagesc(PSNR_v1,ll,ee,bb,PSNR_v2,lambda,eta,b,s,r,labelx,labely)
% x-axis: rho
% y-axis: sigma
myColorMap = diverging_map(linspace(0,1,256).',[0.230, 0.299, 0.754],[0.706, 0.016, 0.150]);

% plot sigma and rho

P2 = squeeze(PSNR_v2(ll,ee,bb,:,:));

for e_id = ee
    for b_id = bb
        P1 = squeeze(PSNR_v1(ll,e_id,b_id,1:numel(s),1:numel(r)));
        
        hfig = figure('pos',[0 0 850,700]);
        imagesc(P1)
        colorbar
        colormap(myColorMap)
        c_min = min( [ min(P1(:)), min(P2(:)) ] );
        c_max = max( [ max(P1(:)), max(P2(:)) ] );
        caxis([c_min,c_max])
        
        axis square
        
        
        %set(gca, 'XTick', 1:numel(r), 'XTickLabel', sprintf('%.1f\n',r));
        %set(gca, 'YTick', 1:numel(s), 'YTickLabel', sprintf('%.1f\n',s));
        axis off
        xlabel(['$\mathbf{\',labelx,'}$'],'Interpreter','Latex','Fontsize',30)
        ylabel(['$\',labely,'$'],'Interpreter','Latex','Fontsize',30)
        set(gca,'FontSize',30);
        
        set(gca,'LooseInset',get(gca,'TightInset'))
        
        
        saveas(hfig,['./imagesc_lambda',num2str(lambda{ll}(1)),'-',num2str(lambda{ll}(2)),'-',num2str(lambda{ll}(3)),'_eta',sprintf('%.2f',eta(e_id)),'_b',sprintf('%.2f',b(b_id)),'.png'])
        close all
        pause(0.01)
    end
end