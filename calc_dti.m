function [d t2s] = calc_dti(dirname, slices, volumes, G, b, mask)
%CALC_DTI Calculate DTI parameters
%   Calculates the DTI vector from a folder containing DICOM files using 
%   the naming convention provided by Jee Eun Lee.
%
%   Inputs:
%      dirname - directory name which contains the DICOM files
%      slices - number of slices per volume
%      volumes - number of volumes
%      G - encoding gradient matrix
%      b - b factor (if not indicated, then assumed to be 1000)
%
%   Outputs:
%       d - DTI vector
%       t2s - T2* weighted image
%       
%
%   University of Wisconsin-Madison
%   Nade Sritanyaratana
%   November 30, 2009

%Check to see if specified folder exists under MATLAB's search path
if exist(dirname,'dir')~=7
    error('ERROR: The specified folder could not be found');
end

if exist('b','var')~=1||b==-1
    b=1000;
end

if exist('mask','var')~=1
    mask=1;
else
    %check if mask is the right size (i.e. contains enough slices to cover
    %a volume.)
    if size(mask,3)~=slices
        error('mask does not contain as many slices as specified in get_Y(dirname,slices...)');
    end
end

%prepare the image data to be used for calculating d
[Y height width t2s] = get_Y(dirname,slices,volumes,b,mask);

%convert G to H
H = G2H(G);

d = pinv(H'*H)*H'*Y;
%reshape d back to its img dimensions
d = reshape(d,[6 height width slices]);
%permute it to make it viewable on volume viewer
d = permute(d,[2 3 4 1]);

% throw out bad numbers and assign them some reference number
% badnumbers = (isnan(d)+isinf(d)+isinf(-d));
% d = d.*(badnumbers==0)+badnumbers.*-1;