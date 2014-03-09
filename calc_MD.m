function MD = calc_MD(d)
%CALC_MD Calculate mean diffusivity
%   Calculates the mean diffusivity using the 6x1 diffusion tensor d
%
%   University of Wisconsin-Madison
%   Nade Sritanyaratana
%   December 1, 2009
%   Version 1.0

MD = (d(:,:,:,1)+d(:,:,:,2)+d(:,:,:,3))/3;