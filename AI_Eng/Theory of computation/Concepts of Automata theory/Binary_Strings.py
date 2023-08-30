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

alphabet = ['0', '1']

cache = deque()
times = 1



for size in range(k_length):
    cache += cache

    if len(cache) == 0:
        for letter in alphabet:
            cache.append(letter)
    else:
        # print('inicio', cache)
        for letter in alphabet:
            for _ in range(times):
                combination = cache.popleft()
                new_combination = letter + combination
                # print(new_combination)
                # print(cache)
                cache.append(new_combination)

    
    # printing:
    for combination in cache:
        if combination == cache[-1] and size == k_length -1:
            print(f"{combination}", end = '')
        else:
            print(f"{combination}, ", end = '')


    times *= 2

print('}')


"""
 k =3

cache =    0
           1
         1.- repeat values
         2.- add 0 and 1 to the beginin, also having a value of times * 2
         3.- print cache
cache  =     00
             01    
             10
             11
             

cache  =     000
             001
             010
             011

             100
             101
             110
             111

"""     







# ========================================
# Closing files
sys.stdout.close()