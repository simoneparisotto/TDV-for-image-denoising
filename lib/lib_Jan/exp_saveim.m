function exp_saveim(filename, img)
  global results_prefix;
  imwrite(img, [results_prefix filename]);
end
