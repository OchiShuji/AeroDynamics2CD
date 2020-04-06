import numpy as np 
from matplotlib import pyplot as plt 
from tqdm import tqdm
import math

#---------------------
#計算不能(記2020/04/07)
#---------------------

#----計算条件----
rho0 = 1.225  #空気密度
t0 = 293.0  #気温
visc = 0.000001458*t0**1.5/(t0+110.4)  #粘性係数
width = 0.5  #代表長さ
v0 = 20.0  #一様流速
re0 = rho0*v0*width / visc  #レイノルズ数
blt = width*5.3/np.sqrt(re0)  #境界層厚さ

#----計算格子----
nx = 50000
dx = width / float(nx)
ny = 200
ymax = blt * 2.0
dy = ymax / float(ny)
y = np.zeros(ny+1)
for i in range(0,ny):
    y[i+1] = y[i] + dy

u = np.zeros((ny+1,nx+1))
v = np.zeros((ny+1,nx+1))

#----スタート条件(i=1)----
u[:,0] = v0*np.ones(ny+1)
u[0,0] = 0.0
v[:,0] = np.zeros(ny+1)
print(u)
print(v)

for i in tqdm(range(0,nx)):
    for j in range(1,ny-1):
        dudy1 = (u[j+1,i]-u[j-1,i])/(2.0*dy)
        dudy2 = (u[j+1,i]-2.0*u[j,i]+u[j-1,i])/dy/dy
        if (abs(dudy2*visc/rho0-v[j,i]*dudy1)<=0.0):
            dudx = 0.0
        else:
            dudx  = (dudy2*visc/rho0-v[j,i]*dudy1)/u[j,i]
        u[j,i+1]  = u[j,i]+dx*dudx

    #----境界条件----
    u[0,i+1] = 0.0
    u[ny,i+1] = v0
    v[0,i+1] = 0.0

    #----i+1でのv----
    for j in range(0,ny-1):
        dudx1 = (u[j,i+1]-u[j,i])/dx
        dudx2 = (u[j+1,i+1]-u[j+1,i])/dx
        v[j,i+1] = v[j-1,i+1]-(dudx1+dudx2)*dy/2.0

print(u)
print(v)


