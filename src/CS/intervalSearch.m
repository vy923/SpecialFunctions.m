function idx = intervalSearch(A,vx,opts)
%  ------------------------------------------------------------------------------------------------
%   DESCRIPTION
%       idx = intervalSearch(A,vx,opts)
%
%       See also:       binarySearch, isapprox
%
%   INPUTS
%       A               n-D array
%       vx              [2 x n] or [1 x n] intervals or scalars to search for
%       opts{:}
%           ends        [2 x n] or [1 x n] indicating open/closed interval ends
%               true    closed, default
%               false   open
%           rtol/atol   isapprox settings, exact equality required with the default = 0
%           sorted      skip sorting checks if true, default = false
%
%   VERSION
%       v1.0 / 31.10.22 / V.Yotov
%  ------------------------------------------------------------------------------------------------

arguments
    A
    vx
    opts.ends
    opts.rtol = 0
    opts.atol = 0
    opts.sorted = false
end 

% Flatten if not a vector
if ~isvector(A), A=A(:); end

% Sort, reshape(A(idxS2A),sz) returns the original array
if ~opts.sorted && ~issorted(A) 
    [A,idxA2S] = sort(A(:));
    [~,idxS2A] = sort(idxA2S);
end

% TBA
% interval          vector              scalar
% open-open         right-left      |   error   
% closed-closed     left-right      |   left-right 
% open-closed       right-right     |   right
% closed-open       left-left       |   left 

%  ------------------------------------------------------------------------------------------------

































    
