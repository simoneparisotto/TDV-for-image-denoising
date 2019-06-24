function result = dbglevel_atleast(level)
	global debug_level;
	result = (isempty(debug_level) || (level <= debug_level));
end
