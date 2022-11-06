function idx = intervalSearch(A,vx,closed,atol,rtol,sorted)
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
%   v1.0 / 04.11.22 / V.Y.
%  ------------------------------------------------------------------------------------------------

% Argument defaults
if nargin < 6 || isempty(sorted),       sorted = false;         end
if nargin < 5 || isempty(rtol),         rtol = [];              end
if nargin < 4 || isempty(atol),         atol = [];              end
if nargin < 3 || isempty(closed),       closed = true(1,2);     end

% Flatten if not a vector
if ~isvector(A)
    sz = size(A);   
    A = A(:);
end

% Sort, reshape(A(idxS2A),sz) returns the original array
if ~sorted && ~issorted(A) 
    [A,idxA2S] = sort(A);
    [~,idxS2A] = sort(idxA2S);
end

% Compute indices
idx = [ binarySearch(A,vx(:,1),closed,atol,rtol), ...
        binarySearch(A,vx(:,2),~closed,atol,rtol) ];

% +/-inf if interval is outside range
% negative indices if interval is a subinterval with no match

% idx(idx==Inf,1) = 0;
% idx(idx==Inf,2) = numel(A);
% idx(idx==-Inf,1) = 1;
% idx(idx==-Inf,2) = 0; 
% idx(idx(:,1)<0, 1) = -idx(idx(:,1)<0, 1) + 1;   % regardless of L/R search, element rank is the same
% idx(idx(:,2)<0, 2) = -idx(idx(:,2)<0, 2);

% TBA
% interval          vector 
% open-open         right-left
% closed-closed     left-right
% open-closed       right-right
% closed-open       left-left



%  ------------------------------------------------------------------------------------------------

































    
