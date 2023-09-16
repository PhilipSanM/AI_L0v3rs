import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

def griewank(x):
  result_sum = 0
  result_prod = 1
  for i in range(len(x)):
    result_sum += ((x[i]**2) / 400)
    result_prod = result_prod * cos(x[i]/sqrt(i+1))
  return result_sum - result_prod + 1

# Generar datos para la grafica
X = np.linspace(-8, 8, 400)
Y = np.linspace(-8, 8, 400)
X, Y = np.meshgrid(X, Y)
Z = griewank([X,Y])


fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
ax.plot_surface(X, Y, Z, rstride=1, cstride=1,
  cmap=cm.nipy_spectral, linewidth=0.08,
  antialiased=True)
plt.show()