function flow_figs(x,y,p,j1,j2,i1,i2,re,mx,my,dx,dy,u,v,coefs,nlast,dt)
%/*************************************************************************
%* File Name     : flow_figs.m
%* Code Title    : 流れの可視化
%* Programmer    : Shuji Ochi
%* Affiliation   : Dept. of Aeronautics & Astronautics
%* Creation Date : 2020/01/29
%* Language      : Matlab
%* Version       : 1.0.0
%**************************************************************************
%* NOTE:
%*  
%*************************************************************************/

%等圧線
figure(1);
draw_square(x,y,j1,j2,i1,i2);
level_p = linspace(-0.5,0.5,25);
contour(x,y,p,level_p);
title("等圧線(Re="+string(re)+")");

%等渦度線
omega = zeros(my,mx);
for i = 2:mx-1
    for j = 2:my-1
        omega(j,i) = (v(j,i+1)-v(j,i-1))/(2.0*dx) - (u(j+1,i)-u(j-1,i))/(2.0*dy);
    end
end
figure(2);
draw_square(x,y,j1,j2,i1,i2);
level_ome = linspace(-4.0,4.0,50);
contour(x,y,omega,level_ome);
title("等渦度線(Re="+string(re)+")");

%空力係数の変化の時間履歴
figure(3);
t = linspace(0,dt*nlast,nlast);
plot(t,coefs(1,:),t,coefs(2,:),t,coefs(3,:),t,coefs(4,:));
legend("CD","CL","Cp1","Cp2");
title("空力係数の変化の時間履歴(Re="+string(re)+")");
xlabel("time");
xlim([0 dt*nlast]);
ylim([-2.0,2.0]);

%流線のプロット
figure(4);
draw_square(x,y,j1,j2,i1,i2);
line_num = 80;
startx = min(min(x)).*ones(1,line_num);
starty = linspace(min(min(y)),max(max(y)),line_num);
streamline(x,y,u,v,startx,starty);

%ベクトルを矢印で表現
figure(5);
draw_square(x,y,j1,j2,i1,i2);
for i = 2:mx
    for j = 2:my
        if (rem(i,2) == 0)&&(rem(j,2) == 0)
            continue
        end
        u(j,i) = 0.0;
        v(j,i) = 0.0;
    end
end
quiver(x,y,u,v,3);


 function plt = draw_square(x,y,j1,j2,i1,i2)
     fore = linspace(y(j1,i1),y(j2,i1),1000);
     back = linspace(y(j1,i2),y(j2,i2),1000);
     btm = linspace(x(j1,i1),x(j1,i2),1000);
     top = linspace(x(j2,i1),x(j2,i2),1000);
     plt = plot(x(j1,i1).*ones(1000),fore,"k",x(j1,i2).*ones(1000),back,"k",btm,y(j1,i1).*ones(1000),"k",top,y(j2,i1).*ones(1000),"k");
 end

end