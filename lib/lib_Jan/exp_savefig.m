function exp_savefig(filename, save_eps)
  global results_prefix;
  
  if (nargin < 2)
	save_eps = false;
  end
  
  saveas(gcf,[results_prefix filename '.fig'],'fig');
  
  %set(gcf,'renderer','painters'); % needed to prevent segmentation fault in console mode with dodgy OpenGL installation
  
  print(gcf,[results_prefix filename '.png'],'-dpng','-r300');  
  
  if (save_eps)
    print(gcf,[results_prefix filename '.eps'],'-depsc2','-r300');
  end
end
