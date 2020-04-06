function [mx,i1,i2,dx,my,j1,j2,dy,icent,jcent,x,y] = set_grid()
%/*************************************************************************
%* File Name     : set_grid.m
%* Code Title    : åvéZäiéqÇÃê›íË
%* Programmer    : Shuji Ochi
%* Affiliation   : Dept. of Aeronautics & Astronautics
%* Creation Date : 2020/01/27
%* Language      : Matlab
%* Version       : 1.0.0
%**************************************************************************
%* NOTE:
%*  
%*************************************************************************/

mx = 401;    %401
i1 = 96;    %96
i2 = 106;    %106
dx = 1.0 / (i2-i1);

my = 201;    %201
j1 = 96;     %96
j2 = 106;    %106
dy = 1.0 / (j2-j1);

icent = (i1+i2)*0.5;  %äpíåÇÃíÜâõç¿ïW
jcent = (j1+j2)*0.5;

x = zeros(my,mx);
y = zeros(my,mx);

for i = 1:mx
    for j = 1:my
        x(j,i) = dx*(i-icent);
        y(j,i) = dy*(j-jcent);
    end
end
end