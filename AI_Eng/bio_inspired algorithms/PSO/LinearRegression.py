import numpy as np
import matplotlib.pyplot as plt
import random
from mpl_toolkits.mplot3d import Axes3D
import seaborn as sns
import pandas as pd


# Data
df = pd.read_csv("./Salary.csv")

plt.figure()

sns.scatterplot(x = df['YearsExperience'], y = df['Salary'], 
                s = 40, color = 'purple',
                data = df)

plt.xlabel('Years of Experience')
plt.ylabel('Salary')
plt.show()

# Making PSO in Linear Regression
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

def best_solution(swarm):
    fitness = swarm[0].fitness
    best = swarm[0]
    for particle in swarm:
        if particle.fitness < fitness: # si fuera maximizar sw.fitness > fitness
            best = particle
            fitness = particle.fitness
    
    print(best.positions)
            
    return best

def linear_regression(particle, x):
    return particle[0] + particle[1]*x
        

def least_square_error(particle, df):
    error = 0
    
    for index,row in df.iterrows():
        x = row['YearsExperience']
        y = row['Salary']
        yi = linear_regression(particle, x)
        error += (y - yi)**2
        

    return error
        
    
def evaluate_swarm_linear_regression(swarm, function, df):
    for p in swarm:
        p.fitness = function(p.positions, df) 

    
def pso_algorithm_linear_regression(w, c1, c2, lower, upper, size_swarm, iterations, function, data_frame):
    dimensions = len(lower)
    #Initialize the swarm
    swarm = initialize_swarm(size_swarm, lower, upper)
    #Evaluate the swarm
    evaluate_swarm_linear_regression(swarm, function, df)

    #print_swarm(x)

    y = swarm[:]
    y_best = best_solution(y)
    #print 'BEST ', y_best.X, '>>> ', y_best.fitness

    it = 0
    while it < iterations: #la mejor y la peor sean muy parecidas
        for i in range(len(swarm)): # x es el swarm
            particle = swarm[i]
            for j in range(dimensions):
                #Calcular la velocidad
                r1 = np.random.rand() # uniform random number r1
                r2 = np.random.rand() # uniform random number r2
                particle.velocities[j] = w * particle.velocities[j] + c1 * r1 * (y[i].positions[j] - particle.positions[j]) + c2 * r2 * (y_best.positions[j] - particle.positions[j])
                #Actualizar la posicion de particle.X
                particle.positions[j] = particle.positions[j] + particle.velocities[j]

            particle.validate_bounds(lower, upper)
                
            #Evaluar la nueva posicion de X
            particle.fitness = function(particle.positions, data_frame)
            
#           # particular
            if particle.fitness < y[i].fitness:
                y[i] = particle
            
            # Global
            if particle.fitness < y_best.fitness:
        
                y_best = particle

            #print 'solution ', y_best.X, '>>> ', y_best.fitness
            swarm[i] = particle
        
        it +=1

    return y_best

size = 2
lower = [0, 0] # -2.048
upper = [50000, 140000] # 2.048

iterations = 100

size_swarm = 1000
w = 0.5
c1 = 0.2 # intenta regresar
c2 = 0.3 # se acerca al lider
function = least_square_error
best = pso_algorithm_linear_regression(w, c1, c2, lower, upper, size_swarm, iterations, function, df)

print('solution ', best.positions, '>>> ', best.fitness)


# Plot
x = np.linspace(0,14, 10)
y = linear_regression(best.positions, x)

plt.figure()
plt.plot(x, y, color='blue', label='line')
sns.scatterplot(x = df['YearsExperience'], y = df['Salary'], 
                s = 40, color = 'purple',
                data = df)

plt.xlabel('Years of Experience')
plt.ylabel('Salary')
plt.legend()
plt.show()