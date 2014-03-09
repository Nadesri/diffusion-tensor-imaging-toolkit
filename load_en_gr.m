function G = load_en_gr(fname)
%LOAD_EN_GR Load Encoding Gradients
%   Loads the encoding gradients as an H matrix from an me12b.txt 
%   file. Files provided from Jee Eun Lee under Prof. Andy Alexander.
%
%   Inputs: fname - file name, as a string
%   Outputs: G - encoding gradient matrix
%
%   University of Wisconsin-Madison
%   Nade Sritanyaratana
%   November 20, 2009
%   Version 1.0

% Check if pathname was specified
if exist('fname')~=1
    fname = 'me12b.txt';
end

% Load in me12b.txt as a text file
fid = fopen(fname, 'r');  % For READ

G=[];

% Readout each line in the txt file
while 1
  % Get the next line
  currLine = fgetl(fid);
  
  % If we reached the end, exit
  if isempty(currLine)
    break;
  end
  
 if currLine == -1
   break;
 end
% if length(currLine)==0;
%     nextLine = fgetl(fid);
%     if isempty(nextLine)||nextLine==-1
%         break;
%     else
%         currLine = nextLine;
%     end
% end
  
 % remove insignificant whitespace
 currLine = strtrim(currLine);
 
  % Split line by 2-3 spaces
  currLine = regexp(currLine, '   ?','split');
  
  %There should be 3 parts, or this is not a valid encoding gradient line
  if length(currLine) ~= 3
    error('Invalid line. File may be corrupt or invalid');
  end
  
  g=[];
  for i=1:3
      g(i)=str2double(currLine(i));
  end
  
  g=g';
  G=[G,g];
  
end

G=G';