from Stack import Stack

import random
import time

# args
import argparse


import turtle

def main(args):
    stack = Stack()
    stack.push('Z')
    curr_state = 'q'
    
    string =  input("Input a String in the language: {0^n 1^n | n >= 1} or just press enter to generate a random string \n")

    # max_length_string = 100
    max_length_string = 10000

    if not string:
        string = generate_random_string(max_length_string)
        print("Random string generated: {}".format(string))


#   End of string
    string += '\n'


        
    # Output files:
    output = open('Outputf.txt', 'w', encoding='utf-8')

    # Logic:
    length = 0

    while True:
        if string[length] != '\n':
            length += 1
        else:
            break




    # Animation
    if length < 11:
        turtle.TurtleScreen._RUNNING=True   
        turtle.tracer(1 , 0) 
        simon = initTurtle()
        window = initWindow()

        gabriel = turtle.Turtle()
        gabriel.speed('fastest')
        gabriel.shape('turtle')
        gabriel.color('#16F097')
        gabriel.shapesize(2,2,2)
        gabriel.penup()
        gabriel.left(90)
        gabriel.setpos(-100, 160)

    i = 0
    while i < length:
        output.write(f"({curr_state}, {string[i::]}, {stack.items})\n")
        if length < 11:
            time.sleep(10)
            draw_automaton(simon, string[0:length] + chr(92) + "0", i, stack.items, curr_state)
            time.sleep(1)
            
            



        if curr_state == 'q' and string[i] == '0':
            stack.push('X')
        elif curr_state == 'q' and string[i] == '1' and stack.peek() != 'Z':
            curr_state = 'p'
            stack.pop()

        elif curr_state == 'p' and string[i] == '1' and stack.peek() != 'Z':
            stack.pop()
        else:

            curr_state = 'N/A'
            break
        i += 1  


    if length < 11 :
        draw_automaton(simon, string + chr(92) + "0", i, stack.items, curr_state)
        time.sleep(0.5)


    if curr_state == 'p' and stack.peek() == 'Z':
        curr_state = 'f'
        stack.pop()
    else:
        curr_state = 'N/A'

    if length < 11 and curr_state == 'f':
        draw_automaton(simon, "", 0, stack.items, curr_state)
        time.sleep(0.5)

    output.write(f"({curr_state}, {stack.items})\n")



    if curr_state == 'f':
        print("String is accepted in the language")
        if length < 11:
            simon.penup()
            simon.setpos(-260, 350)
            simon.pendown()
            simon.write("String is accepted in the language", font=('Arial', 22, 'normal'))

    else:
        print("String is not accepted in the language")

        if length < 11:
            simon.penup()
            simon.setpos(-260, 350)
            simon.pendown()
            simon.write("String is not accepted in the language", font=('Arial', 22, 'normal'))


    if length < 11:
    # Window close
        window.exitonclick()

    # CLose files:
    output.close()


def draw_automaton(simon, string, i, items, curr_state):
    clearString(simon,string)
    clearStack(simon)
    clearState(simon)

    # Draw string:
    simon.penup()
    simon.setpos(-200, 200)
    simon.pendown()
    simon.write('String: ' + string[i::], font=('Arial', 22, 'normal'))

    # Draw stack:
    simon.penup()
    simon.setpos(-200, -200)
    simon.pendown()
    simon.write("[" + " | ".join(items) + ']', font=('Arial', 22, 'normal'))

    simon.penup()
    simon.setpos(-200, -100)
    simon.pendown()
    simon.write('Stack: ', font=('Arial', 22, 'normal'))

    # Draw state:
    simon.penup()
    simon.setpos(0, 0)
    simon.pendown()
    simon.write("Current State: " + curr_state, font=('Arial', 22, 'normal'))

def clearState(simon):
    simon.penup()
    simon.setpos(0, 0)
    simon.fillcolor('#10F7DE')

    simon.begin_fill()
    for _ in range(2):
        simon.forward(500)
        simon.left(90)
        simon.forward(60)
        simon.left(90)
    
    simon.end_fill()

def clearStack(simon):
    simon.penup()
    simon.setpos(-210, -210)
    simon.fillcolor('#16F097')

    simon.begin_fill()
    for _ in range(2):
        simon.forward(500)
        simon.left(90)
        simon.forward(60)
        simon.left(90)
    
    simon.end_fill()


def clearString(simon,string):
    simon.penup()
    simon.setpos(-200, 200)
    simon.fillcolor('#10F7DE')

    simon.begin_fill()
    for _ in range(2):
        simon.forward(500)
        simon.left(90)
        simon.forward(60)
        simon.left(90)
    
    simon.end_fill()


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


def generate_random_string(max_length_string):
    string = ""
    length_string = random.randint(1, max_length_string)
    string += "0"* length_string + "1"* length_string
    return string

def parse_args():
    # setup arg parser
    parser = argparse.ArgumentParser()

    # random default value
    default_k_length = random.randint(0, 1000)


    # add arguments
    parser.add_argument("k_length",
                        type=int, help="number of primes numbers to check",
                        default=default_k_length, nargs='?')
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
    print("\n\n")
    print("Total time taken: {}s (Wall time)".format(end - start))
    # print("max number of K length: {}".format(args.k_length))
    # add space in logs
    print("*" * 60)
    print("\n\n")