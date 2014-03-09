function [set] = load_dicom_set(dirname, slices)
%WARNING: LOAD_DICOM_SET IS NOW OBSOLETE. SEE LOAD_DICOM TO LOAD WHOLE
%   DICOM SERIES OVER A GIVEN DIRECTORY.
%
%LOAD_DICOM_SET Load DICOM Set
%   Loads a DICOM set from the specified slices.
%
%   For example, load_dicom_set('DICOM', 1:39) will open all DICOM files
%   from DICOM.0001 to DICOM.0039.
%
%   University of Wisconsin-Madison
%   Nade Sritanyaratana
%   December 3, 2009
%   Version 1.0

%Check if the directory exists in MATLAB's search path
if exist(dirname,'dir')~=7
    error('ERROR: Specified directory name could not be found');
end

%Grab the last name of the directory for the DICOM naming convention
[success attribs msg] = fileattrib(dirname);
name = attribs.Name;
dirs = regexp(name,'/','split');
lastname = dirs{end};

%Grab the list directory structure to get all the files
%TODO: fnames should match anything lastname.* where * is any number
%   combination.
fnames = strcat(lastname,'.0*');
dirlisting = dir(fnames);

%load only the specified images and compile them into one set object.
set=[];
i=1;
for slice=slices
    fname = dirlisting(slice).name;
    [img] = load_dicom(fname);
    img = double(img);

    set(:,:,i)=img;
    i=i+1;
end