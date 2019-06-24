function result = mergestruct(s1,s2)
% result = mergestruct(s1,s2) Merges two structs s1, s2. Duplicate fields generate an error.
	pairs = [fieldnames(s1), struct2cell(s1); fieldnames(s2), struct2cell(s2)].';
	result = struct(pairs{:});
end
