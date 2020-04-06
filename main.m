%/*************************************************************************
%* File Name     : main.m
%* Code Title    : 剥離流の計算
%* Programmer    : Shuji Ochi
%* Affiliation   : Dept. of Aeronautics & Astronautics
%* Creation Date : 2020/01/15
%* Language      : Matlab
%* Version       : 1.0.0
%**************************************************************************
%* NOTE:
%*  
%*************************************************************************/

clear all; close all;  %全ての変数とFigureを削除

%/*************************************************************************

%% 計算条件の設定(set_flow.m)
[re,cfl,omegap,maxitp,errorp,nlast,nlp] = set_flow();

%% 計算格子の設定(set_grid.m) 
[mx,i1,i2,dx,my,j1,j2,dy,icent,jcent,x,y] = set_grid();

%% 流れを解く
dt = cfl*dx;

%初期条件の設定(init_condition.m)
[nbegin,time,u,v,p] = init_condition(mx,my);
%初期条件に対する境界条件
[p] = bc_for_p(mx,my,p,i1,i2,j1,j2);  %圧力(bc_for_p.m)
[u,v,u_outer_x,u_outer_y,v_outer_x,v_outer_y] = bc_for_v(mx,my,u,v,i1,i2,j1,j2);  %速度(bc_for_v.m)

resps = zeros(1,nlast);
coefs = zeros(4,nlast);

disp("<シミュレーション値の時間推移をモニターします>")
tic
for n = 1:nlast
    % イタレーションの設定
    nstep = n + nbegin;
    time = time + dt;
    
    % 圧力場を解く(solve_p.m)
    [p,resp,itrp] = solve_p(mx,my,i1,i2,j1,j2,dx,dy,dt,maxitp,u,v,p,omegap,errorp);
    
    % 圧力の境界条件を設定(bc_for_p.m)
    [p] = bc_for_p(mx,my,p,i1,i2,j1,j2);
    
    % 速度場を解く(solve_v.m)
    [u,v] = solve_v(mx,my,i1,i2,j1,j2,u,v,p,dx,dy,dt,re,u_outer_x,u_outer_y,v_outer_x,v_outer_y);
    
    % 速度の境界条件を設定(bc_for_v.m)
    [u,v,u_outer_x,u_outer_y,v_outer_x,v_outer_y] = bc_for_v(mx,my,u,v,i1,i2,j1,j2);
    
    %CLとCDの計算:Cpを台形積分(Cp=2p)
    cd = 0.0;
    for j = j1:j2-1
        cpfore = (2.0*p(j,i1)+2.0*p(j+1,i1))/2.0; 
        cpback = (2.0*p(j,i2)+2.0*p(j+1,i2))/2.0;
        cd = cd + (cpfore-cpback)*dy;
    end
    cl = 0.0;
    for i = i1:i2-1
        cpbtm = (2.0*p(j1,i)+2.0*p(j1,i+1))/2.0;
        cptop = (2.0*p(j2,i)+2.0*p(j2,i+1))/2.0;
        cl = cl + (cpbtm-cptop)*dx;
    end
    cp1 = 2.0*p(j1,i2+i2-i1);
    cp2 = 2.0*p(j2,i2+i2-i1);
    if rem(nstep,nlp) == 0
        disp("n="+string(nstep)+" t="+string(time)+" CD="+string(cd)+" CL="+string(cl)+" cp1="+string(cp1)+" cp2="+string(cp2)+" resp="+string(resp)+" itrp="+string(itrp)+newline);
    end
    resps(1,nstep) = resp;
    coefs(1,nstep) = cd;
    coefs(2,nstep) = cl;
    coefs(3,nstep) = cp1;
    coefs(4,nstep) = cp2;
end


%% 流れの可視化
disp("<シミュレーション結果を描画します>")

flow_figs(x,y,p,j1,j2,i1,i2,re,mx,my,dx,dy,u,v,coefs,nlast,dt);