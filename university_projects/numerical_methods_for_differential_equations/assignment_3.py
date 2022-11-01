#!/usr/bin/env python
# coding: utf-8

# In[1]:


#Import statements 
import scipy
import scipy.linalg
from scipy.linalg import expm, norm, eigvals, solve, toeplitz, eig, eigh, inv
import numpy as np 
import matplotlib
import matplotlib.pyplot as plt
from scipy.integrate import solve_ivp
from matplotlib import rc
import time
import pandas as pd
from matplotlib.pyplot import figure as fig
from sklearn.linear_model import LinearRegression
from matplotlib import cm

#Fonts and stuff 
matplotlib.rcParams['mathtext.fontset'] = 'stix'
matplotlib.rcParams['font.family'] = 'STIXGeneral'


# In[2]:


from mpl_toolkits import mplot3d


# In[3]:


get_ipython().run_line_magic('matplotlib', 'inline')


# In[4]:


#get widescrean display to write more easily
from IPython.core.display import display, HTML
display(HTML("<style>.container { width:100% !important; }</style>"))


# In[5]:


#Task 1
def get_T(L, N):
    delta_x = L / (N+1)
    T = toeplitz(np.concatenate([np.array([-2,1]), np.zeros(N-2)], axis = 0),
    np.concatenate([np.array([-2,1]), np.zeros(N-2)], axis = 0)) / delta_x**2
    return T

def eulerstep(Tdx, uold, dt):
    return uold + dt * Tdx.dot(uold)

class boundry_test():
    def g(self,x):
        return -x*(x-1)
    
    def h(self,x):
        return -x*(x-1)*np.exp(-(4*(x-3/4))**2)
    def advection(self, x):
        return np.exp(-100*(x-0.5)**2)

def diffusion(boundry, N, M, L, t0, tf):
    delta_x = L / (N+1)
    delta_t =  (tf-t0)/ M
    
    x = np.linspace(delta_x, L-delta_x, N)
    t = np.linspace(0,tf, M)
    
    u0 = boundry.g(x)
    T = get_T(L, N)
    us = np.array([u0])
    
    for i in range(len(t)):
        uold = us[i]
        unew = eulerstep(T,uold, delta_t)
        us = np.vstack([us,unew])
    
    cfl = delta_t/delta_x**2
    us = np.hstack([us,np.zeros((len(us),1))])
    us = np.hstack([np.zeros((len(us),1)),us])
    return us, cfl


# In[672]:


def plot3d(L,tf,us, N, M, azim = 30, polar = 30 , num = 1, title = ""):
    fig = plt.figure()
    if(num == 1):
        ax = fig.add_subplot(111, projection='3d')
    elif(num == 2):
        ax =fig.add_subplot(111, projection='3d')
    xx = np.linspace(0, L, len(us[0]))
    tt = np.linspace(0, tf, len(us[:,0]))
    X, T = np.meshgrid(xx, tt)
    surf = ax.plot_surface(X, T, us, cmap=cm.coolwarm, linewidth=0)
    fig.set_figheight(10)
    fig.set_figwidth(10)
    fig.canvas.toolbar_visible = True
    fig.colorbar(surf, shrink=0.5, aspect=5)
    ax.view_init(polar,azim)
    ax.set_zlabel("$u(x,t)$")
    ax.set_xlabel("$x$")
    ax.set_ylabel("$t$")
    ax.tick_params(axis='both', which='major', labelsize=10)
    rc('font',size=15)
    rc('axes',labelsize=15)
    ax.set_title(title)
    
    plt.show()


# In[676]:


N = 20
M = 1000
L = 1
t0 = 0
tf = 1
boundry = boundry_test()

us, cfl = diffusion(boundry, N, M, L, t0,tf)

title = "Solution to the diffusion equation with homogeneus Dirichelt conditions \n with Courant number $\mu$ = " + str(cfl)
plot3d(L,tf,us,N,M, title=title)
print(cfl)


# In[11]:


us.shape


# In[678]:


N = 20
M = 858
L = 1
t0 = 0
tf = 1
boundry = boundry_test()

us, cfl = diffusion(boundry, N, M, L, t0,tf)
title = "Solution to the diffusion equation with homogeneus Dirichelt conditions \n with Courant number $\mu$ = " + str(cfl)
plot3d(L,tf,us,N,M, title=title)
print(cfl)


# In[679]:


#Task 1.2

def TRstep(Tdx, uold, dt):
    A = np.identity(len(Tdx)) - dt/2 * Tdx
    B = np.identity(len(Tdx)) + dt/2 * Tdx
    unew = solve(A, B.dot(uold))
    return unew

