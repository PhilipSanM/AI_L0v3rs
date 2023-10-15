import random
import time
from math import sqrt
# graph libs
import pandas as pd
import matplotlib.pyplot as plt

import argparse
import collections

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
    NFA_table_file.write('states,')
    for letter in letters:
        if letter == '\n':
            continue
        NFA_table_file.write(letter + ',')

    NFA_table_file.write('reserved word')


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

        NFA_table_file.write(line)

        
    NFA_table_file.write('\n')

    # 3.- passing csv to excel:
    NFA_table_file.close()
    NFA_table_file = pd.read_csv('NFA table.csv')
    NFA_table_file.to_excel('NFA table.xlsx', index=None, header=True, sheet_name="NFA table")



    # 4.- Transforming NFA into  a DFA with a BFS:

    # New file:
    DFA_table_file = open('DFA table.csv', 'w')

    # working with NFA table and making BFS:
    headers = ['states', 'W']
    letters = {'W': set([1])}

    for line in reserved_words:
        for char in line:
            if char  == '\n':
                continue
            if char not in letters:
                headers.append(char)

            letters[char] = set()

    # 4.1- write headers:

    for header in headers:
        DFA_table_file.write(header + ',')

    DFA_table_file.write('new state')

    # closing
    DFA_table_file.close()

    DFA_dataframe = pd.read_csv('DFA table.csv')

    # 4.2 - Find all states with a BFS:

    queue = collections.deque()
    total_states = set()

    queue.append([1])
    total_states.add(tuple([1]))



    while len(queue) > 0:

        # array of lletters:
        aux_letters = letters.copy()
  
        
        curr_states = queue.popleft()

        # Making search for all of that states
        for state in curr_states: # [1, 2, 60]
            if state == 0:
                continue
            

            def helper(state):# 1
                
                new_states = letters.copy()
                table_NFA = pd.read_csv('NFA table.csv')
                
                if state == 1:
                    for letter in letters:
                        for line in reserved_words:
                            if letter == line[0]:

                                states = []
                                index = table_NFA.index[table_NFA['reserved word'] == ' ' +line[:-1]].tolist()[0]
                    
                                for i in range(len(table_NFA.loc[index]) - 1):
                                    # print(i, index, 'XD')
                                    # print(int(table_NFA.iloc[index,i]))
                                    if int(table_NFA.iloc[index,i]) != 0 and int(table_NFA.iloc[index,i]) != 1:
                                        states.append(int(table_NFA.iloc[index,i]))
                                min_state = min(states)
                                new_states[letter].add(min_state)
                                continue
                            
                            new_states[letter].add(1)
                             

                else:
                    # find state in table
                    states = []
                    for letter in letters:
                        
                        index = table_NFA.index[table_NFA[letter] == state].tolist()

                        if len(index) != 0:
                            index = index[0]
                            break
                    
                    for i in range(len(table_NFA.loc[index]) - 1):
                        states.append(int(table_NFA.iloc[index,i]))

                    if max(states) != state:
                        # find next letter:

                        for letter in letters:
                            if table_NFA[table_NFA[letter] == state].empty:

                                new_states[letter].add(state + 1)
                return new_states
                
            


            new_states = helper(state) # {'W': [1], 'a':[1, 2], 'u': [1, 60]}

            # adding new states to the dic:
            for letter, states in new_states.items():
                
                for aux_state in states:
                    aux_letters[letter].add(aux_state)
                    aux_letters[letter] = set(sorted(aux_letters[letter]))


        # adding new states to the queue:

        for letter, states in aux_letters.items():
            if tuple(states) not in total_states and len(states) > 0:
  
                queue.append(states)
                total_states.add(tuple(states))

        # printing in csv:
        aux_letters['states'] = curr_states
        DFA_dataframe.loc[len(DFA_dataframe)] = aux_letters


    # saving csv
    DFA_dataframe.to_csv('DFA table.csv', index=None, header=True)

    # 5.- passing csv to excel
    DFA_dataframe.to_excel('DFA table.xlsx', index=None, header=True, sheet_name="DFA table")






    


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