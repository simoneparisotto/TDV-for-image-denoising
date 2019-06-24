% This overrides the default MATLAB function for displaying the result of
% command lines without semicolon, i.e.
%
%a = 5
% 
%a =
% 
%     5
%
% The output is prefixed by the file name and line number it occured in.
% This helps in identifying the source of the output, i.e. the missing
% semicolon.
%
% To activate, put it into a folder called "@double" (or choose a different
% type to override) in the MATLAB search path or in the current directory.

function display(x)
    global dd_flag;
    
    if (dd_flag)
        builtin('display',x);
    else
        if (nargin > 0 && ~isempty(x))
            dd_flag = true;
            [st,i] = dbstack(1);
        
            if (numel(st) > 0)
                disp([st(1).file ':' num2str(st(1).line) ' (' st(1).name ') ']);
            end
        
            if isequal(get(0,'FormatSpacing'),'compact')
               disp([inputname(1) ' =']);
               disp(x);
            else
               disp(' ');
               disp([inputname(1) ' =']);
               disp(' ');
               disp(x);
            end
        
            dd_flag = false;
        end   
    end
end