def diffusion_2(boundry, N, M, L, t0, tf,bc_type="g"):
    delta_x = L / (N+1)
    delta_t =  (tf-t0)/ M
    
    x = np.linspace(delta_x, L-delta_x, N)
    t = np.linspace(0,tf, M)
    
    if(bc_type == "g"):
        u0 = boundry.g(x)
    elif(bc_type =="h"):
        u0 = boundry.h(x)
        
    
    T = get_T(L, N)
    us = np.array([u0])
    
    for i in range(len(t)):
        uold = us[i]
        unew = TRstep(T,uold, delta_t)
        us = np.vstack([us,unew])
    
    
    cfl = delta_t/delta_x**2
    us = np.hstack([us,np.zeros((len(us),1))])
    us = np.hstack([np.zeros((len(us),1)),us])
    return us, cfl


# In[794]:


N = 200
M = 700
L = 1
t0 = 0
tf = 1
boundry = boundry_test()

us, cfl = diffusion_2(boundry, N, M, L, t0,tf, bc_type = "g")
title = "Solution to the diffusion equation with homogeneus Dirichelt conditions \n with Courant number $\mu$ = " + str(cfl) 
plot3d(L,tf,us,N,M, title=title)


# In[ ]:





# In[684]:


def get_adv_T(amu,N):
    coef0 = 1-amu**2
    coef1 = amu/2 * (1 + amu)
    coef2 = -amu/2 * (1 - amu)
    T = toeplitz(np.concatenate([np.array([coef0,coef1]), np.zeros(N-2)], axis = 0),
    np.concatenate([np.array([coef0,coef2]), np.zeros(N-2)], axis = 0))
    T[0,-1] = coef1
    T[-1, 0] = coef2
    return T


def LaxWen(u, amu):
    N = len(u)
    T = get_adv_T(amu, N)
    unew = T.dot(u)
    return unew

def advection(boundry, L, N, amu, M=5, tf=5):
    dx = 1/N
    x = np.linspace(0,L-dx, N)
    us = np.array([boundry.advection(x)])
    norms = np.array([norm(us[0], ord = 2)/len(us[0])])
    for i in range(M):
        unew = LaxWen(us[i], amu)
        norms = np.append(norms, norm(unew,ord = 2)/len(unew))
        us = np.vstack([us,unew])
        
    return us, norms
    


# In[685]:


def advection2(bondry, L, N, a, M=5):
    dx = 1/N
    dt = 1/M
    mu = dt/dx
    x = np.linspace(0,L-dx, N)
    us = np.array([boundry.advection(x)])
    norms = np.array([norm(us[0], ord = 2)/len(us[0])])
    for i in range(M):
        unew = LaxWen(us[i], a*mu)
        norms = np.append(norms, norm(unew,ord = 2)/len(unew))
        us = np.vstack([us,unew])
        
    return us, norms, a*mu


# In[704]:


N = 100
L = 1
t0 = 0
tf = 5
M = 100
amu = 1
boundry = boundry_test()

us, norms1 = advection(boundry, L, N, amu, tf = tf, M = M)
title = "Solution to the Advection equation with periodic boundry conditions and $a\mu$ = " + str(amu)

plot3d(L, tf, us, N, M, azim = 0, polar = 90, title = title)
plot3d(L, tf, us, N, M, azim = 0, polar = 70, num = 2, title = title)
print(amu)


# In[875]:


N = 100
L = 1
t0 = 0
tf = 5
M = 100
amu = -1
boundry = boundry_test()

us, norms1 = advection(boundry, L, N, amu, tf = tf, M = M)
title = "Solution to the Advection equation \n with periodic boundry conditions and $a\mu$ = " + str(np.abs(amu)) + " and $a=-1$"

plot3d(L, tf, us, N, M, azim = 0, polar = 90, title = title)
plot3d(L, tf, us, N, M, azim = 0, polar = 70, num = 2, title = title)
print(amu)


# In[697]:


N = 200
L = 1
t0 = 0
tf = 5
M = 200
amu = 0.9
boundry = boundry_test()

us, norms2 = advection(boundry, L, N, amu, tf = tf, M = M)


title = "Solution to the Advection equation with periodic boundry conditions and $a\mu$ = " + str(amu)

plot3d(L, tf, us, N, M, azim = 0, polar = 90, title = title)
plot3d(L, tf, us, N, M, azim = 0, polar = 70, num = 2, title = title)
print(amu)


# In[797]:


fig, (ax1, ax2) = plt.subplots(1, 2)
temp1 = np.linspace(0, 5, len(norms1))
temp2 = np.linspace(0, 5, len(norms2))
ax1.plot(temp1,norms1)
ax2.plot(temp2,norms2)
ax2.label_outer()
ax1.set_title("                                        Rms norm of the solutions to the advection equation $||u||_{RMS}(t)$ \n with $a\mu = 1$ (left) and $a\mu = 0.9$ (right)")
plt.show()


