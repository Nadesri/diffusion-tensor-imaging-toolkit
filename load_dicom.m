function [img info] = load_dicom(fname)
%LOAD_DICOM Load specified DICOM file
%   load_dicom loads the image and the metadata of a DICOM file of the
%   specified file name.
%
%   University of Wisconsin-Madison
%   Nade Sritanyaratana
%   November 30, 2009
%   Version 1.0

if exist(fname)~=2
    error('ERROR: The specified DICOM file could not be found in this directory');
end

info = dicominfo(fname);
img = dicomread(info);