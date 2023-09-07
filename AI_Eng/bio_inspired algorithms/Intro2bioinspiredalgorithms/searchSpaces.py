
#funciones de prueba
from numpy import *
from math import *
from pylab import *

import argparse

def main(args):
    print("="*20)
    print("Running exhaustive search for function 1")
    for iteration in args.n:
        a = -5
        b = -0.001
        exhaustiveSearch(a, b, iteration, f1)
        print("")
    print("="*20)
    print("Running exhaustive search for function 2:")
    for iteration in args.n:
        a = -10
        b = 10
        exhaustiveSearch(a, b, iteration, f2)
        print("")
    
    print("="*20)
    print("Running exhaustive search for function 3:")
    for iteration in args.n:
        a = -1
        b = 1
        exhaustiveSearch(a, b, iteration, f3)
        print("")
    
    print("="*20)
    print("Running exhaustive search for function 4:")
    for iteration in args.n:
        a = 5
        b = 5
        exhaustiveSearch(a, b, iteration, f4)
        print("")
    
    print("="*20)
    print("Running exhaustive search for function 5:")
    for iteration in args.n:
        a = -1
        b = 1
        exhaustiveSearch(a, b, iteration, f5)
        print("")
    
    print("="*20)

    print("Running exhaustive search for function 6:")
    for iteration in args.n:
        a = -5
        b = 6
        exhaustiveSearch(a, b, iteration, f6)
        print("")
        
    print("="*20)
    print("/"*20)
    print("="*20)
    print("Running interval search for function 1:")
    for eps in args.eps:
        a = -5
        b = -0.001
        intervalSearch(a, b, eps, f1)
        print("")
    print("="*20)

    print("Running interval search for function 2:")
    for eps in args.eps:
        a = -10
        b = 10
        intervalSearch(a, b, eps, f2)
        print("")
    print("="*20)

    print("Running interval search for function 3:")
    for eps in args.eps:
        a = -1
        b = 1
        intervalSearch(a, b, eps, f3)
        print("")
    print("="*20)

    print("Running interval search for function 4:")
    for eps in args.eps:
        a = 5
        b = 5
        intervalSearch(a, b, eps, f4)
        print("")

    print("="*20)

    print("Running interval search for function 5:")
    for eps in args.eps:
        a = -1
        b = 1
        intervalSearch(a, b, eps, f5)
        print("")
    print("="*20)

    print("Running interval search for function 6:")
    for eps in args.eps:
        a = -5
        b = 6
        intervalSearch(a, b, eps, f6)
        print("")



def f1(x):
    #y = 65 - 0.75 / (1 + x**2) - (0.65 * x * math.atan(1/x))
    y =  65 - 0.75 / (1 + x**2) - (0.65 * x *  np.arctan(1.0/x))
    return y

def fun1(x):
    if x == 0:
      x = 0.00001
    y = 65 - 0.75 / (1 + x**2) - (0.65 * x * math.atan(1/x))
    return y

def f2(x):
    y = (1-x)**4-(2*x+10)**2
    return y

def f3(x):
    y = 3*x**2 + 12.0/x**3 - 5.0
    return y

def f4(x):
    y = x*(x-1.5)
    return y

def f5(x):
    y = 3*x**4 + (x-1)**2
    return y

def f6(x):
    y = 10*x**3 - 2*x - 5 *exp(x)
    return y


def findMinimum(x1, x2, x3, f):
  if f(x1) >= f(x2) and f(x2) <= f(x3):
    return 1
  else:
    return 0

def exhaustiveSearch(a, b, n, f):
  x1 = a
  deltaX = (b-a)/n
  x2 = x1 + deltaX
  x3 = x2 + deltaX
  iteraciones = 0
  while True:
    iteraciones = iteraciones + 1
    if findMinimum(x1,x2,x3, f) == 1:
      print("The range of the minimum is betwen: ", x1, " and ", x3 )
      break
    else:
      x1 = x2
      x2 = x3
      x3 = x2 + deltaX
    if x3 > b:
      break
    #else:
     # print("No existe un mínimo en (a,b) o un punto extremo (a ó b) es el mínimo")
  print('Number of iterations: ', iteraciones)

def intervalSearch(a, b, eps, fun):
    xm= (a+b)/2
    L0 = L = b-a
    fun(xm)
    iteraciones = 0
    while True:
    iteraciones = iteraciones + 1
    x1 = a + L/4
    x2 = b - L/4
    if fun(x1) < fun(xm):
        b = xm
        xm = x1
    elif fun(x2) < fun(xm):
        a = xm
        xm = x2
    else:
        a = x1
        b = x2
    L = b-a
    if abs(L) < eps:
        break
    print('The optimal value is betwen', a, b)
    print("Number of iterations", iteraciones)



def parse_args():
    # setup arg parser
    parser = argparse.ArgumentParser()

    # add arguments
    parser.add_argument("--n", dest='n',
                        type=int, nargs='+', help="number of iterations",
                        default=[10,100,1000,10000])
    parser.add_argument("--eps", dest='eps',
                        type=int,nargs='+', default=[0.1, 0.01, 0.001, 0.0001], help="epsilon")

    # parse args
    args = parser.parse_args()

    # return args
    return args

# run script
if __name__ == "__main__":
    # add space in logs
    print("\n\n")
    print("*" * 60)

    # parse args
    args = parse_args()

    # run main function
    main(args)

    # add space in logs
    print("*" * 60)
    print("\n\n")
