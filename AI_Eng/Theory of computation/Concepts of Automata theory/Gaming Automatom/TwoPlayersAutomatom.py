import random
import time

from math import sqrt
# graph libs
import pandas as pd
import matplotlib.pyplot as plt

import argparse

import turtle
from PIL import Image


import re
'''
    start = 0, 0
    0     1    2   3
0     A   [B]  C  [D]
1    [E]   F  [G]  H
2     I   [J]  K   [L]
3    [M]   N   [O]  P  

'''


def main(args):
    paths =  open("paths.txt", "w")

    board = [['A', 'B', 'C', 'D'], ['E', 'F', 'G', 'H'], ['I', 'J', 'K', 'L'], ['M', 'N', 'O', 'P']]

    black_positions = set([(0, 0), (0, 2), (1, 1), (1, 3), (2, 0), (2, 2), (3, 1), (3, 3)])
    red_positions = set([(0, 1), (0, 3), (1, 0), (1, 2), (2, 1), (2, 3), (3, 0), (3, 2)])

    red_squares = ['B', 'D', 'E', 'G', 'J', 'L', 'M', 'O']
    black_squares = ['A', 'C', 'F', 'H', 'I', 'K', 'N', 'P']

    player1_configurations = input("Enter the string of the player1: ")
    player2_configurations = input("Enter the string of the player2: ")

    size = random.randint(5, 7)
    
    if not player1_configurations and not player2_configurations:
        for _ in range(size):
            player1_configurations += random.choice(["r", "b"])
            player2_configurations += random.choice(["r", "b"])

    
        # Checking if the size of both strings are equal in size
    if len(player1_configurations) != len(player2_configurations):
        size = max(len(player1_configurations), len(player2_configurations))
        if size == len(player1_configurations):
            for _ in range(size - len(player2_configurations)):
                player2_configurations += random.choice(["r", "b"])
        else:
            for _ in range(size - len(player1_configurations)):
                player1_configurations += random.choice(["r", "b"])

    if player1_configurations[-1] != "b":
        player1_configurations = player1_configurations[:-1] + "b"
    
    if player2_configurations[-1] != "r":
        player2_configurations = player2_configurations[:-1] + "r"





    color = {"r": red_positions, "b": black_positions}

    squares = {"r": red_squares, "b": black_squares}
    

    def dfs(r, c, index, path, configurations):
        
        # Base case
        if min(r, c) < 0 or max(r, c) > 3 or index > len(configurations) or (r, c) not in color[configurations[index - 1]]:
            return
        
        # Recursive case
        path += board[r][c]

        if len(path) >= len(configurations) + 1:

            paths.write(path + "\n")
            return
        
        # front and back
        dfs(r - 1, c, index + 1, path, configurations)
        dfs(r + 1, c, index + 1, path, configurations)
        dfs(r, c - 1, index + 1, path, configurations)
        dfs(r, c + 1, index + 1, path, configurations)

        # Diagonals
        dfs(r - 1, c - 1, index + 1, path, configurations)
        dfs(r - 1, c + 1, index + 1, path, configurations)
        dfs(r + 1, c - 1, index + 1, path, configurations)
        dfs(r + 1, c + 1, index + 1, path, configurations)

    # First player

    dfs(0, 1, 1, "A", player1_configurations)
    dfs(1, 0, 1, "A", player1_configurations)
    dfs(1, 1, 1, "A", player1_configurations)




    # Player 2
    dfs(0, 2, 1, 'D', player2_configurations)
    dfs(1, 2, 1, 'D', player2_configurations)
    dfs(1, 3, 1, 'D', player2_configurations)

    # closing files
    paths.close()

    # Classify paths
    classify_paths()

    
    # draw paths
    columns = len(player1_configurations) + 1
    p1_paths_file = "player1_paths.txt"
    p2_paths_file = "player2_paths.txt"

    draw_paths(columns, player1_configurations, squares, p1_paths_file, "A",'Player1Paths')
    draw_paths(columns, player2_configurations, squares, p2_paths_file, "D",'Player2Paths')

    print("String configuration of the player1: {}".format(player1_configurations))
    print("Size of the string of p1: {}".format(len(player1_configurations)))
    print("String configuration of the player2: {}".format(player2_configurations))
    print("Size of the string of p2: {}".format(len(player2_configurations)))



    # Animation game
    p1_paths_file = "player1_correct_paths.txt"
    p2_paths_file = "player2_correct_paths.txt"
    make_animation(p1_paths_file, p2_paths_file, board)

    # find_path("player1_correct_paths.txt", "DCF", 'F')


def make_player(color, x, y):
    simon = turtle.Turtle()
    simon.shape('turtle')
    simon.penup()
    simon.showturtle()
    simon.setpos(x,y)
    simon.color(color)
    simon.shapesize(3,3,3)
    return simon


