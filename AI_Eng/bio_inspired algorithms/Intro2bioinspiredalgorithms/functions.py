# colormaps_demos.py

from matplotlib import cm  # color map
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
import numpy as np

def plotFunction(limInf, limSup, pts, nameFunction):
  X = np.linspace(limInf[0], limSup[0], pts)
  Y = np.linspace(limInf[1], limSup[1], pts)
  X, Y = np.meshgrid(X, Y)
  if nameFunction == 'sphere':
    Z = X**2 + Y**2  # "sphere" function
  #elif nameFunction == 'rastrigin':
    #(X**2 - 10 * np.cos(2 * np.pi * X)) + (Y**2 - 10 * np.cos(2 * np.pi * Y)) + 20

  fig = plt.figure()
  ax = fig.add_subplot(111, projection='3d')
  # change the value of the "cmap" parameter
  surf = ax.plot_surface(X, Y, Z, rstride=1, cstride=1, cmap=cm.hsv, edgecolor='darkred', linewidth=0.1)

  ax.set_xlabel('x')
  ax.set_ylabel('y')
  ax.set_zlabel('f(x,y)')

  plt.savefig(nameFunction + '.jpg')
  plt.show()

limInf = [-2,-1]
limSup = [2,2]
pts = 100
nameFunction = 'sphere'
plotFunction(limInf, limSup, pts, nameFunction)



# rastrigin_graph.py

import numpy as np
import matplotlib.pyplot as plt
from matplotlib import cm
from mpl_toolkits.mplot3d import Axes3D

X = np.linspace(-5.12, 5.12, 100)
Y = np.linspace(-5.12, 5.12, 100)
X, Y = np.meshgrid(X, Y)

Z = (X**2 - 10 * np.cos(2 * np.pi * X)) + \
  (Y**2 - 10 * np.cos(2 * np.pi * Y)) + 20

fig = plt.figure()
#ax = fig.gca(projection='3d')
ax = fig.add_subplot(111, projection='3d')
ax.plot_surface(X, Y, Z, rstride=1, cstride=1,
  cmap=cm.nipy_spectral, linewidth=0.08,
  antialiased=True)
plt.savefig('rastrigin_graph.png')
plt.show()



# Ackley.py
from numpy import arange
from numpy import exp
from numpy import sqrt
from numpy import cos
from numpy import e
from numpy import pi
from numpy import meshgrid
import matplotlib.pyplot as plt

def objective(x, y):
 return -20.0 * exp(-0.2 * sqrt(0.5 * (x**2 + y**2)))-exp(0.5 * (cos(2 * 
  pi * x)+cos(2 * pi * y))) + e + 20


r_min, r_max = -32.768, 32.768
xaxis = arange(r_min, r_max, 2.0)
yaxis = arange(r_min, r_max, 2.0)
x, y = meshgrid(xaxis, yaxis)
results = objective(x, y)

figure = plt.figure()
axis = figure.add_subplot(111, projection='3d')
axis.plot_surface(x, y, results, cmap='jet', shade= "false")
plt.show()



