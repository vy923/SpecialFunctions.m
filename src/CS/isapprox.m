function mask = isapprox(x,y,atol,rtol) 
%  ------------------------------------------------------------------------------------------------
%   DESCRIPTION
%       mask = ISAPPROX(x,y,atol,rtol)
%
%       See also:       gettol
%
%   INPUTS
%       x, y            arrays compatible for broadcasting
%       atol            default = 0
%       rtol            default = sqrt(eps)
%
%   OUTPUTS
%       mask            boolean array |x-y| <= atol + rtol*max(|x|,|y|)
%
%   VERSION
%   v1.2 / 28.02.24 / --    bugfix for Inf/Inf and Inf/number comparisons
%   v1.1 / 31.10.22 / --    optimisation and bugfixes for Inf/NaN comparisons       
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
    if atol == 0, mask = x==y;
    else, mask = abs(x-y) <= atol & ~(isinf(x)|isinf(y)) | x==y;
    end
else, mask = abs(x-y) <= atol + rtol*max(abs(x),abs(y)) & ~(isinf(x)|isinf(y)) | x==y;
end


%  ------------------------------------------------------------------------------------------------
%{ 
% Example 1
    [isapprox(eps,0) isapprox(eps,0,eps,0)]
    [isapprox(1e-200,1e-120) isapprox(1e-200,1e-120,eps) isapprox(1e-200,1e-120,0)]
    [isapprox(0,0,[],eps) isapprox(0,0)]

% Example 2
    [isapprox(inf,inf) isapprox(-inf,-inf) isapprox(inf,-inf) isapprox(inf,10) isapprox(inf,0)]
    [isapprox(nan,10) isapprox(nan,0) isapprox(nan,nan) isapprox(nan,inf) isapprox(nan,-inf)]
%}
%  ------------------------------------------------------------------------------------------------