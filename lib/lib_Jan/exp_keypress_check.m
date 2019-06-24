function exp_keypress_check(src, eventdata)
  global exp_cancelled_v;
  if (strcmp(eventdata.Key,'escape'))
      exp_cancelled_v = true;
  end
end
