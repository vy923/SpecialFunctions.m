function x = binarySearch(A,x,leftmost,atol,rtol)
%  ------------------------------------------------------------------------------------------------
%   DESCRIPTION
%       idx = binarySearch(A,x,leftmost,atol,rtol)
%
%       Returns first/last indices of values of x in a sorted array A                              
%       A and x may contain any number of +/-Inf and NaN 
%       Approx. equality: |A(idx) - x| <= atol + rtol*max(|A(idx)|,|x|)                 
%       Code is verbose for performance reasons                                               
%
%       See also:       intervalSearch
%
%   INPUTS
%       A               sorted array, -Inf < finite < Inf < NaN 
%       x               array of target values
%       leftmost        either scalar or array of the same size as x [default = true]
%           true        leftmost binary search
%           false       rightmost binary search
%       atol/rtol       absolute/relative tolerance, [default = 0]
%
%   OUTPUTS
%       idx             array of indices in A for values x
%           -Inf        x(i) < min(A) - tol
%            Inf        x(i) > max(A) + tol
%            < 0        rank of x(i) in A, but no exact match (within tol)
%            > 0        index s.t. A(idx(i)) is approx. x(i) (within tol)
%
%   UPDATES
%       - write examples
%
%   VERSION
%   v1.2 / 04.11.22 / --    bugfix in case branching; examples at bottom of code
%   v1.1 / 02.11.22 / --    optimisation, robust handling of +/-Inf and NaN
%   v1.0 / 30.10.22 / V.Y.
%  ------------------------------------------------------------------------------------------------

% Faster than arguments block
if nargin < 3 || isempty(leftmost),     leftmost = true;        end
if nargin < 4 || isempty(atol),         atol = 0;               end
if nargin < 5 || isempty(rtol),         rtol = 0;               end

% Array bounds, element counts
n = numel(A);
nr = n;                                                                                     % index of last finite value
nl = 1;                                                                                     % index of first finite value
npn = 0;                                                                                    % number of NaN
nni = 0;                                                                                    % number of -Inf
npi = 0;                                                                                    % number of Inf

% Default x(i) indices for special cases
lnoor = -Inf;                                                                               % L serch, finite, out of numeric range of A
rnoor = Inf;                                                                                % R serch, finite, out of numeric range of A
nspec = -Inf;                                                                               % L/R serch, finite, A has zero finite elements 
lnegi = -Inf;                                                                               % L serch, -Inf
rposi = Inf;                                                                                % R serch, Inf
rnan = Inf;                                                                                 % R serch, NaN

% Count non-finite values
if isnan(A(nr))
    npn = nr - bSpecial(A,NaN,true,nl,nr) + 1;
    nr  = nr - npn;
    rnoor = -nr;
    rnan = n;
end
if nl <= nr && A(nr)==Inf
    npi = nr - bSpecial(A,Inf,true,nl,nr) + 1;
    nr  = nr - npi;
    rnoor = -nr;
    rposi = -npn + n;
end
if nl <= nr && A(nl)==-Inf
    nni = bSpecial(A,-Inf,false,nl,nr);
    nl  = nni + 1;
    lnoor = -nl + 1;
    nspec = -nni;
    lnegi = 1;
end
rems = npn + npi + nni;

% First/last finite values of A
if nl <= nr
    AL = A(nl);
    AR = A(nr);
end
lms = isscalar(leftmost);

% Compute, assigning output in-place to x
for i = 1:numel(x)

    xi = x(i);
    axi = abs(xi);
    lmi = leftmost(lms + ~lms*i);                                                           % k==1 if leftmost is a scalar, else k==i

    if rems > 0                                                                             % directly assign indices of non-finite xi
        if xi==Inf
            x(i) = rposi - lmi*(npi-1);
            rems = rems - 1;
            continue
        elseif xi==-Inf
            x(i) = lnegi + ~lmi*(nni-1);
            rems = rems - 1;
            continue
        elseif isnan(xi)
            x(i) = rnan - lmi*(npn-1);
            rems = rems - 1;
            continue
        elseif nl > nr                                                                      % finite xi in a +/-Inf/NaN only array
            x(i) = nspec;
            rems = rems - 1;
            continue
        end
    end
    if xi < AL - atol - rtol*min(abs(AL),axi)                                               % xi < min(A) - tol
        x(i) = lnoor;                                                                     
    elseif xi > AR + atol + rtol*min(abs(AR),axi)                                           % xi > max(A) + tol
        x(i) = rnoor;
    else                                                                                    % binary search with tolerance
        l = nl; 
        r = nr + 1; 
        if lmi
            while l < r
                m = floor((l + r)/2);
                if A(m) < xi - atol - rtol*max(abs(A(m)),axi)
                    l = m + 1;
                else 
                    r = m;
                end
            end
            p = l;
        else
            while l < r
                m = floor((l + r)/2);
                if A(m) > xi + atol + rtol*max(abs(A(m)),axi) 
                    r = m;
                else 
                    l = m + 1;
                end
            end
            p = r - 1;
        end
        if A(p)==xi || abs(A(p)-xi) <= atol + rtol*max(abs(A(p)),axi)                       % check if A(p) is within tol of xi
            x(i) = p;                                                                       % xi ~ A(p), regardless of L/R search
        else
            x(i) = -p + lmi;                                                                % -1*rank of xi: xi is in the interval (AL,AR), but no matches within tol
        end
    end

end % for xi

%  ------------------------------------------------------------------------------------------------

% L/R binary search for nonfinite elements
function idx = bSpecial(A,x,left,s,n)

    l = s; 
    r = n + 1; 
    while l < r
        m = floor((l + r)/2);
        if xor(~left,isequaln(A(m),x))
            r = m;
        else 
            l = m + 1;
        end
    end
    idx = ~left*(r-1) + left*l; 

%  ------------------------------------------------------------------------------------------------











