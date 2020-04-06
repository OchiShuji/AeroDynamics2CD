function [F] = animation(x,y,j1,j2,i1,i2,u,v)
%/*************************************************************************
%* File Name     : animation.m
%* Code Title    : 流線のアニメーション作成
%* Programmer    : Shuji Ochi
%* Affiliation   : Dept. of Aeronautics & Astronautics
%* Creation Date : 2020/01/29
%* Language      : Matlab
%* Version       : 1.0.0
%**************************************************************************
%* NOTE:
%*  
%*************************************************************************/

%流線のプロット
draw_square(x,y,j1,j2,i1,i2);
line_num = 80;
startx = min(min(x)).*ones(1,line_num);
starty = linspace(min(min(y)),max(max(y)),line_num);
streamline(x,y,u,v,startx,starty);
drawnow;
F = getframe;


function plt = draw_square(x,y,j1,j2,i1,i2)
    fore = linspace(y(j1,i1),y(j2,i1),1000);
    back = linspace(y(j1,i2),y(j2,i2),1000);
    btm = linspace(x(j1,i1),x(j1,i2),1000);
    top = linspace(x(j2,i1),x(j2,i2),1000);
    plt = plot(x(j1,i1).*ones(1000),fore,"k",x(j1,i2).*ones(1000),back,"k",btm,y(j1,i1).*ones(1000),"k",top,y(j2,i1).*ones(1000),"k");
end

end