def find_path(paths, actual_path, without_letter=""):
    # Leer paths
    with open(paths, "r") as file:
        content = file.read()

    # Construir el patrón con actual_path y sin without_letter
    pattern = r'\b' + re.escape(actual_path) + r'[^' + re.escape(without_letter) + r']\w*'

    good_paths = re.findall(pattern, content)

    if not good_paths:
        # print("No way man")
        return None
    # print(good_paths)
    return good_paths[0]

def move_turtle(simon, letter, positions):
    simon.setpos(positions[letter][0], positions[letter][1])

def congratulate(simon, winner):
    simon.penup()
    simon.setpos(-200, -300)
    simon.color('#FFFFFF')
    simon.write("Congratulations {} you won!".format(winner), font=('Arial', 25, 'normal'))
    simon.penup()
    simon.setpos(0, 0)

def define_positions_in_board(board):
    positions = {}
    pos_y = 250
    for row in board:
        pos_x = -240
        for letter in row:
            positions[letter] = (pos_x, pos_y)
            pos_x += 160
        pos_y -= 150

    return positions

def Move_to_position(simon, letter, positions):
    simon.setpos(positions[letter][0], positions[letter][1])

def make_animation(player1_file, player2_file, board):

    turtle.TurtleScreen._RUNNING=True    
    simon = initTurtle()
    window = initWindow()
    make_board(simon, board)


    
    player1 = make_player('#4D3D3D', -240, 250)
    player2 = make_player('#FBAC32', 240,250)
    player2.left(180)
    
    turtle.tracer(1,50)

    # Positions:
    positions = define_positions_in_board(board)


    winner = False
    

    # Whose first?
    path_player1 = "A"
    index_player1 = 0
    index_player2 = 0
    path_player2 = "D"
    
    path_chosed_player1 = find_path(player1_file, 'A', 'X')
    path_chosed_player2 = find_path(player2_file, 'D', 'X')
    
    if not path_chosed_player1 or not path_chosed_player2:
        print("Theres a problem with the paths of:")
        if not path_chosed_player1:
            print("Player1")
        else:
            print("Player2")

        return

    curr_player = random.choice([player1, player2])
    competitor = player1 if curr_player == player2 else player2

    curr_chosed = path_chosed_player1 if curr_player == player1 else path_chosed_player2
    competitor_chosed = path_chosed_player1 if curr_player == player2 else path_chosed_player2

    curr_path = path_player1 if curr_player == player1 else path_player2
    competitor_path = path_player1 if curr_player == player2 else path_player2

    curr_index = index_player1 if curr_player == player1 else index_player2
    competitor_index = index_player1 if curr_player == player2 else index_player2

    curr_file = player1_file if curr_player == player1 else player2_file
    competitor_file = player1_file if curr_player == player2 else player2_file

    while not winner:
        
        
        # wineer break
        if competitor_index == len(competitor_chosed) - 1:
            winner = competitor
            break

        # Move the turtle
        # "AF"  'BF'    'AF'   'B'
        # print(curr_chosed, curr_index)
        # print(curr_chosed[curr_index + 1])
        if curr_chosed[curr_index + 1] == competitor_path[-1]:
            # print("---------------CHANGE PATH ----------")
            # print('curr path:', curr_chosed)
            
            # Change Path
            aux_path = curr_chosed
            # print( curr_path, competitor_path[-1])
            curr_chosed = find_path(curr_file, curr_path, competitor_path[-1])
            # print('new path: ', curr_chosed)
            if not curr_chosed:
                # pass next turn
                curr_chosed = aux_path
                
                # change turn
                curr_file, competitor_file = competitor_file, curr_file
                curr_player, competitor = competitor, curr_player
                curr_chosed, competitor_chosed = competitor_chosed, curr_chosed
                curr_path, competitor_path = competitor_path, curr_path
                curr_index, competitor_index = competitor_index, curr_index
                continue

        curr_index += 1
        curr_path += curr_chosed[curr_index]
        Move_to_position(curr_player, curr_path[-1], positions)
        

        # change turn
        curr_file, competitor_file = competitor_file, curr_file
        curr_player, competitor = competitor, curr_player
        curr_chosed, competitor_chosed = competitor_chosed, curr_chosed
        curr_path, competitor_path = competitor_path, curr_path
        curr_index, competitor_index = competitor_index, curr_index


        
    if winner == player1:
        congratulate(simon, "player1")
    else:
        congratulate(simon, "player2")
        
        
    window.exitonclick()


def write_board(simon, x, y, curr_color, letter):
    simon.penup()
    simon.setpos(x + 65, y + 75)
    simon.color('#FFFFFF')
    simon.write(letter, font=('Arial', 25, 'normal'))
    simon.penup()
    simon.setpos(x, y)
    simon.color(curr_color)


