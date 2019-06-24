function exp_comment(onwhat) 
  global results_prefix;

  if (nargin < 1)
    prefix = '';
  else
    prefix = [onwhat ': '];
  end
  cmt = input('Comment: ','s');

  fid = fopen([results_prefix '_comment.txt'],'at');  
  fprintf(fid,'%s%s\n',prefix,cmt);
  fclose(fid);
end
