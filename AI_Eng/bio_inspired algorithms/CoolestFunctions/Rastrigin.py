#rastrigin_graph.py
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

def rastrigin(x):
  A = 10 * len(x)
  result = 0
  for i in range(len(x)):
    result += x[i]**2 - 10*np.cos(2*np.pi*x[i])

  return A*result

# Generar datos para la gráfica
X = np.linspace(-5.12, 5.12, 400)
Y = np.linspace(-5.12, 5.12, 400)
X, Y = np.meshgrid(X, Y)
Z = rastrigin([X,Y])

fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
ax.plot_surface(X, Y, Z, rstride=1, cstride=1,
  cmap=cm.nipy_spectral, linewidth=0.08,
  antialiased=True)
plt.show()