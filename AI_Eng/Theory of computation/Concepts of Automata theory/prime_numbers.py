import random, sys
from collections import deque
#Input
n = int(input("Pls give me the max number to check prime numbers or just press 'enter': "))


# Output file
sys.stdout = open('outputf.txt','w')

# Code goes here
# ========================================

# GRAPH
import pandas as pd
import matplotlib.pyplot as plt
'''
  Data frame:
# k = 3
# bits = 2**3
bits = 8
chain        number_of_1s
 1              0         -> epsilon   
 2              0         -> '000'
 3              1         -> '001'
 4              1         -> '010'
 5              2         -> '011'
 6              1         -> '100'
 7              2         -> '101'
 8              2         -> '110'
 9              3         -> '111'

'''

chain = [1]   # empty = epsilon
number_of_1s = [0] # 0 

for i in range(2, bits + 2):
    chain.append(i)
    number_of_1s.append(bin(i - 2).count('1'))

df = pd.DataFrame({'chain': chain, 'number_of_1s': number_of_1s})

# save to csv file
df.to_csv('Binary_Strings.csv', index = False)


# Plotting
# only dots and integers
plt.plot(df['chain'], df['number_of_1s'], 'bo')
plt.title('Binary Strings')
plt.xlabel('Chain')
plt.ylabel('Number of 1s')
plt.show()




# ========================================
# Closing files
sys.stdout.close()