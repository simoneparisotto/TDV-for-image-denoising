function fig2eps(where, ext, type)
	if (nargin < 2)
		ext = '.eps';
	end
	if (nargin < 3)
		if (strcmp(ext,'.png'))
			type = 'png';
		else
			type = 'epsc2'
		end
	end

    fns = rdir(where);
    
    for i = 1:numel(fns)
        fn = fns{i};
        fprintf('Processing %s...', fn);
        
        prop = struct('Visible','off');
        try
            h = hgload(fn,prop);
            saveas(h,[fn ext],type);
            close(h);
            fprintf('done.\n');
        catch me
            fprintf('FAILED: %s\n', me.message);
        end
    end
end

function fo=rdir(name,opt)
%RDIR Recursive list directory.
%   F = RDIR(NAME) returns a cell array of file names matching NAME.
%   NAME may be a cell array of strings, and may contain cascading
%   pathnames separated by '/' (or '\') followed by a filename. Wildcards
%   (*) may be used both in the final filename, as in DIR, but also in the
%   intermediate pathnames. For example, F=RDIR('mydir*/*.m') returns all
%   the M-Files contained in each directory that begins with 'mydir'.
%
%   File number indexing: Brackets [] may be used in the file or directory
%   names for convenient number indexing. If the input string is in the form
%   'PP[RANGE]SS', all files or directories matching 'PP0000nSS' will be
%   returned, where 'PP' and 'SS' are prefix and suffix substrings, and n
%   is an index lying in the range RANGE (paded with 5 zeros by default).
%   RANGE is a vector, that can be in the form [N1 N2 N3..], or START:END,
%   or START:STEP:END, or any other MATLAB valid syntax.
%
%   Use 'PP[RANGE,NZ]SS') to specify the number of zeros to pad the index
%   string (NZ=5 by default). For example, 'B[1:4,2].v*' gives
%   {'B01.v*','B02.v*','B03.v*','B04.v*'}.
%
%   Use 'PP[RANGE,NZ.NP]SS' to specify the number of digits NP after the
%   decimal point (NP=0 by default). For example, 'dt=[1:0.5:2,2.3]s' gives
%   {'dt=1.000s','dt=1.500s','dt=2.000s'}.
%
%   If the input string has more than one bracket pair [], RDIR is
%   called recursively for each pair. For example, 'B[1:4,2]_[1 2,1]'
%   gives {'B01_1','B01_2','B02_1','B02_2','B03_1','B03_2','B04_1','B04_2'}
%
%   RDIR file_name  or  RDIR('file_name') displays the result.
%
%   F = RDIR(NAME,'fileonly') only returns file names.
%   F = RDIR(NAME,'dironly') only returns directory names, but does not
%   list their content.
%   F = RDIR(NAME,'filedir') returns both files and directories (as DIR),
%   by default.
%   (Note that, when options 'dironly' or 'filedir' are used, the
%   fictitious directories '.' (current) and '..' (parent) are not
%   returned, contrarily to DIR).
%
%   Examples:
%
%     F = RDIR('set*/B[1:8,2].v*')  returns the file names matching
%     'B01.v*' to 'B08.*' in each directory matching 'set*'.
%
%     F = RDIR('set[1 2 3]*/*/B01.vec')  returns the file name 'B01.vec',
%     if present, in all the subdirectories of each directory matching
%     'set1*', 'set2*', 'set3*'.
%
%     F = RDIR('Myfiles_dt=[1:0.5:2,5.2]s.*') returns the file names
%     'Myfiles_dt=01.00s.*', 'Myfiles_dt=01.50s.*', 'Myfiles_dt=02.00s.*'
%
%   See also DIR, LSW, CDW.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.20,  Date: 2010/05/12



% History:
% 2004/10/04: v1.00, first version.
% 2006/11/29: v1.01, 'filedir' is now the new default parameter
% 2010/01/19: v1.10, use filesep ('' or '/')
% 2010/05/01: v1.11, replace all / and \ with filesep, and add a *.
% 2010/05/05: v1.12, bug fixed with absolute path names (eg, C:\*)
% 2010/05/07: v1.13, removes the prefix './' if any
% 2010/05/12: v1.12, accepts non-integer filenumber indexing (based on
% expandstr v1.10; actually, only the help text has been changed in rdir)


