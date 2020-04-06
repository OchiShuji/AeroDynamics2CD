function [nbegin,time,u,v,p] = init_condition(mx,my)
%/*************************************************************************
%* File Name     : init_condition.m
%* Code Title    : ‰ŠúğŒ‚Ìİ’è
%* Programmer    : Shuji Ochi
%* Affiliation   : Dept. of Aeronautics & Astronautics
%* Creation Date : 2020/01/28
%* Language      : Matlab
%* Version       : 1.0.0
%**************************************************************************
%* NOTE:
%*  
%*************************************************************************/
nbegin = 0;
time = 0.0;

u = zeros(my,mx);
v = zeros(my,mx);
p = zeros(my,mx);

%ˆê—l—¬‘¬ğŒ‚ğ—^‚¦‚é
for i = 1:mx
    for j = 1:my
        u(j,i) = 1.0;
        v(j,i) = 0.0;
        p(j,i) = 0.0;
    end
end
end
