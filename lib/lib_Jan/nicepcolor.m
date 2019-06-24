function nicepcolor(m, flip)
  if ((nargin > 1) && flip)
      m = flipud(m);
  end
  [x,y] = meshgrid((1:(size(m,2)+1))-0.5, (1:(size(m,1)+1))-0.5);
  h = pcolor(x,y,[m zeros(size(m,1),1); zeros(1,size(m,2)+1)]);
  set(h,'LineStyle','none');
end
