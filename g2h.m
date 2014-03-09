function h = g2h(g)
%G2H Convert g to h
%   Converts a gradient encoding vector(g) to an diffusion encoding
%   vector(h).
%
%   University of Wisconsin-Madison
%   Nade Sritanyaratana
%   November 30, 2009
%   Version 1.0

%check to see if g contains only gx, gy, gz (length(g) returns 3)
if length(g)~=3
    error('g is the wrong length; check to see if g has only a gx,gy, and gz component');
end

gx=g(1); gy=g(2); gz=g(3);

h = [gx^2 gy^2 gz^2 2*gx*gy 2*gx*gz 2*gy*gz]';