# In[381]:


N = 200

L = 1
t0 = 0
tf = 5
M = 200
amu = 0.9
boundry = boundry_test()

us, norms = advection(boundry, L, N, amu, tf = tf, M=M)
plot3d(L, tf, us, N, M, azim = 0, polar = 85)


# In[706]:


temp = np.linspace(0, 5, len(norms))
plt.plot(temp,norms)
#norm remains constant for amu = 1 


# In[318]:


N = 200

L = 1
t0 = 0
tf = 25
M = tf-t0
a
amu = -0.9
boundry = boundry_test()

us, norms = advection(boundry, L, N, amu, tf = tf)
plot3d(L, tf, us, N, M, azim = 0, polar = 85)


# In[319]:


plt.plot(norms)
#Norm is damped for amu = 0.9


# In[23]:


plot3d(L, tf, us, N, M, azim = 10, polar = 60)


# In[761]:


class boundry_test():
    def g(self,x):
        return -x*(x-1)
    
    def h(self,x):
        return -x*(x-1)*np.exp(-(4*(x-3/4))**2)
    def advection(self, x):
        return np.exp(-100*(x-0.5)**2)
    def b2(self, x):
        return np.exp(-100*(x-0.25)**2)
    def b3(self, x):
        return np.exp(-100*(x-0.6)**2)
    def b4(self, x):
        return -x*(x-1)
    def b5(self, x):
        return np.exp(-500*(x-0.25)**2)


# In[25]:


def TRstep(Tdx, uold, dt):
    A = np.identity(len(Tdx)) - dt/2 * Tdx
    B = np.identity(len(Tdx)) + dt/2 * Tdx
    unew = solve(A, B.dot(uold))
    return unew
def get_cd_T(N, dx,a,d):
    A = d * toeplitz(np.concatenate([np.array([-2,1]), np.zeros(N-2)], axis = 0),
    np.concatenate([np.array([-2,1]), np.zeros(N-2)], axis = 0)) / dx**2 
    B = a * toeplitz(np.concatenate([np.array([0,-1]), np.zeros(N-2)], axis = 0),
    np.concatenate([np.array([0,1]), np.zeros(N-2)], axis = 0)) / (2*dx)
    T = A - B
    T[0,-1] = T[1,0]
    T[-1, 0] = T[0,1]
    return T
def convdiff(u, a, d, dt, dx):
    Tdx = get_cd_T(N,dx, a, d)
    return TRstep(Tdx, u, dt)
def convection_advection(boundry, N, M, a, d, boundry_type = "advection"):
    dx = 1/N
    dt = 1/M
    x = np.linspace(0,1-dx, N)
    Pe = np.abs(a/d)
    if(boundry_type == "advection"):
        us = np.array([boundry.advection(x)])
    elif(boundry_type == "b2"):
        us = np.array([boundry.b2(x)])
    elif(boundry_type == "b3"):
        us = np.array([boundry.b3(x)])
    elif(boundry_type == "b4"):
        us = np.array([boundry.b4(x)])
    elif(boundry_type == "b5"):
        us = np.array([boundry.b5(x)])
        
    for i in range(M):
        unew = convdiff(us[i], a,d,dt,dx)
        us = np.vstack([us,unew])
        
    return us, Pe*dx, Pe


# In[798]:


a = 1
d = 0.1
M = 30
N = 1000
L = 1
tf = 1
boundry = boundry_test()
boundry_type = "advection"
us, Pe, pe0 = convection_advection(boundry, N, M, a, d, boundry_type = boundry_type)
title = "Solution to the convection-diffusion equation \n with periodic boundry conditions and Peclet number $Pe = $" + str(Pe) 
plot3d(L, tf, us, N, M, azim = 70, polar = 20, title = title)
print(Pe)
print(pe0)


# In[805]:


for i in range(int(len(us)/5)):
    plt.plot(np.linspace(0,1, len(us[i])),us[i])
title = "Two dimensional plot of $u(x,t)$ with time constant \n plotted for the first six time steps"
plt.title(title)
plt.xlabel("x")
plt.ylabel("u(x,t)")


# In[764]:


a = 1
d = 0.1
M = 30
N = 100
L = 1
tf = 1
boundry = boundry_test()
boundry_type = "b2"
us, Pe, pe0 = convection_advection(boundry, N, M, a, d, boundry_type = boundry_type)


title = "Solution to the convection-diffusion equation with periodic boundry conditions and Peclet number $Pe = $" + str(Pe) + "\n With a shifted pulse as the initial condition"
plot3d(L, tf, us, N, M, azim = 70, polar = 20, title=title)
print(Pe)
print(pe0)
        
    