def make_board(simon, board):
    turtle.tracer(0, 0)

    simon.penup()
    simon.setpos(-300, 200)
    simon.pendown()
    red = '#FA0303'
    black = '#000000'

    curr_color = red
    aux_y = 200
    for row in board:
        simon.setpos(-300, aux_y)
        curr_color = red if curr_color == black else black
        for letter in row:
            simon.fillcolor(curr_color)
            simon.begin_fill()
            # square
            for _ in range(4):
                simon.forward(150)
                simon.left(90)
            simon.end_fill()

            write_board(simon, simon.xcor(), simon.ycor(), curr_color, letter)

            simon.forward(150)
            curr_color = red if curr_color == black else black

        simon.penup()
        aux_y -= 150


def classify_paths():
    p1_solutions = open("player1_correct_paths.txt", "w")
    p2_solutions = open("player2_correct_paths.txt", "w")

    p1_paths = open("player1_paths.txt", "w")
    p2_paths = open("player2_paths.txt", "w")

    # read paths
    paths = open("paths.txt", "r")

    # the end should be 9
    for line in paths:
        if line[0] == 'A':
            if line[-2] == 'P':
                p1_solutions.write(line)
            else:
                p1_paths.write(line)
        else:
            if line[-2] == 'M':
                p2_solutions.write(line)
            else:
                p2_paths.write(line)

    # closi files
    p1_solutions.close()
    p2_solutions.close()
    p1_paths.close()
    p2_paths.close()



def initWindow():
    window = turtle.Screen()
    window.setup(width=900, height=800)
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



def draw_paths(columns, configurations, squares, paths_file, start, file_name):
    turtle.TurtleScreen._RUNNING=True    
    turtle.tracer(0,0)
    simon = initTurtle()
    window = initWindow()

    # read paths
    paths = open(paths_file, "r")

    edge_size = 600 / (columns - 1)
    state_size = 300 / (columns + 2)

    arrow_size  = 15*state_size/100

    x_pos = -(450 - 450/(columns + 10))
    y_pos = 350
    # draw states
    # start
    drawStates(x_pos, y_pos, simon, start, state_size)

    aux_x = x_pos
    for i in range(0, len(configurations)):
        aux_x += edge_size + state_size + 10
        aux_y = y_pos
        for color in squares[configurations[i]]:
            drawStates(aux_x, aux_y, simon, color, state_size)
            aux_y -= state_size + 30

    #  drawing connections
    levels = {}
    aux_y = y_pos
    dobles = 0
    boxes = "ABCDEFGHIJKLMNOP"
    for letter in boxes:
        if dobles >= 2:
            aux_y -= state_size + 30
            dobles = 0
        dobles += 1
        levels[letter] = aux_y
        

    for line in paths:
        aux_x = x_pos
        aux_y = y_pos
        simon.penup()
        simon.setpos(aux_x + state_size/2, aux_y)

        clearDigits(aux_x,aux_y, simon, line[0:-1], state_size, edge_size)
        simon.setpos(aux_x + state_size/2, aux_y)

        for digit in line[1:-1]:
            aux_x += edge_size + state_size + 10
            aux_y = levels[digit]

            drawConnectionLines(aux_x, aux_y, simon, state_size)
        
            # time.sleep(2)
        
    canvas = window.getcanvas()

    canvas.postscript(file=file_name + '.eps')
    Image.open(file_name + '.eps').save(file_name + '.png', 'png')
    
    window.exitonclick()

def parse_args():
    # setup arg parser
    parser = argparse.ArgumentParser()

    # no input
    size = random.randint(4, 7)
    # size = 7
    configurations_player1 = ""
    configurations_player2 = ""

    for _ in range(size):
        configurations_player1 += random.choice(["r", "b"])
        configurations_player2 += random.choice(["r", "b"])


    # add arguments
    parser.add_argument("player1_configurations",
                        type=str, help="string of the board configuration",
                        default= configurations_player1, nargs='?')
    
    parser.add_argument("player2_configurations",
                        type=str, help="string of the board configuration",
                        default= configurations_player2, nargs='?')
    # parse args
    args = parser.parse_args()

    # Checking if the size of both strings are equal
    if len(args.player1_configurations) != len(args.player2_configurations):
        size = max(len(args.player1_configurations), len(args.player2_configurations))
        if size == len(args.player1_configurations):
            for _ in range(size - len(args.player2_configurations)):
                args.player2_configurations += random.choice(["r", "b"])
        else:
            for _ in range(size - len(args.player1_configurations)):
                args.player1_configurations += random.choice(["r", "b"])

    if args.player1_configurations[-1] != "b":
        args.player1_configurations = args.player1_configurations[:-1] + "b"
    
    if args.player2_configurations[-1] != "r":
        args.player2_configurations = args.player2_configurations[:-1] + "r"
    
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
    # add space in logs
    print("*" * 60)
    print("\n\n")