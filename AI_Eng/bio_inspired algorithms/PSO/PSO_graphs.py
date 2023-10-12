import numpy as np
import matplotlib.pyplot as plt
import random
from mpl_toolkits.mplot3d import Axes3D
import seaborn as sns

from functions import *
import argparse
import time

import pandas as pd
    
def parse_args():
    # setup arg parser
    parser = argparse.ArgumentParser()
    # no arguments
    # parse args
    args = parser.parse_args()
    # return args
    return args

def main(args):
    rastrigin = functions['rastrigin']
    ackley = functions['ackley']
    rosenbrock = functions['rosenbrock']
    griewank = functions['griewank']

    fucntions = [rastrigin, ackley, rosenbrock, griewank]
    prime_numbers = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61]

    W = [0.25, 0.5]
    C1 = [0.0, 1.0, 2.0]
    C2 = [0.0, 1.0, 2.0]

    iterations = 5
    size_swarm = 100

    combinations = []
    lower = [-5.0 for x in range(3)] # -2.048
    upper = [5.0 for x in range(3)] # 2.048

    for i in range(len(W)):
        for j in range(len(C1)):
            for k in range(len(C2)):
                combinations.append((W[i], C1[j], C2[k]))


    pso_analysis = pd.DataFrame(columns=['function', 'combination', 'min', 'max', 'mean', 'std'])

    for function in fucntions: # function

        for combination in combinations : # seed     

            ybests = []
            for seed in prime_numbers: # 18
                
                random.seed(seed)
                
                w = combination[0]
                c1 = combination[1]
                c2 = combination[2]
                result, _ = pso_algorithm(w, c1, c2, lower, upper, size_swarm, iterations, function)

                ybests.append(result.fitness)

            #print('function:', function._name_,' -combination:',combination, ' -min:', min(ybests),' -max:', max(ybests), ' -mean:',np.mean(ybests), ' - std:', np.std(ybests))
            analysis = [function._name_, combination, min(ybests), max(ybests), np.mean(ybests), np.std(ybests)]
            pso_analysis.loc[len(pso_analysis)] = analysis

    #print(result[['combinations']])
    graficas(pso_analysis)
    pso_analysis.to_csv('./BIO/pso.csv', index=False)
    
class Solution:
    def _init_(self):
        self.X = [] #vector decision for example [x1, x2, x3, x4]
        self.V = []
        self.fitness = 0


    def set_fitness(self, value):
        self.fitness = value

    #---------------------CHECK THE BOUNDS------------------
    def validate_bounds(self, lower_bound, upper_bound):
        for i in range(len(self.X)):
            if self.X[i] < lower_bound[i] or self.X[i] > upper_bound[i]:
                self.X[i] = random.uniform(lower_bound[i], upper_bound[i])

# Crea un cumulo inicial en forma aleatoria
def initialize_swarm(size, lower_bound, upper_bound):
    num_var = len(lower_bound)
    swarm = []
    for i in range(size):
        solution = Solution()
        for j in range(num_var):
            solution.X.append(np.random.uniform(lower_bound[j], upper_bound[j]))
            solution.V.append(np.random.uniform(lower_bound[j], upper_bound[j]))
        #solution.fitness = objectiveFunction
        swarm.append(solution)
    #evaluate_swarm(swarm, f)
    #print 'initial population', population[i].variables

    return swarm

def evaluate_swarm(swarm, f):
    for p in swarm:
        p.fitness = f(p.X) #-------
    #print('fitness ', pop.fitness)

def best_solution(swarm):
    fitness = -float('inf')
    best = swarm[0]
    for sw in swarm:
        if sw.fitness < fitness: # si fuera maximizar sw.fitness > fitness
            best = sw
            fitness = sw.fitness
    return best

def print_swarm(swarm):
    for sw in swarm:
        print(sw.X, '> ', sw.fitness)

def pso_algorithm(w, c1, c2, lower, upper, size_swarm, iterations, f):
    dimensions = len(lower)
    graficaadata = []
    graficaadata2 = []
    #Initialize the swarm
    x = initialize_swarm(size_swarm, lower, upper)
    #Evaluate the swarm
    evaluate_swarm(x, f)

    #print_swarm(x)

    y = x[:]
    y_best = best_solution(y)
    #print 'BEST ', y_best.X, '>>> ', y_best.fitness

    it = 0
    while it < iterations: #la mejor y la peor sean muy parecidas
        for i in range(len(x)): # x es el swarm
            particle = x[i]
            for j in range(dimensions):
                #Calcular la velocidad
                r1 = np.random.rand() # uniform random number r1
                r2 = np.random.rand() # uniform random number r2
                particle.V[j] = w * particle.V[j] + c1 * r1 * (y[i].X[j] - particle.X[j]) + c2 * r2 * (y_best.X[j] - particle.X[j])
                #Actualizar la posicion de particle.X
                particle.X[j] = particle.X[j] + particle.V[j]

            particle.validate_bounds(lower, upper)

            #Evaluar la nueva posicion de X
            particle.fitness = f(particle.X)

            if particle.fitness <= y[i].fitness:
                y[i] = particle
            if particle.fitness <= y_best.fitness:
                y_best = particle
            #print 'solution ', y_best.X, '>>> ', y_best.fitness
            x[i] = particle

        if it % 1 == 0:
            graficaadata.append(it)
            graficaadata2.append(y_best.fitness)

            
        it +=1


    return y_best, [graficaadata, graficaadata2]

def graficas(pso_analysis):
    min_values_idx = pso_analysis.groupby('function')['min'].idxmin()
    result_minmin = pso_analysis.loc[min_values_idx][['function','combination']]
    maxmax_values_idx = pso_analysis.groupby('function')['max'].idxmax()
    result_maxmax = pso_analysis.loc[maxmax_values_idx][['function','combination']]

    iterations = 5
    size_swarm = 100
    lower = [-5.0 for x in range(3)] # -2.048
    upper = [5.0 for x in range(3)] # 2.048

    for (indexMIn, rowMin), (indexMax, rowMax) in zip(result_minmin.iterrows(), result_maxmax.iterrows()):

        w_min = int(rowMin['combination'][0])
        c1_min = int(rowMin['combination'][1])
        c2_min = int(rowMin['combination'][2])
        resultMin, xxyyMin = pso_algorithm(w_min, c1_min, c2_min, lower, upper, size_swarm, iterations,  functions[rowMin['function']])

        w_max = int(rowMax['combination'][0])
        c1_max = int(rowMax['combination'][1])
        c2_max = int(rowMax['combination'][2])
        resultMax, xxyyMax = pso_algorithm(w_max, c1_max, c2_max, lower, upper, size_swarm, iterations,  functions[rowMax['function']])

        plt.figure()
        #MIN
        plt.scatter(xxyyMin[0], xxyyMin[1],  label='Max')
        plt.plot(xxyyMin[0], xxyyMin[1], label='Max')
        #MAx
        plt.scatter(xxyyMax[0], xxyyMax[1],  label='Min')
        plt.plot(xxyyMax[0], xxyyMax[1], label='Min')

        plt.title(rowMin['function'])
        filename = f"./BIO/{rowMin['function']}.png"
        plt.savefig(filename)

        
# run script
if _name_ == "_main_":
    # add space in logs
    print("\n\n")
    print("*" * 60)
    start = time.time()

    # parse args
    args = parse_args()

    # run main function
    main(args)

    end = time.time()

    print("Total time taken: {}s (Wall time)".format(end - start))

    # add space in logs
    print("*" * 60)
    print("\n\n")