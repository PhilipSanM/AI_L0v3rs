#rosenbrock_graph.py
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

def rosenbrock(x):
    dimension = len(x)
    if dimension < 2:
        raise ValueError("La función de Rosenbrock requiere al menos dos dimensiones.")

    result = 0
    for i in range(dimension - 1):
        result += 100 * (x[i + 1] - x[i]**2)**2 + (1 - x[i])**2

    return result

X = np.linspace(-2.048, 2.048, 400)
Y = np.linspace(-2.048, 2.048, 400)
X, Y = np.meshgrid(X,Y)
Z = rosenbrock([X,Y])

fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
ax.plot_surface(X, Y, Z, rstride=1, cstride=1,
  cmap=cm.nipy_spectral, linewidth=0.08,
  antialiased=True)
plt.show()