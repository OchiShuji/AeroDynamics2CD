function [p,resp,itrp] = solve_p(mx,my,i1,i2,j1,j2,dx,dy,dt,maxitp,u,v,p,omegap,errorp) 
%/*************************************************************************
%* File Name     : solve_p.m
%* Code Title    : 緩和法によるポアソン方程式の解法
%* Programmer    : Shuji Ochi
%* Affiliation   : Dept. of Aeronautics & Astronautics
%* Creation Date : 2020/01/28
%* Language      : Matlab
%* Version       : 1.0.0
%**************************************************************************
%* NOTE:
%*  角柱内は計算をスキップ
%*************************************************************************/

rhs = zeros(my,mx);

for i = 2:mx-1
    for j = 2:my-1
        if (i >= i1) && (i <= i2) && (j >= j1) && (j <= j2)
            continue
        end
        ux = (u(j,i+1)-u(j,i-1))/(2.0*dx);   
        uy = (u(j+1,i)-u(j-1,i))/(2.0*dy);   
        vx = (v(j,i+1)-v(j,i-1))/(2.0*dx); 
        vy = (v(j+1,i)-v(j-1,i))/(2.0*dy);   
        rhs(j,i) = (ux+vy)/dt - (ux^2+2.0*uy*vx+vy^2);
    end
end

for itr = 1:maxitp
    res = 0.0;  %residual
    for i = 2:mx-1
        for j = 2:my-1
            if (i >= i1) && (i <= i2) && (j >= j1) && (j <= j2)
                continue
            end
            dp = (p(j,i+1)+p(j,i-1))/dx/dx + (p(j+1,i)+p(j-1,i))/dy/dy - rhs(j,i);
            dp = dp/(2.0/dx/dx + 2.0/dy/dy) - p(j,i);
            res = res + dp^2;
            p(j,i) = p(j,i) + omegap*dp;
        end
    end
    [p] = bc_for_p(mx,my,p,i1,i2,j1,j2);
    res = sqrt(res/mx/my);
    if res < errorp
        break
    end
end

% dp = zeros(my-2,1);
% res = zeros(my-2);
% for itr = 1:maxitp
%     res = 0.0;
%     for i = 2:mx-1
%         dp(:,1) = (p(2:my-1,i+1)+p(2:my-1,i-1))./dx./dx + (p(3:my,i)+p(1:my-2,i))./dy./dy - rhs(2:my-1,i);
%         dp(:,1) = dp(:,1)./(2.0/dx/dx + 2.0/dy/dy) - p(2:my-1,i);
%         res = res + dp.^2;
%         p(2:my-1,i) = p(2:my-1,i) + dp(:,1).*omegap;
%     end
%     [p] = bc_for_p(mx,my,p,i1,i2,j1,j2);
%     res_tot = sum(res);
%     res_tot = sqrt(res_tot/mx/my);
%     if res_tot < errorp
%         break
%     end
% end

resp = res;
itrp = itr;

end