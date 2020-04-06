function [u,v,u_outer_x,u_outer_y,v_outer_x,v_outer_y] = bc_for_v(mx,my,u,v,i1,i2,j1,j2)
%/*************************************************************************
%* File Name     : bc_for_v.m
%* Code Title    : 速度の境界条件の設定
%* Programmer    : Shuji Ochi
%* Affiliation   : Dept. of Aeronautics & Astronautics
%* Creation Date : 2020/01/27
%* Language      : Matlab
%* Version       : 1.0.0
%**************************************************************************
%* NOTE:
%*  
%*************************************************************************/

%検査領域の一つ外側での値が必要
u_outer_y = zeros(my,2);
u_outer_x = zeros(2,mx);
v_outer_y = zeros(my,2);
v_outer_x = zeros(2,mx);

%流入&流出
for j = 1:my
    u(j,1) = 1.0;
    v(j,1) = 0.0;
    u_outer_y(j,1) = 1.0;
    v_outer_y(j,1) = 0.0;
    
    u(j,mx) = 2.0*u(j,mx-1)-u(j,mx-2);
    v(j,mx) = 2.0*v(j,mx-1)-v(j,mx-2);
    u_outer_y(j,2) = 2.0*u(j,mx)-u(j,mx-1);
    v_outer_y(j,2) = 2.0*v(j,mx)-v(j,mx-1);
end

%上縁&下縁
for i = 1:mx
    u(1,i) = 2.0*u(2,i)-u(3,i);
    v(1,i) = 2.0*v(2,i)-v(3,i);
    u_outer_x(1,i) = 2.0*u(1,i)-u(2,i);
    v_outer_x(1,i) = 2.0*v(1,i)-v(2,i);
    
    u(my,i) = 2.0*u(my-1,i)-u(my-2,i);
    v(my,i) = 2.0*v(my-1,i)-v(my-2,i);
    u_outer_x(2,i) = 2.0*u(my,i)-u(my-1,i);
    v_outer_x(2,i) = 2.0*v(my,i)-v(my-1,i);
end

%角柱周り
for i = i1:i2
    for j = j1:j2
        u(j,i) = 0.0;
        v(j,i) = 0.0;
    end
end