function hfig = exp_figure
  hfig = figure;
  set(hfig,'KeyPressFcn',@exp_keypress_check);
end
