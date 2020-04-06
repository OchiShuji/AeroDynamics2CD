%/*************************************************************************
%* File Name     : aerodynamics_c1.m
%* Code Title    : ‰Û‘è1: ‹«ŠE‘w•û’ö®‚Ì”’lŒvZ
%* Programmer    :
%* Affiliation   : 
%* Creation Date : 2019/12/09
%* Language      : Matlab
%* Version       : 1.0.0
%**************************************************************************
%* NOTE:
%*  
%*************************************************************************/

clear all; close all;  %‘S‚Ä‚Ì•Ï”‚ÆFigure‚ğíœ

%/*************************************************************************

% ğŒ‚Ìİ’è
rho0 = 1.225;
t0   = 293.0;
visc = 1.458e-6*t0^1.5/(t0+110.4);
width = 0.5;
v0 = 20.0;
re0 = rho0*v0*width/visc;
blt = width*5.3/sqrt(re0);  % ‹«ŠE‘wŒú‚³(blasius)

% ŒvZŠiq
nx = 524288;
dx = width / nx;
ny = 200;
y = zeros(1,ny+1);
x = zeros(1,nx+1);
ymax = 2.0*blt;
dy = ymax/ny;
for j = 1:ny+1
    y(j)=dy*(j-1);
end

for i = 1:nx+1
    x(i)=dx*(i-1);
end


u = zeros(ny+1,nx+1);     %x•ûŒü‘¬“x•ª•z
u_ref = zeros(ny+1,nx+1); %x•ûŒü–³ŸŒ³‘¬“x•ª•z
v = zeros(ny+1,nx+1);     %y•ûŒü–³ŸŒ³‘¬“x•ª•z
px = 0.00105*1.013e+5;     %(‹t)ˆ³—ÍŒù”z

for j = 1:ny+1
    u(j,1) = v0;
    v(j,1) = 0.0;
end

bl_profile = zeros(ny+1,9);     %‹«ŠE‘wƒvƒƒtƒ@ƒCƒ‹@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
cf_profile = zeros(1,nx+1);     %•\–Ê–€CŒW”
blt_del = zeros(1,nx+1);        %‹«ŠE‘wŒú‚³
blt_del_star = zeros(1,nx+1);   %”rœŒú
blt_theta = zeros(1,nx+1);      %‰^“®—ÊŒú
    
for i = 1:nx
    % u‚ğy•ûŒü‚É‡ŸŒvZ
    for j = 2:ny
        dudy1 = (u(j+1,i)-u(j-1,i))/(2.0*dy);
        dudy2 = (u(j+1,i)-2.0*u(j,i)+u(j-1,i))/dy^2;
        dudx = (dudy2*visc/rho0-v(j,i)*dudy1-px/rho0)/u(j,i);
        u(j,i+1) = u(j,i)+dx*dudx;
        u_ref(j,i+1)=u(j,i+1)./v0;
        
        %‹«ŠE‘wŒú‚³(@ 0.995)
        if (and(u_ref(j,i+1)>=0.990,u_ref(j,i+1)<=0.995))
            blt_del(i+1) = y(j);
        end      
    end
    
    %‹«ŠEğŒ
    u(1,i+1) = 0.0;
    u(ny+1,i+1)= u(ny,i+1);
    v(1,i+1) = 0.0;
    
    %v‚ğy•ûŒü‚É‡ŸŒvZ
    for j = 2:ny 
        dudx1 = (u(j,i+1)-u(j,i))/dx;
        dudx2 = (u(j+1,i+1)-u(j+1,i))/dx;
        v(j,i+1)  = v(j-1,i+1)-(dudx1+dudx2)*dy/2.0;
    end
    
    %‹«ŠE‘w‚Ìƒvƒƒtƒ@ƒCƒ‹‚ğŒvZ
    for k = 1:9
        if (i+1 == k*10000*15)
            bl_profile(:,k)= x(i+1)+u(:,i+1).*(width/10/v0);
        end
    end
    
    %•\–Ê–€CŒW”
    cf_profile(i+1) = 2*visc*(u(2,i+1)-u(1,i+1))/dy/rho0/v0/v0;
    
    %”rœŒú
    for j = 1:ny
        f = 1-u(j,i)/v0;
        fn = 1-u(j+1,i)/v0;
        blt_del_star(i) = blt_del_star(i)+(f+fn)*dy*0.5; %‘äŒ`Ï•ª
    end
    
    %‰^“®—ÊŒú
    for j = 1:ny
        g = u(j,i)/v0*(1-u(j,i)/v0);
        gn = u(j+1,i)/v0*(1-u(j+1,i)/v0);
        blt_theta(i) = blt_theta(i)+(g+gn)*dy*0.5; %‘äŒ`Ï•ª
    end
end


plot(x,blt_del,bl_profile(:,1),y,bl_profile(:,2),y,bl_profile(:,3),y,bl_profile(:,4),y,bl_profile(:,5),y,bl_profile(:,6),y,bl_profile(:,7),y,bl_profile(:,8),y,bl_profile(:,9),y,"LineWidth",1.0);
xlabel('x[m]');
ylabel('y[m]');
pbaspect([5,1,1]);



    


