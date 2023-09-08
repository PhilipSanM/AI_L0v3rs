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
# plt.savefig('rastrigin_graph.png')
plt.show()



# Ackley function
