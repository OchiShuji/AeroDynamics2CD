function [p] = bc_for_p(mx,my,p,i1,i2,j1,j2)
%/*************************************************************************
%* File Name     : bc_for_p.m
%* Code Title    : ˆ³—Í‚Ì‹«ŠEğŒ‚Ìİ’è
%* Programmer    : Shuji Ochi
%* Affiliation   : Dept. of Aeronautics & Astronautics
%* Creation Date : 2020/01/28
%* Language      : Matlab
%* Version       : 1.0.0
%**************************************************************************
%* NOTE:
%*  
%*************************************************************************/


%ŒŸ¸—ÌˆæŠO‰
for j = 1:my
    p(j,1) = 0.0;
    p(j,mx) = 0.0;
end

for i = 1:mx
    p(1,i) = 0.0;
    p(my,i) = 0.0;
end

%Šp’Œü‚è‚Ì‹«ŠEğŒ
p(j1,i1) = p(j1-1,i1-1);
p(j2,i1) = p(j2+1,i1-1);
p(j1,i2) = p(j1-1,i2+1);
p(j2,i2) = p(j2+1,i2+1);

for j = j1+1:j2-1
    p(j,i1) = p(j,i1-1);
    p(j,i2) = p(j,i2+1);
end

for i = i1+1:i2-1
    p(j1,i) = p(j1-1,i);
    p(j2,i) = p(j2+1,i);
end

end