function [Y height width S0] = get_Y(dirname,slices,volumes,b,mask)
%GET_Y Get reshaped diffusion measurements Y
%   Gets the DICOM files following the naming protocol (as was provided by 
%   Jee Eun Lee) and compiles them into a composite matrix Y for all the 
%   slices/volumes.
%
%   Inputs:
%   dirname - directory name which contains the DICOM files
%   slices - number of slices per volume
%   volumes - number of volumes
%   b - b factor, optional (if not indicated or indicated as -1, then assumed to be 1000)
%   mask - mask, optional
%
%   Outputs:
%   Y - diffusion measurements reshaped to a matrix of size (volumes-1)x(height*width*slices)
%   height - original # of pixels of image in y direction
%   width - original # of pixels of image in x direction
%   S0 - reference image (where b=0)
%
%   University of Wisconsin-Madison
%   Nade Sritanyaratana
%   December 1, 2009

%Check if the directory exists in MATLAB's search path
if exist(dirname,'dir')~=7
    error('ERROR: Specified directory name could not be found');
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

%Check if the number of files in the directory equals slices*volumes
if length(dirlisting)~=slices*volumes
    length(dirlisting)
    slices*volumes
    error('ERROR: The number of DICOM files found do not match the specified slices*volumes');
end

%compile reference image which is assumed to be the first volume.
S0=[];
for i=1:slices
    fname = dirlisting(i).name;
    img = dicomread(fname);
    img = double(img);

    height = size(img,1);
    width = size(img,2);
    img = reshape(img, [1 height*width]);

    S0=[S0;img];
end

%For each iteration create a y and compile into Y
Y=[];
tic
w=waitbar(0,'Compiling Y...');
for i=2:volumes
    
    y=[];
    for j=1:slices
        k=slices*(i-1)+j;
        waitbar(k/length(dirlisting),w);
        
        fname = dirlisting(k).name;
        S = dicomread(fname);
        S = double(S);
        
        height = size(S,1);
        width = size(S,2);
        S = reshape(S, [1 height*width]);

        submask = mask(:,:,j);
        submask = reshape(submask, [1 height*width]);
        
        yslice = -log((S+1)./(S0(j,:)+1))/b;
        yslice = yslice.*submask;
        
        %fix for inf
        %yslice = yslice.*(~isinf(yslice))+isinf(yslice);
        %yslice = yslice.*(~isinf(yslice))+-isinf(-yslice);
        %badnumbers = (isnan(yslice)+isinf(yslice)+isinf(-yslice));
        %yslice = yslice.*(badnumbers==0)+badnumbers.*-1;
        
        y=[y,yslice];
    end
    y = y';
    
    Y=[Y,y];
end
close(w)
disp('Y Compiled!')
toc

Y=Y';
S0 = permute(S0,[2 1]);
S0 = reshape(S0, [height width slices]);