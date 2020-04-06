function [u,v] = solve_v(mx,my,i1,i2,j1,j2,u,v,p,dx,dy,dt,re,u_outer_x,u_outer_y,v_outer_x,v_outer_y)
%/*************************************************************************
%* File Name     : solve_v.m
%* Code Title    : Kawamura schemeの適用
%* Programmer    : Shuji Ochi
%* Affiliation   : Dept. of Aeronautics & Astronautics
%* Creation Date : 2020/01/28
%* Language      : Matlab
%* Version       : 1.0.0
%**************************************************************************
%* NOTE:
%*  角柱内は計算をスキップ
%*************************************************************************/
urhs = zeros(my,mx);  
vrhs = zeros(my,mx); 

%% 圧力勾配の計算
for i = 2:mx-1
    for j = 2:my-1
        if (i >= i1) && (i <= i2) && (j >= j1) && (j <= j2)
            continue
        end
        urhs(j,i) = -(p(j,i+1)-p(j,i-1))/(2.0*dx);
        vrhs(j,i) = -(p(j+1,i)-p(j-1,i))/(2.0*dy);
    end
end

%% 粘性項の追加
for i = 2:mx-1
    for j = 2:my-1
        if (i >= i1) && (i <= i2) && (j >= j1) && (j <= j2)
            continue
        end
        urhs(j,i) = urhs(j,i)+(u(j,i+1)-2.0*u(j,i)+u(j,i-1))/(re*dx^2)+(u(j+1,i)-2.0*u(j,i)+u(j-1,i))/(re*dy^2);
        vrhs(j,i) = vrhs(j,i)+(v(j,i+1)-2.0*v(j,i)+v(j,i-1))/(re*dx^2)+(v(j+1,i)-2.0*v(j,i)+v(j-1,i))/(re*dy^2);
    end
end

%% 移流項の追加
%kawamura schemeの計算
function adv_term = kawamura_xx(x1,x2,x3,x4,x5,delta)
    adv_term = -x3*(-x5+8.0*(x4-x2)+x1)/(12.0*delta)-abs(x3)*(x5-4.0*x4+6.0*x3-4.0*x2+x1)/(4.0*delta);
end

function adv_term = kawamura_xy(x1,x2,x3,y3,x4,x5,delta)
    adv_term = -y3*(-x5+8.0*(x4-x2)+x1)/(12.0*delta)-abs(y3)*(x5-4.0*x4+6.0*x3-4.0*x2+x1)/(4.0*delta);
end

%x方向
for j = j1+1:j2-1       %角柱内部の値が必要(線形外挿)
    u(j,i1+1) = 2.0*u(j,i1)-u(j,i1-1);
    u(j,i2-1) = 2.0*u(j,i2)-u(j,i2+1);
    v(j,i1+1) = 2.0*v(j,i1)-v(j,i1-1);
    v(j,i2-1) = 2.0*v(j,i2)-v(j,i2+1);
end

for i = 2:mx-1
    for j = 2:my-1
        if (i >= i1) && (i <= i2) && (j >= j1) && (j <= j2)
            continue
        end
        if i == 2
            urhs(j,i) = urhs(j,i) + kawamura_xx(u_outer_y(j,1),u(j,i-1),u(j,i),u(j,i+1),u(j,i+2),dx);
            vrhs(j,i) = vrhs(j,i) + kawamura_xy(v_outer_y(j,1),v(j,i-1),v(j,i),u(j,i),v(j,i+1),v(j,i+1),dx);      
        elseif i == mx-1  
            urhs(j,i) = urhs(j,i) + kawamura_xx(u(j,i-2),u(j,i-1),u(j,i),u(j,i+1),u_outer_y(j,2),dx);
            vrhs(j,i) = vrhs(j,i) + kawamura_xy(v(j,i-2),v(j,i-1),v(j,i),u(j,i),v(j,i+1),v_outer_y(j,2),dx);
        else
            urhs(j,i) = urhs(j,i) + kawamura_xx(u(j,i-2),u(j,i-1),u(j,i),u(j,i+1),u(j,i+2),dx);
            vrhs(j,i) = vrhs(j,i) + kawamura_xy(v(j,i-2),v(j,i-1),v(j,i),u(j,i),v(j,i+1),v(j,i+1),dx);
        end
    end
end

%y方向
for i = 2:mx-1
    for j = 2:my-1
        if (i >= i1) && (i <= i2) && (j >= j1) && (j <= j2)
            continue
        end
        if j == 2
            urhs(j,i) = urhs(j,i) + kawamura_xy(u_outer_x(1,i),u(j-1,i),u(j,i),v(j,i),u(j+1,i),u(j+2,i),dy);
            vrhs(j,i) = vrhs(j,i) + kawamura_xx(v_outer_x(1,i),v(j-1,i),v(j,i),v(j+1,i),v(j+2,i),dy);
        elseif j == my-1
            urhs(j,i) = urhs(j,i) + kawamura_xy(u(j-2,i),u(j-1,i),u(j,i),v(j,i),u(j+1,i),u_outer_x(2,i),dy);
            vrhs(j,i) = vrhs(j,i) + kawamura_xx(v(j-2,i),v(j-1,i),v(j,i),v(j+1,i),v_outer_x(2,i),dy);
        else
            urhs(j,i) = urhs(j,i) + kawamura_xy(u(j-2,i),u(j-1,i),u(j,i),v(j,i),u(j+1,i),u(j+2,i),dy);
            vrhs(j,i) = vrhs(j,i) + kawamura_xx(v(j-2,i),v(j-1,i),v(j,i),v(j+1,i),v(j+2,i),dy);
        end
    end
end

%% 時間幅に対して更新
for i = 2:mx-1
    for j =2:my-1
        if (i >= i1) && (i <= i2) && (j >= j1) && (j <= j2)
            continue
        end
        u(j,i) = u(j,i) + dt*urhs(j,i);
        v(j,i) = v(j,i) + dt*vrhs(j,i);
    end
end

end