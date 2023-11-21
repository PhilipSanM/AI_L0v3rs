import numpy as np

def ackley(x):
    n = len(x)
    sum_sq = 0
    cos_term = 0
    for i in range(n):
      sum_sq += x[i]**2
      cos_term += np.cos(2 * np.pi * x[i])
    return -20 * np.exp(-0.2 * np.sqrt(sum_sq / n)) - np.exp(cos_term / n) + 20 + np.exp(1)


def griewank(x):
  result_sum = 0
  result_prod = 1
  for i in range(len(x)):
    result_sum += ((x[i]**2) / 400)
    result_prod = result_prod * np.cos(x[i]/np.sqrt(i+1))
  return result_sum - result_prod + 1


def rastrigin(x):
  A = 10 * len(x)
  result = 0
  for i in range(len(x)):
    result += x[i]**2 - 10*np.cos(2*np.pi*x[i])

  return A*result



def rosenbrock(x):
    dimension = len(x)
    if dimension < 2:
        raise ValueError("La función de Rosenbrock requiere al menos dos dimensiones.")

    result = 0
    for i in range(dimension - 1):
        result += 100 * (x[i + 1] - x[i]**2)**2 + (1 - x[i])**2

    return result