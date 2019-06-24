function make_a_nice_3d_view()
  daspect([1 1 1]);
  camproj perspective;
  view(3);
  axis tight;
  axis vis3d;
  box on;
  %lg = light;
  %set(lg,'Style','infinite');
  %set(lg,'Position',[0 0 -1]);
  %camlight headlight
  %lighting phong
end
