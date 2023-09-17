import random
import time

from math import sqrt
# graph libs
import pandas as pd
import matplotlib.pyplot as plt

import argparse


'''
    start = 0, 0

     1   [2]  3
    [4]  5   [6]
     7  [8]  9    

'''


def main(args):
    paths =  open("paths.txt", "w")

    board = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]

    black_positions = set([(0, 0), (0, 2), (1, 1), (2, 0), (2, 2)])
    red_positions = set([(0, 1), (1, 0), (1, 2), (2, 1)])

    configurations = args.configurations
    color = {"r": red_positions, "b": black_positions}
    

    def dfs(r, c, index, path):
        
        # Base case
        if min(r, c) < 0 or max(r, c) > 2 or index > len(configurations) or (r, c) not in color[configurations[index - 1]]:
            return
        
        
        # Recursive case
        path += str(board[r][c])

        if len(path) >= len(configurations) + 1:
            print(path)
            paths.write(path + "\n")
            return

        # front and back
        dfs(r - 1, c, index + 1, path)
        dfs(r + 1, c, index + 1, path)
        dfs(r, c - 1, index + 1, path)
        dfs(r, c + 1, index + 1, path)

        # Diagonals
        dfs(r - 1, c - 1, index + 1, path)
        dfs(r - 1, c + 1, index + 1, path)
        dfs(r + 1, c - 1, index + 1, path)
        dfs(r + 1, c + 1, index + 1, path)

    dfs(0, 1, 1, "1")
    dfs(1, 0, 1, "1")
    dfs(1, 1, 1, "1")

    # closi files
    paths.close()
    classify_paths()


def classify_paths():
    solutions = open("solution_paths.txt", "w")
    errors = open("error_paths.txt", "w")

    # read paths
    paths = open("paths.txt", "r")

    # the end should be 9
    for line in paths:
        if line[-2] == "9":
            solutions.write(line)
        else:
            errors.write(line)

    # closi files
    solutions.close()
    errors.close()



def parse_args():
    # setup arg parser
    parser = argparse.ArgumentParser()

    # add arguments
    parser.add_argument("configurations",
                        type=str, help="string of the board configuration",
                        default="rbb", nargs='?')
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
    print("String of the board configuration: {}".format(args.configurations))
    # add space in logs
    print("*" * 60)
    print("\n\n")