function [d MD FA t2s] = get_dti_meas(dirname, slices, volumes, G, b, mask)
%GET_DTI_MEAS Get DTI Measurements
%   Wrapper function for calculating diffusion tensor, mean diffusivity,
%   and fractional anisotropy.
%
%   Inputs:
%      dirname - directory name which contains the DICOM files
%      slices - number of slices per volume
%      volumes - number of volumes
%      G - encoding gradient matrix
%
%   Outputs:
%       d - DTI vector
%       MD - Mean diffusivity
%       FA - Fractional anisotropy
%       t2s - T2* weighted image
%
%   University of Wisconsin-Madison
%   Nade Sritanyaratana
%   December 1, 2009
%   Version 1.0

%Check to see if specified folder exists under MATLAB's search path
if exist(dirname)~=7
    error('ERROR: The specified folder could not be found');
end

%Calculate Diffusion Tensor
[d t2s] = calc_dti(dirname, slices, volumes, G, b, mask);

%Calculate Mean Diffusivity
MD = calc_MD(d);

%Calculate Fractional Anisotropy
FA = calc_FA(d,MD);