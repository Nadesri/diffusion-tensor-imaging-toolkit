function FA = calc_FA(d,MD)
%CALC_FA Calculate Fractional Anisotropy
%   Calculates the fractional anisotropy using the 6x1 diffusion tensor d
%
%   University of Wisconsin-Madison
%   Nade Sritanyaratana
%   December 1, 2009
%   Version 1.0

tic
w = waitbar(0,'Calculating Free Anisotropy...');
%   In order to find the eigenvalues, each diffusion tensor needs to be
%   rehashed into a tensor matrix
EV=[];
FA=[];
for i=1:size(d,1)
    for j=1:size(d,2)
        for k=1:size(d,3)
            %dte: diffusion tensor element
            dte=d(i,j,k,:);
            md=MD(i,j,k);
            
            matrix= [dte(1)  dte(4)  dte(5);
                dte(4)  dte(2)  dte(6);
                dte(5)  dte(6)  dte(3)];
            ev = eig(matrix);
            
            fa2 = ((ev(1)-md)^2+(ev(2)-md)^2+(ev(3)-md)^2) / ... 
                (2*(ev(1)^2+ev(2)^2+ev(3)^2));
            fa=sqrt(fa2);
            
            EV(i,j,k,:) = ev;
            FA(i,j,k) = fa;
            
            waitbar((size(d,2)*size(d,3)*(i-1)+size(d,3)*(j-1)+k)/(size(d,1)*size(d,2)*size(d,3)),w);
        end
    end
end
close(w)
disp('Free Anisotropy Calculated!');
toc