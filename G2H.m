function H = G2H(G)
%G2H Convert G to H
%   Converts a gradient encoding MATRIX(G) to a diffusion encoding
%   matrix(H).
%
%   University of Wisconsin-Madison
%   Nade Sritanyaratana
%   November 30, 2009
%   Version 1.0

%check to see if G contains only 3 columns (gx,gy,gz).
if size(G,2)~=3
    error('G is of the wrong size; make sure G has only 3 rows (gx,gy,gz)');
end

H=[];
for i=1:size(G,1)
    g=G(i,:);
    h=g2h(g);
    H=[H,h];
end

H=H';