function hideticks(ax)
  set(ax,'Box','on');
  set(ax,'XTickMode','manual');
  set(ax,'XTick',[]);
  set(ax,'XTickLabelMode','manual');
  set(ax,'XTickLabel',[]);
  set(ax,'YTickMode','manual');
  set(ax,'YTick',[]);
  set(ax,'YTickLabelMode','manual');
  set(ax,'YTickLabel',[]);
end
