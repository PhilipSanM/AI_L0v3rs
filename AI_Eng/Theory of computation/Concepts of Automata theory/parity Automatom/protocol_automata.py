import random
import time

import turtle

import argparse


def main(args):
    bits = 64
    total = 10000000
    while True:
        
        if checkAutomatonStatus():
            createStrins(bits, total)
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

            plotStates()





def initWindow():
    window = turtle.Screen()
    window.setup(width=900, height=850)
    window.bgcolor('#10F7DE')
    window.title('Parity Automaton')
    return window

def initTurtle():
    simon = turtle.Turtle()
    simon.speed('fastest')
    simon.hideturtle()
    simon.setpos(0,0)
    simon.pensize(3)
    simon.pendown()
    return simon

def drawConnectionLines(x, y, radius, simon):
    simon.penup()
    simon.setpos(x, y)
    simon.pendown()
    simon.circle(radius)

def drawStates(x, y, simon, state):
    simon.penup()
    simon.setpos(x, y)
    simon.pendown()
    simon.dot(100, '#18D694')
    simon.penup()

    simon.setpos(x - 5, y - 10)
    simon.write(state, font=('Arial', 16, 'normal'))

def drawArrows(x, y, simon):
    simon.penup()
    simon.setpos(x, y)
    simon.pendown()
    simon.dot(15, '#000000')

def writeArrows(x, y, simon, label):
    simon.penup()
    simon.color('#000000')
    simon.setpos(x, y)
    simon.pendown()
    simon.write(label, font=('Arial', 16, 'normal'))


def plotStates():
    

    turtle.TurtleScreen._RUNNING=True   
    turtle.tracer(0, 0) 
    simon = initTurtle()
    window = initWindow()

    

    connection_lines_data = [[0, -250, 240], [0, -280, 270]]

    for pos in connection_lines_data:
        drawConnectionLines(pos[0], pos[1], pos[2], simon)


    
    # Final state, dobule circle
    simon.penup()
    simon.setpos(-220, 125)
    simon.pendown()
    simon.dot(110, '#0F9D74')
    simon.penup()


    states = ['q0', 'q1', 'q2', 'q3']

    pos_states = [[-220, 125], [220, 125], [220, -150], [-220, -150]]

    for i in range(len(states)):
        drawStates(pos_states[i][0], pos_states[i][1], simon, states[i])

    # Start
    simon.penup()
    simon.setpos(-220, 250)
    simon.pendown()

    simon.right(90) 
    simon.forward(70)
    simon.dot(15, '#000000')

    simon.penup()
    simon.setpos(-270, 250)
    simon.write('start', font=('Arial', 16, 'normal'))


    # Arrows
    arrows_pos = [[-197, 175], [-225, 70], [250, 85], [178, 153], [194, -195], [220, -100], [-250, -110], [-175, -175]]

    for pos in arrows_pos:
        drawArrows(pos[0], pos[1], simon)


    # Writing arrows
    arrows_data = [["'0'", 0, 200], ["'0'", 0, 260], ["'0'", 0, -250], ["'0'", 0, -310], ["'1'", -230, 0], ["'1'", -290, 0], ["'1'", 210, 0], ["'1'", 280, 0]]


    for data in arrows_data:
        writeArrows(data[1], data[2], simon, data[0])


    # Drawing protocol
    drawStates(-220, 350, simon, 'Q0')
    
    drawConnectionLines(220, 350, 40, simon)
    drawStates(220, 350, simon, 'Q1')

    # Lines
    simon.penup()
    simon.setpos(-180, 380)
    simon.pendown()
    simon.setpos(180, 380)
    drawArrows(180, 380, simon)

    simon.penup()
    simon.setpos(175, 340)
    simon.pendown()
    simon.setpos(-175, 340)
    drawArrows(-175, 340, simon)

    drawArrows(250, 310, simon)

        # Start
    simon.penup()
    simon.setpos(-350, 350)
    simon.pendown()

    simon.right(90) 
    simon.right(90) 
    simon.right(90) 
    simon.forward(70)
    simon.dot(15, '#000000')

    simon.penup()
    simon.setpos(-380, 350)
    simon.write('start', font=('Arial', 16, 'normal'))
    
    simon.penup()
    simon.setpos(330, 350)
    simon.write('time out', font=('Arial', 16, 'normal'))

    simon.penup()
    simon.setpos(0, 300)
    simon.write('ack', font=('Arial', 16, 'normal'))



    # Window close
    window.exitonclick()

    

'''
      | start
      v     '0'
    [[q0]] <--> [q1]
      ^          ^
      | '1'      | '1'
      v          v
     [q3] <--> [q2]
           '0'

'''



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

    max_number = 2 ** bits
    for j in range(total):
        
        output.write(bin(
            random.randint(0, max_number - 1)
        )[2::].zfill(number_zeros_left) + '\n')

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