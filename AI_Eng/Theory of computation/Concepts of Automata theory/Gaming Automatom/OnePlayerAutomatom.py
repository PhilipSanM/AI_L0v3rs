import random
import time

from math import sqrt
# graph libs
import pandas as pd
import matplotlib.pyplot as plt

import argparse

import turtle


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

    red_squares = [2, 4, 6, 8]
    black_squares = [1, 3, 5, 7, 9]

    configurations = args.configurations
    color = {"r": red_positions, "b": black_positions}

    squares = {"r": red_squares, "b": black_squares}
    

    def dfs(r, c, index, path):
        
        # Base case
        if min(r, c) < 0 or max(r, c) > 2 or index > len(configurations) or (r, c) not in color[configurations[index - 1]]:
            return
        
        # Recursive case
        path += str(board[r][c])

        if len(path) >= len(configurations) + 1:
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

    # classifying paths
    classify_paths()

    # draw paths
    turtle.tracer(0, 0)
    columns = len(configurations) + 1
    draw_paths(columns, configurations, squares)


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


def initWindow():
    window = turtle.Screen()
    window.setup(width=900, height=700)
    window.bgcolor('#10F7DE')
    window.title('Parity Automaton')
    return window

def initTurtle():
    simon = turtle.Turtle()
    simon.speed('fastest')
    simon.hideturtle()
    simon.setpos(0,0)
    simon.pensize(1)
    simon.pendown()
    return simon

def drawStates(x, y, simon, state, size):
    simon.penup()
    simon.setpos(x, y)
    simon.pendown()
    simon.dot(size, '#18D694')
    
    simon.penup()
    simon.setpos(x, y)
    letter_size = int(16*size/100)
    simon.write(state, font=('Arial', letter_size, 'normal'))

def drawArrows(x, y, simon, size):
    simon.penup()
    simon.setpos(x, y)
    simon.pendown()
    simon.dot(size, '#000000')

def drawConnectionLines(x, y, simon, state_size):
    simon.pendown()
    simon.setpos(x - state_size / 2, y)
    drawArrows(x - state_size/2, y, simon, 15*state_size/100)
    simon.penup()
    simon.setpos(x + state_size / 2, y)
    simon.penup()

def drawDigit(x,y, simon, digit):
    simon.penup()

    
    simon.setpos(x, -300)
    simon.dot(50, '#EBFA0B')
    simon.write(digit, font=('Arial', 16, 'normal'))

    simon.penup()
    simon.setpos(x, y)
    
def clearDigits(x,y, simon, digits, state_size, edge_size):
    simon.penup()
    simon.setpos(x - 30, -330)

    simon.fillcolor('#10F7DE')

    simon.begin_fill()
    for _ in range(2):
        simon.forward(1300)
        simon.left(90)
        simon.forward(60)
        simon.left(90)
    
    simon.end_fill()

    simon.setpos(x, y)



def draw_paths(columns, configurations, squares):

    turtle.TurtleScreen._RUNNING=True    
    simon = initTurtle()
    window = initWindow()

    # read paths
    paths = open("paths.txt", "r")

    edge_size = 600 / (columns - 1)
    state_size = 300 / columns

    arrow_size  = 15*state_size/100

    x_pos = -(450 - 450/(columns + 10))
    y_pos = 250
    # draw states
    # start
    drawStates(x_pos, y_pos, simon, "1", state_size)

    aux_x = x_pos
    for i in range(0, len(configurations)):
        aux_x += edge_size + state_size + 10
        aux_y = y_pos
        for color in squares[configurations[i]]:
            drawStates(aux_x, aux_y, simon, str(color), state_size)
            aux_y -= state_size + 30

    #  drawing connections
    levels = {}
    aux_y = y_pos
    dobles = 0
    for i in range(1, 10):
        if dobles >= 2:
            aux_y -= state_size + 30
            dobles = 0
        dobles += 1
        levels[str(i)] = aux_y
        

    for line in paths:
        aux_x = x_pos
        aux_y = y_pos
        simon.penup()
        simon.setpos(aux_x + state_size/2, aux_y)

        # clearDigits(aux_x,aux_y, simon, line[0:-1], state_size, edge_size)

        # drawDigit(aux_x,aux_y, simon, '1')
        simon.setpos(aux_x + state_size/2, aux_y)

        for digit in line[1:-1]:
            aux_x += edge_size + state_size + 10
            aux_y = levels[digit]

            drawConnectionLines(aux_x, aux_y, simon, state_size)
            
            # drawDigit(aux_x + state_size/2,aux_y, simon, digit)
            # time.sleep(2)

    window.exitonclick()



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