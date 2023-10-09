import random
import time
from math import sqrt
# graph libs
import pandas as pd
import matplotlib.pyplot as plt

import argparse

import math

def main(args):
    # Input file
    file = args.file
    # file = input("Enter file name: ")

    # reading file:
    code_file = open(file, 'r')
    lines_of_code = code_file.readlines()

    reserved_words_file = open('Reserved words in C.txt', 'r')
    reserved_words = reserved_words_file.readlines()

    # First lets make the NFA table with the reserved words:
    NFA_table_file =  open('NFA table.csv', 'w')

    # Titles for CSV file:
    # 1 .- find all letters and its repetitions:
    letters = {'W': 0}
    i = 1
    for line in reserved_words:
        aux_word = {}
        for char in line:
            if char == '\n':
                continue
            

            if char not in letters:
                letters[char] = i
                aux_word[char] = i
                i += 1  
                continue
                

            if char in aux_word:

                      
                repeted = 1
                while char + str(repeted) in aux_word:
                    repeted += 1
                
                if char + str(repeted) not in letters:
                    letters[char + str(repeted)] = i
                    i += 1
                aux_word[char + str(repeted)] = i
                

                
            
            aux_word[char] = i
                


        
    
    # 2 .- write title in file
    NFA_table_file.write('states, ')
    for letter in letters:
        if letter == '\n':
            continue
        NFA_table_file.write(letter + ', ')


    state = 2
    for line in reserved_words:
        NFA_table_file.write('\n1, ')
        word = [0] * len(letters)
        word[0] = 1
        aux_word = {}
        for char in line:
            if char == '\n':
                break

            if char in aux_word:
               
                
                repeted = 1
                while char + str(repeted) in aux_word:
                    repeted += 1

                           
                aux_word[char + str(repeted)] = state
                word[letters[char + str(repeted)]] = state
                state += 1
                continue
                

            aux_word[char] = state
            word[letters[char]] = state
            state += 1
        
        # Printing word in file:
        for i in range(len(word)):
            NFA_table_file.write(str(word[i]) + ', ')
        
    NFA_table_file.write('\n')

    # 3.- passing csv to excel:
    NFA_table_file.close()
    NFA_table_file = pd.read_csv('NFA table.csv')
    NFA_table_file.to_excel('NFA table.xlsx', index=None, header=True, sheet_name="NFA table")


    # 4.- Transforming NFA into  a DFA with a BFS:
    


    # Closing files:
    code_file.close()
    reserved_words_file.close()
    


    


def parse_args():
    # setup arg parser
    parser = argparse.ArgumentParser()

    # random default value
    default_file = 'GaussJordan.c'


    # add arguments
    parser.add_argument("file",
                        type=str, help="file of program in C to be analyzed",
                        default=default_file, nargs='?')
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
    print("File checked {}".format(args.file))
    # add space in logs
    print("*" * 60)
    print("\n\n")