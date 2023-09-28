import random
import time
from math import sqrt
# graph libs
import pandas as pd
import matplotlib.pyplot as plt

import argparse

import math

def main(args):
    while True:
        n = input("Pls give me the max number to check prime numbers or just press 'enter': ")
        if n == '':
            n = random.randint(0, 100000000)
        else:
            n = int(n)

        print(f"Your n is: {n}")



        # OUTPUT FILES
        primes = open('primes.txt', 'w')
        df = open('primes_data.txt', 'w')
        df_log = open('primes_log10.txt','w')

        # BASIC INFO
        primes.write("{")
        df.write('chain,number_of_1s\n')
        df_log.write('chain,number_of_1s\n')
        # LOGIC
        i = 0
        for number in range(n + 1):
            if (isPrime(number)):
                primes.write(bin(number)[2::] + ', ')

                df.write(str(i) + ',' + str(hammingWeight(number)) + '\n')
                df_log.write(str(i) + ',' + str(round(math.log10(hammingWeight(number)), 4)) + '\n')
                i += 1

        primes.write('}')


        # CLOSE FILES
        primes.close()
        df.close()
        df_log.close()


        # # PLOT
        # df = pd.read_csv('primes_data.txt')
        # df_log = pd.read_csv('primes_log10.txt')
        # # Plotting
        # # only dots and integers
        # plt.plot(df['chain'], df['number_of_1s'], 'bo')
        # plt.title('Primes Binary Strings')
        # plt.xlabel('Chain')
        # plt.ylabel('Number of 1s')
        # plt.show()

        # plt.plot(df_log['chain'], df_log['number_of_1s'], 'bo')
        # plt.title('Primes Binary Strings in log10')
        # plt.xlabel('Chain')
        # plt.ylabel('Number of 1s')
        # plt.show()

        if input("Do you want to continue? (y/n): ") == 'n':
            break
        print("-"*60)


def isPrime(n):
    if(n > 1):
        for i in range(2, int(sqrt(n)) + 1):
            if (n % i == 0):
                return False

        return True
    else:
        return False
    

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



def parse_args():
    # setup arg parser
    parser = argparse.ArgumentParser()

    # random default value
    default_n = random.randint(0, 10000000)


    # add arguments
    parser.add_argument("n",
                        type=int, help="number of primes numbers to check",
                        default=default_n, nargs='?')
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
    print("Number of primes numbers checked: {}".format(args.n))
    # add space in logs
    print("*" * 60)
    print("\n\n")