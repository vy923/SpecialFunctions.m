function [out] = cosintx(x)
%
% ----------------------------------------------------
% MODS: Added +inf checks
% ----------------------------------------------------
%
%SININT_APPROX A fast approximation of cosint to ~machine precision
%   This function approximates the integral of cos(t)/t for the
%   range of 0 to x. The resulting function is often called Ci(x) as e.g.
%   found at https://en.wikipedia.org/wiki/Trigonometric_integral .
%   The function uses Padé approximants to approximate the form of cosint;
%   one for the range x\in(-4,4) and another for other values of x. The
%   approximating coefficients were derived in Maple.
%
%   NB: The code computes 'res1' and 'res2' for all x, which I found to be
%   faster and less error-prone than computing 'res1' for |x|<=4 and 'res2'
%   for the remaining x. However, in case your 'x' occupies only a
%   particular range (say, only within |x|<4), it may be worth optimizing
%   the code for a further speedup.
%
%   Usage:    Ci_x = cosint_approx(x)
%   where 'x' is an 1xN or Nx1 vector.
%
%   Example: xx=[0:0.001:2]; figure; plot( xx, cosint(xx) - cosint_approx(xx), '.' )
%   
% Made by Erik Koene, 03-Dec-2019, ETH Zürich, Switzerland.

% --- For |x|<=4
xx = x.^2;
res1 = 0.57721566490153286060651209008240243104215933593992 + real(log(x)) + (-0.25 + (0.0075185152443889829088746 + (-0.0001275283422402676857130 + (1.0529736384623918435873691e-6 + (-4.6888950814484801936880887e-9 + (1.0648080289118924347614626e-11 - 9.9372848885758540668407260e-15.*xx).*xx).*xx).*xx).*xx).*xx).*xx ...
     ./(1. + (0.0115926056891107350311684 + (0.0000672126800814254432246 + (2.5553327708612963591027981e-7 + (6.9707129576095894649659328e-10 + (1.3853635277277861897077960e-12 + (1.8910605471305975937023995e-15 + 1.3975961673137685523560053e-18.*xx).*xx).*xx).*xx).*xx).*xx).*xx);
% --- For |x|>4
xa = abs(x);
f = sin(xa).*(1594.49414485728430466332 + (8275.84818940137243992368 + (10162.66725435130728219521 + (4621.09376158198177426960 + (1104.79150340448842011825 + (155.86443071108822510675 + (13.46187152508710208340 + (0.68710640648526182614 + (0.01831638978414741773 + (0.00010731479342397587 + 6.48414130354561676847e-21.*xa).*xa).*xa).*xa).*xa).*xa).*xa).*xa).*xa).*xa) ...
           ./(1055.36600633109566229551 + (7495.20045213474334935414 + (14836.36245684622804160274 + (12114.44595587052587301708 + (4919.15125736805024272896 + (1131.34887326881593964943 + (157.23649773262430321943 + (13.49850430086108383867 + (0.68732103608970899993 + (0.01831638978410423849 + 0.00010731479342401745.*xa).*xa).*xa).*xa).*xa).*xa).*xa).*xa).*xa).*xa);
g = cos(xa).*(182.51168366912221077876 + (1530.28380598126532842505 + (2549.84671726169670626077 + (1038.79858619779457828551 + (213.04792031653464900619 + (25.69147648762354247238 + (1.89479338456939692760 + (0.08136199755970253940 + (0.00170248701236117895 + (-8.08898584293122883292*10^(-17) + 1.42503883826931327455e-20.*xa).*xa).*xa).*xa).*xa).*xa).*xa).*xa).*xa).*xa) ...
           ./(50.84848276040178897437 + (983.14002528084120208960 + (4068.76922048341926039043 + (5923.54873750012648969252 + (3675.25295529027484561335 + (1186.11747942635035473484 + (224.27360249416711211008 + (26.17964925638780558475 + (1.90500830057264324471 + (0.08136199758913992172 + 0.00170248701228424740.*xa).*xa).*xa).*xa).*xa).*xa).*xa).*xa).*xa).*xa);
res2 = (f-g);
% --- Get it all together.
out = res1 .* (xa<=4) + res2 .* (xa>4);
% --- MOD/VY
out(x==inf) = 0;