error(nargchk(1,2,nargin));

verb=0; % set verb=1 for debugging (verbose), or verb=0 for normal use.

if nargin==1, opt='filedir'; end    % changed V1.01

if iscell(name),
    f={};
    for i=1:length(name),
        if verb, disp(['im in ' pwd ' and im calling rdir for ' name{i}]); end
        ff=rdir(name{i},opt);
        f={f{:} ff{:}};
    end
else
    % new v1.11:
    name = strrep(name,'\',filesep);
    name = strrep(name,'/',filesep);
    
    % new v1.13: removes any './'
    name = strrep(name, ['.' filesep], '');
    
    p=findstr(name,filesep);
    
    % new v1.12: 'C:\' not considered has having a '\'
    if findstr(name,[':' filesep]) & length(p)==1   
        p=[];
    end
    
    if isempty(p) % if the input string contains no filesep
        if verb, disp(['im in ' pwd ', with ' name ' that contains no ' filesep]); end
        
        name=expandstr(name); % tries to expand the file name
        if ~iscell(name), % if there were nothing to expand
            % then simply returns the filenames matching NAME:
            if verb, disp(['im in ' pwd ' and im going to call dir for ' name]); end
            f=dir(name);
            switch lower(opt)
                case 'fileonly', f=f(~[f.isdir]);
                case 'dironly', f=f([f.isdir]);
                case {'filedir','dirfile'}, %f=f;
                otherwise, error(['Unknown option ''' opt '''']);
            end
            f={f.name};
            ff={};
            for i=1:length(f),
                if ((~strcmp(f{i},'..')) && (~strcmp(f{i},'.'))), % excludes '.' and '..'
                    ff={ff{:} f{i}};
                end
            end
            f=ff;
        else
            % something has been expanded, so calls rdir for each file name
            f={};
            for i=1:length(name),
                if verb, disp(['im in ' pwd ' and im going to call rdir for ' name{i}]); end
                ff=rdir(name{i},opt);
                for j=1:length(ff),
                    %f={f{:} [name{i} '/' ff{j}]};
                    f={f{:} ff{j}};
                end
            end
        end
    else
        if verb, disp(['im in ' pwd ', with ' name ' that contains ' filesep]); end
        pname=name(1:(p-1)); % first pathname of the input string
        fname=name((p+1):end); % next pathnames and final filename
        pname=expandstr(pname); % tries to expand the first path name
        if verb, disp(['pname=' pname ',  fname=' fname]); end
        if ~iscell(pname), % if there were nothing to expand,
            if isempty(findstr(pname,'*'))
                if verb, disp([pname ' contains no *']); end
                if exist(pname,'dir')
                    d={pname};
                else
                    d={};
                end
            else
                if verb, disp([pname ' contains *(s)']); end
                d=dir(pname); % looks for pathnames matching the first pathname
                d=d([d.isdir]); % keeps only directories
                d={d.name}; % extracts the names
            end
            f={};
            for i=1:length(d),
                if ((~strcmp(d{i},'..')) && (~strcmp(d{i},'.'))), % excludes '.' and '..'
                    if verb, disp(['im in ' pwd ', and im entering in ' d{i}]); end
                    
                    trep=d{i};  % new v1.12
                    if isequal(trep(end),':')
                        trep = [trep filesep];
                    end
                    cd(trep)
                    
                    % calls (possibly recursively) rdir for the next pathnames:
                    if verb, disp(['im in ' pwd ' and im calling rdir for ' fname]); end
                    ff=rdir(fname,opt);
                    % builds the output cell array:
                    for j=1:length(ff),
                        f={f{:} [d{i} filesep ff{j}]};
                    end
                    cd ..
                end
            end
        else
            % if pname has been expanded, then calls rdir for each pathname
            f={};
            for i=1:length(pname),
                ff=rdir([pname{i} filesep fname],opt);
                f={f{:} ff{:}};
            end
        end
    end
end

if nargout==0
    disp(f');
else
    fo=f;
end

end

function f=expandstr(str)
%EXPANDSTR  Expand indexed strings.
%   F = EXPANDSTR('PP[RANGE]SS') returns a cell array of strings in the form
%   'PP0000nSS', where 'PP' and 'SS' are prefix and suffix substrings, n is
%   an index lying in the range RANGE, paded with 5 zeros.  RANGE is a
%   vector, that can be in the form [N1 N2 N3..], or START:END, or
%   START:STEP:END, or any other MATLAB valid syntax.
%
%   F = EXPANDSTR('PP[RANGE,NZ]SS') also specifies the number of zeros to
%   pad the index string (NZ=5 by default). For example, 'B[1:4,2].v*'
%   gives {'B01.v*','B02.v*','B03.v*','B04.v*'}.
%
%   F = EXPANDSTR('PP[RANGE,NZ.NP]SS') also specifies the number of digits
%   NP after the decimal point (NP=0 by default). For example,
%   'dt=[1:0.5:2,2.3]s' gives {'dt=1.000s','dt=1.500s','dt=2.000s'}.
%
%   If the input string has more than one bracket pair [], EXPANDSTR is
%   called recursively for each pair. For example, 'B[1:4,2]_[1 2,1]'
%   gives {'B01_1','B01_2','B02_1','B02_2','B03_1','B03_2','B04_1','B04_2'}
%
%   EXPANDSTR is useful when applied to file names, e.g. with RDIR. In
%   particular, wildcards (*) may be present in PP or SS (but they are
%   kept as wildcards, i.e. they are not interpreted). For example,
%   expandstr('B[1 2 3,5]*.*') returns {'B00001*.*','B00002*.*',..}. Note
%   that EXPANDSTR is automatically called from RDIR.
%
%   Examples :
%
%   expandstr('DSC[2:2:8,4].JPG') returns
%     {'DSC0002.JPG','DSC0004.JPG','DSC0006.JPG','DSC0008.JPG'}
%
%   expandstr('Myfiles_dt=[1:0.5:2,5.2]s.*') returns
%     {'Myfiles_dt=01.00s.*','Myfiles_dt=01.50s.*','Myfiles_dt=02.00s.*'}
%
%   rdir(expandstr('B[1:10,5]*.*'))  is equivalent to rdir('B[1:10,5]*.*')
%
%   See also RDIR.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.10,  Date: 2010/05/12


% History:
% 2004/09/29: v1.00, first version. Replaces buildfilename.
% 2004/10/04: v1.01, works recursively when several [] are found.
% 2010/05/04: v1.02, now in the private directory
% 2010/05/12: v1.10, now accepts non-integer formats

error(nargchk(1,1,nargin));

f='';
p1=findstr(str,'[');
if isempty(p1),
    f=str;
else
    p1=p1(1);
    p2=findstr(str,']');
    if isempty(p2),
        error('Invalid string: Missing closing bracket '']''');
    else
        p2=p2(1);
        pp=str(1:(p1-1)); % prefix
        ss=str((p2+1):end); % suffix
        p3=findstr(str((p1+1):(p2-1)),',');
        if ~isempty(p3)
            num=eval(str((p1+1):(p1+p3-1)));
            nz=str2double(str((p1+p3+1):(p2-1)));
        else
            num=eval(str((p1+1):(p2-1)));
            nz=5; % number of zeros by default
        end
        nzw = fix(nz);  % precision
        nzp = round(10*(nz-fix(nz))); % nbre of digits after '.'
        if nzw>16,
            error('Invalid number of zero pading: too large.');
        end
        format = ['%0' num2str(nzw) '.' num2str(nzp) 'f'];
        for i=1:length(num),
            f{i}=[pp sprintf(format, num(i)) ss];
        end
    end
    % if brackets remain in the suffix, call again EXPANDSTR for each
    % string (and so on recursively)
    if findstr(ss,'['),
        ff={};
        for i=1:length(f),
            e=expandstr(f{i});
            ff={ff{:} e{:}};
        end
        f=ff;
    end
end

end
