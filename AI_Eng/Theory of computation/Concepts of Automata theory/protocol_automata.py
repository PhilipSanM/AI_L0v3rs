import random
import time

from math import sqrt
# graph libs
import pandas as pd
import matplotlib.pyplot as plt

import argparse


def main(args):
    while True:
        if checkAutomatonStatus():
            bits = args.bits
            total = args.total
            createStrins(bits, total)
            # createStrins(64, 100000)
            parity = open('parity.txt', 'w')
            nonparity = open('nonparity.txt', 'w')

            # Sleep
            time.sleep(2)

            binary_strings = open('BinaryStrings.txt', 'r')
            for line in binary_strings:
                if parity_automaton(line.strip()):
                    parity.write(line)
                else:
                    nonparity.write(line)

            # closing files
            parity.close()
            nonparity.close()
            binary_strings.close()

            # ?
            contin = input('Do you want to continue? (y/n): ')
            if contin == 'n':
                break

def checkAutomatonStatus():
    status = random.randint(0, 1)
    if status == 0:
        return True
    else:
        return False

def createStrins(k, total):
    bits = k
    output = open('BinaryStrings.txt', 'w')
    
    number_zeros_left = bits
    for j in range(total):
        output.write(bin(j)[2::].zfill(number_zeros_left) + '\n')

    output.close()

def parity_automaton(string):
    state = 'q0'
    for bit in string:
        if bit == '0' and state == 'q0':
            state = 'q1'
        elif bit == '1' and state == 'q0':
            state = 'q3'
        elif bit == '0' and state == 'q1':
            state = 'q0'
        elif bit == '1' and state == 'q3':
            state = 'q0'
        elif bit == '1' and state == 'q1':
            state = 'q2'
        elif bit == '1' and state == 'q2':
            state = 'q1'
        elif bit == '0' and state == 'q2':
            state = 'q3'
        else:
            state = 'q2'

    if state == 'q0':
        return True
    else:
        return False

def parse_args():
    # setup arg parser
    parser = argparse.ArgumentParser()

    # add arguments
    parser.add_argument("bits",
                        type=int, help="length of binary strings to be generated",
                        default=8, nargs='?')

    parser.add_argument("total",
                        type=int, help = 'total number of strings to be generated',
                        default=10, nargs='?')
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
    print("Number of total strings checked: {}".format(args.total))
    print('Size of each string: {}'.format(args.bits))
    # add space in logs
    print("*" * 60)
    print("\n\n")