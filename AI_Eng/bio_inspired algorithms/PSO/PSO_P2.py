import numpy as np
import matplotlib.pyplot as plt
import random
from mpl_toolkits.mplot3d import Axes3D
import seaborn as sns

from functions import *
import argparse
import time

import pandas as pd




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
    best_worst = pd.DataFrame(columns=['function', 'combination', 'type','iteration', 'fitness'])

    for function in fucntions: # function
        b_w_data = []
        for combination in combinations : # seed     
            ybests = []
            for seed in prime_numbers: # 18
                
                random.seed(seed)
                
                w = combination[0]
                c1 = combination[1]
                c2 = combination[2]
                result = pso_algorithm(w, c1, c2, lower, upper, size_swarm, iterations, function)


                ybests.append(result.fitness)

            print('function:', function.__name__,' -combination:',combination, ' -min:', min(ybests),' -max:', max(ybests), ' -mean:',np.mean(ybests), ' - std:', np.std(ybests))
            analysis = [function.__name__, combination, min(ybests), max(ybests), np.mean(ybests), np.std(ybests)]
            pso_analysis.loc[len(pso_analysis)] = analysis

            
 


    pso_analysis.to_csv('pso_analysis.csv', index=False)

    


class Particle(object):
    def __init__(self):
        self.positions = []
        self.velocities = []
        self.fitness = 0
        
    def set_fitness(self, value):
        self.fitness = value
    
    def validate_bounds(self, lower_bound, upper_bound):
        for i in range(len(self.positions)):
            if self.positions[i] < lower_bound[i] or self.positions[i] > upper_bound[i]:
                self.positions[i] = random.uniform(lower_bound[i], upper_bound[i])

                
  
def initialize_swarm(size, lower_bound, upper_bound):
    num_dimensions = len(lower_bound)
    swarm = []
    for _ in range(size):
        particle = Particle()
        for j in range(num_dimensions):
            particle.positions.append(np.random.uniform(lower_bound[j], upper_bound[j]))
            particle.velocities.append(np.random.uniform(lower_bound[j], upper_bound[j]))
        swarm.append(particle)

    
    return swarm

def evaluate_swarm(swarm, function):
    for p in swarm:
        p.fitness = function(p.positions) 


def best_solution(swarm):
    fitness = swarm[0].fitness
    best = swarm[0]
    for particle in swarm:
        if particle.fitness < fitness: # si fuera maximizar sw.fitness > fitness
            best = particle
            fitness = particle.fitness
    return best


def print_swarm(swarm):
    for sw in swarm:
        print(sw.positions, '> ', sw.fitness)



def pso_algorithm(w, c1, c2, lower, upper, size_swarm, iterations, f):
    dimensions = len(lower)
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
                particle.velocities[j] = w * particle.velocities[j] + c1 * r1 * (y[i].positions[j] - particle.positions[j]) + c2 * r2 * (y_best.positions[j] - particle.positions[j])
                #Actualizar la posicion de particle.X
                particle.positions[j] = particle.positions[j] + particle.velocities[j]

            particle.validate_bounds(lower, upper)
                
            #Evaluar la nueva posicion de X
            particle.fitness = f(particle.positions)
            
            if particle.fitness <= y[i].fitness:
                y[i] = particle
            if particle.fitness <= y_best.fitness:
                y_best = particle
            #print 'solution ', y_best.X, '>>> ', y_best.fitness
            x[i] = particle
        
        it +=1

    return y_best


def parse_args():
    # setup arg parser
    parser = argparse.ArgumentParser()

    # no arguments

    # parse args
    args = parser.parse_args()

    # return args
    return args

# run script
if __name__ == "__main__":
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
