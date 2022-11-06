function x = cvec(x,varargin)
%  ------------------------------------------------------------------------------------------------
%   DESCRIPTION
%       CVEC(x)             returns a column vector or error if x is not a vector
%       CVEC(x,varargin)    performs the op on all variables in varargin and assigns to caller
%
%   VERSION
%   v2.0 / 06.11.22 / V.Y.
%  ------------------------------------------------------------------------------------------------

if ~isvector(x) && ~isempty(x)
    error('cvec: Input is not a vector')
elseif isrow(x)
    x = x.';
end

if nargin > 1
    assignin('caller',inputname(1),x)
    for i = 1:numel(varargin)
        assignin('caller',inputname(i+1),cvec(varargin{i}))
    end
end




