function dbg(level,varargin)
  global debug_level debug_timer_start;
  if (isempty(debug_level) || (level <= debug_level))
      if (~isempty(debug_timer_start))
          fprintf('[%09.4f] ',cputime-debug_timer_start);
      end
      disp(varargin{:});
  end
end
