import numpy as np 
from matplotlib import pyplot as plt 

n = 1000
eta = np.linspace(0.01,1.8,n)
u = np.zeros(n)

for i in range(0,n-1):
    if eta[i]>1.0:
        u[i] = 1.0 
    else:
        u[i] = 2*eta[i] - eta[i]*eta[i]

plt.plot(u,eta)
plt.ylim(0,1.5)
plt.xlabel(r"$\frac{u}{U_e}$")
plt.ylabel(r"$\frac{y}{\delta}$")
plt.show()