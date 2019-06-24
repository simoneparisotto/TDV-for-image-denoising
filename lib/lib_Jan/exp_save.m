% Syntax: exp_save('filename','varname1',wert1,'varname2',wert2,...);
%         exp_save('filename'); stores all variables in scope
function result = exp_save(filename, varargin)
  global results_prefix;
  fn = [results_prefix filename];
  
  if (nargin < 2)
	evalin('caller',['save(''' fn ''');']);
  else 
    s = [];
    i = 1;
    while (i + 1 <= numel(varargin))
        s.(varargin{i}) = varargin{i+1};
        i = i + 2;
    end
  
    save(fn,'-struct','s');
  %  eval(['save ''' results_prefix varname '.mat'' ' varname ';']);
  end

  if (nargout > 0)
      result = fn;
  end
end