# In[765]:


for i in range(int(len(us)/5)):
    
    plt.plot(us[i])
title = "Two dimensional plot of $u(x)$ with time constant plotted for the first six time steps"
plt.title(title)


# In[768]:


a = 1
d = 0.1
M = 30
N = 1000
L = 1
tf = 1
boundry = boundry_test()
boundry_type = "b3"
us, Pe, pe0 = convection_advection(boundry, N, M, a, d, boundry_type = boundry_type)

plot3d(L, tf, us, N, M, azim = 30, polar = 20)
print(Pe)
print(pe0)


# In[769]:


for i in range(int(len(us))):
    
    plt.plot(us[i])


# In[457]:


##Part 4
def get_b_T(N):
    dx = 1/N
    T = toeplitz(np.concatenate([np.array([-2,1]), np.zeros(N-2)], axis = 0),
    np.concatenate([np.array([-2,1]), np.zeros(N-2)], axis = 0)) / dx**2 
    T[0,-1] = T[1,0]
    T[-1, 0] = T[0,1]
    return T
def get_b_S(N):
    dx = 1/N
    T = toeplitz(np.concatenate([np.array([0,1]), np.zeros(N-2)], axis = 0),
    np.concatenate([np.array([0,-1]), np.zeros(N-2)], axis = 0)) / (2*dx)
    T[0,-1] = T[1,0]
    T[-1, 0] = T[0,1]
    return T
def LW(uold, dt,a=1):
    N = len(uold)
    T = get_b_T(N)
    S = get_b_S(N)
    return uold-dt*uold*S.dot(uold) + (a*dt)**2 / 2 * (2*uold*(S.dot(uold))**2 + uold**2*T.dot(uold))
def burgers(uold, dt, d,a=1):
    N = len(uold)
    T = get_b_T(N)
    A = np.identity(N)-d*dt/2*T
    return solve(A, LW(uold,dt,a)+d*dt/2*T.dot(uold))
def solve_burg(boundry, N, M, d, boundry_type = "advection",a=1):
    dx = 1/N
    dt = 1/M
    x = np.linspace(0,1-dx, N)
    if(boundry_type == "advection"):
        us = 10*np.array([boundry.advection(x)])
    elif(boundry_type == "b2"):
        us = 5*np.array([boundry.b2(x)])
    elif(boundry_type == "b3"):
        us = 4*np.array([boundry.b3(x)])
    elif(boundry_type == "b4"):
        us = np.array([boundry.b4(x)])
    for i in range(M):
        unew = burgers(us[i],dt,d,a)
        us = np.vstack([us,unew])
    return us


# In[825]:


def plot_burger(L,tf,us, N, M, azim = 30, polar = 30 , num = 1, title = " "):
    fig = plt.figure()
    if(num == 1):
        ax = fig.add_subplot(111, projection='3d')
    elif(num == 2):
        ax =fig.add_subplot(111, projection='3d')
    us=us[int(M/5):-1]
    
    xx = np.linspace(0, L, len(us[0]))
    tt = np.linspace(0, tf, len(us[:,0]))
    X, T = np.meshgrid(xx, tt)
    surf = ax.plot_surface(X, T, us, cmap=cm.coolwarm, linewidth=0)
    fig.set_figheight(10)
    fig.set_figwidth(10)
    fig.canvas.toolbar_visible = True
    fig.colorbar(surf, shrink=0.5, aspect=5)
    ax.view_init(polar,azim)
    ax.set_zlabel("$u(x,t)$")
    ax.set_xlabel("$x$")
    ax.set_ylabel("$t$")
    ax.tick_params(axis='both', which='major', labelsize=10)
    rc('font',size=15)
    rc('axes',labelsize=15)
    ax.set_title(title)
    plt.show()


# In[826]:


N = 300
M = 1500
dt = 1/M
dx = 1/N
d = 0.01
L = 1
tf = 1
x = np.linspace(0,L-dx, N)
boundry = boundry_test()
us = solve_burg(boundry,N,M,d, boundry_type = "advection")
title = "Solution to the Burgers equation with $N = 300$, $M=1500$ and $d=0.01$"
plot_burger(L, tf, us, N, M, azim = 145, polar = 20, title = title)


# In[886]:


N = 300
M = 3000
dt = 1/M
dx = 1/N
d = 0.001
L = 1
tf = 1
x = np.linspace(0,L-dx, N)
boundry = boundry_test()
us = solve_burg(boundry,N,M,d, boundry_type = "b5", a = 1)
title = "Solution to the Burgers equation with $N = 300$, $M=3000$ and $d=0.01$ \nWith a shifted gaussian pulse initial condition"
plot_burger(L, tf, us, N, M, azim = 300, polar = 20, title = title)

