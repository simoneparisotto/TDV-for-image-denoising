function exp_begin(aux_folders, prefix, postfix)
   global results_folder results_prefix exp_cancelled_v;

   exp_cancelled_v = false;
   
   if (nargin < 2)
       prefix = '';
   end
   
   if (nargin < 3)
       postfix = '';
   end

   env = getenv('JOBPATH');
   if ~strcmp(env,'')
       results_folder = env;
   else  
       runid = datestr(now,'yyyy-mm-dd_HH-MM-SS');
       results_folder = ['results/' prefix runid postfix];
   end
       
   [success,msg,msgid] = mkdir(results_folder); % suppress warning if path exists
   results_prefix = [results_folder '/'];   
   diary([results_prefix 'diary.txt']);
   
   files = {};
   if (nargin > 0)
	   if (strcmp(class(aux_folders),'char'))
	      aux_folders = {aux_folders};
       end
       for i = 1:numel(aux_folders)
          files{end+1} = [aux_folders{i} '/*.m'];
%		  copyfile([aux_folders{i} '/*.m'], results_folder); % Note that this overwrites files with the same name
	   end
   end
   files{end+1} = '*.m';   
%   copyfile([aux_folders{i} '/*.m'], results_folder); % Note that this overwrites files with the same name
%   copyfile('*.m', results_folder);
   zip([results_folder '/src.zip'],files);

   exp_reset_timer();
end
