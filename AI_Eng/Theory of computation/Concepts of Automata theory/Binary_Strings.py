import random, sys
from collections import deque
#Input
k_length = int(input("Pls give me the 'k' for the alphabet or just press 'enter': "))


# Output file
sys.stdout = open('outputf.txt','w')

# Code goes here
# ========================================


if k_length == '':
    exit()
    k_length = random.randint(0, 1000)

print("{0, 1}", end ='')
print(f"^{k_length} = ", end = '')
print("{empty, ", end = '')


# Logic
number_zeros_left = 0

for i in range(1, k_length + 1):
    number_zeros_left += 1
    bits = 2**i
    for j in range(bits):
        if i == k_length and j == bits - 1:
            print(bin(j)[2::].zfill(number_zeros_left), end = '')
        else:
            print(bin(j)[2::].zfill(number_zeros_left), end = ', ')
        
    
print('}')


# ========================================
# Closing files
sys.stdout.close()

"""
 k =3

output :  {e, 0, 1, 00, 01, 10, 11, 000, 001, 010, 011, 100, 101, 110, 111}   

T: O(2^k + 2^k-1 + 2^k-2 + ... + 2^1 + 2^0) = O(2^k) 
O: O(1)   only output.txt

""" 



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

chain = [1]   # empty = epsilon
number_of_1s = [0] # 0 

df = pd.DataFrame({'chain': chain, 'number_of_1s': number_of_1s})

for i in range(2, bits + 2):
    new_row = {'chain': i, 'number_of_1s': hammingWeight(i - 2)}
    df = pd.concat([df, pd.DataFrame([new_row])], ignore_index=True)

# save to csv file
df.to_csv('Binary_Strings.csv', index = False)


# Plotting
# only dots and integers
plt.plot(df['chain'], df['number_of_1s'], 'bo')
plt.title('Binary Strings')
plt.xlabel('Chain')
plt.ylabel('Number of 1s')
plt.show()




