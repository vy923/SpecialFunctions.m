function tol = gettol(x,y,atol,rtol) 
%  ------------------------------------------------------------------------------------------------
%   DESCRIPTION
%       tol = GETTOL(x,y,atol,rtol)
%       Returns a scalar or an array atol + rtol*min(|x|,|y|)
%
%       See also:       isapprox
%
%   INPUTS
%       x, y            arrays compatible for broadcasting
%       atol            default = 0
%       rtol            default = sqrt(eps)
%
%   VERSION
%   v1.0 / 30.10.22 / V.Y.
%  ------------------------------------------------------------------------------------------------

% Faster than arguments block
if nargin < 4
    rtol = sqrt(eps); 
end
if nargin < 3 || isempty(atol)
    atol = 0; 
end

% First case avoids most computations
if rtol == 0                                                  
    tol = atol;
else
    tol = atol + rtol*min(abs(x),abs(y));
end
