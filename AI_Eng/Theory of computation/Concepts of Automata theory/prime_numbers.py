import random, sys
from collections import deque
#Input
n = int(input("Pls give me the max number to check prime numbers or just press 'enter': "))



# Output file
sys.stdout = open('outputf.txt','w')


if n == '':
    exit()
    n = random.randint(0, 10000)

print("{", end = '')

# Code goes here
# ========================================
from math import sqrt

def isPrime(n):
    if(n > 1):
        for i in range(2, int(sqrt(n)) + 1):
            if (n % i == 0):
                return False

        return True
    else:
        return False
    
prime_numbers = []

for number in range(n + 1):
    if (isPrime(number)):
        prime_numbers.append(number)
        print(bin(number)[2::], end = ', ')

print('}')


# ========================================
# Closing files
sys.stdout.close()


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

chain = []   # empty = epsilon
number_of_1s = [] # empty = epsilon


def hammingWeight(n):
    """
    :type n: int
    :rtype: int
    """
    mask = 1
    count = 0
    while n != 0:
        if (mask & n == 1):
            count = count + 1
        n = n>>1

    return count

i = 1

for prime in prime_numbers:
    chain.append(i)
    i += 1
    number_of_1s.append(hammingWeight(prime))

    

df = pd.DataFrame({'chain': chain, 'number_of_1s': number_of_1s})

# save to csv file
df.to_csv('primes.csv', index = False)


# Plotting
# only dots and integers
plt.plot(df['chain'], df['number_of_1s'], 'bo')
plt.title('Binary Strings')
plt.xlabel('Chain')
plt.ylabel('Number of 1s')
plt.show()




