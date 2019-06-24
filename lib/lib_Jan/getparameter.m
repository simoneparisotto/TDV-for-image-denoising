% returns param.(name) if it exists, else default.
function value = getparameter(param,name,default)
    if (~isempty(strfind(name,'.')))
        error(['getparameter does not support nested structs: ' name]);
    end
    if (isfield(param, name))        
        value = param.(name);
    else
        value = default;
    end
end
