import random
import time

# args
import argparse


import turtle

def main(args):
    # Output files:
    output = open('Outputf_states.txt', 'w', encoding='utf-8')


    # Logic:
    
    
    string =  input("Input a String in the language: {0^n 1^n | n >= 1} or just press enter to generate a random string \n")

    max_length_string = 10
    # max_length_string = 10000
    if len(string) <= 16:
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
        gabriel.left(270)

        gabriel.setpos(25, 200)

    if not string:
        string = generate_random_string(max_length_string)
        print("Random string generated: {}".format(string))

    string += '\n'

    current_state = 'q0'    
    move = 0

    output.write(f"{current_state} -> {string}\n")

    while move < len(string) and current_state != 'q4' and current_state != 'N/A':
        if len(string) <= 16:
            # time.sleep(10)
            draw_automaton(current_state, string, move, simon, gabriel)
            time.sleep(1)
        
        if current_state == 'q0' and string[move] == '0':
            current_state = 'q1'
            # changing 0 to X
            string = string[:move] + 'X' + string[move+1:]
            move += 1

        elif current_state == 'q0' and string[move] == 'Y':
            current_state = 'q3'
            move += 1
        elif current_state == 'q1' and string[move] == '0':
            current_state = 'q1'
            
            move += 1

        elif current_state == 'q1' and string[move] == '1':
            current_state = 'q2'
            # changing 1 to Y
            string = string[:move] + 'Y' + string[move+1:]
            move -= 1

        elif current_state == 'q1' and string[move] == 'Y':
            current_state = 'q1'
            move += 1

        elif current_state == 'q2' and string[move] == '0':
            current_state = 'q2'
            move -= 1
        
        elif current_state == 'q2' and string[move] == 'X':
            current_state = 'q0'
            move += 1

        elif current_state == 'q2' and string[move] == 'Y':
            current_state = 'q2'
            move -= 1

        elif current_state == 'q3' and string[move] == 'Y':
            current_state = 'q3'
            move += 1
        
        elif current_state == 'q3' and string[move] == '\n':
            current_state = 'q4'
            move += 1
        else:
            current_state = 'N/A'
        
        output.write(f"{current_state} -> {string}\n")

    if len(string) <= 16:
        # time.sleep(10)
        draw_automaton(current_state, string, move, simon, gabriel)
        time.sleep(1)
    
    if current_state == 'q4':
        print("String is ACCEPTED by the Turing Machine in the language: {0^n 1^n | n >= 1}")
        if len(string) <= 16:
            simon.penup()
            simon.setpos(-350, 350)
            simon.write("String is ACCEPTED by the Turing Machine in the language: {0^n 1^n | n >= 1}", font=('Arial', 15, 'normal'))

    else:
        print("String is NOT accepted by the Turing Machine in the language: {0^n 1^n | n >= 1}")
        if len(string) <= 16:
            simon.penup()
            simon.setpos(-350, 350)
            simon.write("String is NOT accepted by the Turing Machine in the language: {0^n 1^n | n >= 1}", font=('Arial', 15, 'normal'))
        
    

    window.exitonclick()
    # CLosing file
    output.close()




def draw_automaton(curr_state, string, move, simon, gabriel):
    clearString(simon,string)

    clearState(simon)

    # Draw string:
    simon.penup()
    simon.setpos(-100, 100)
    simon.pendown()
    simon.write('String:    ' + string , font=('Arial', 22, 'normal'))

    #Move gabriel
    gabriel.penup()
    curr_position = gabriel.position()
    gabriel.setpos(25 + move *17 , curr_position[1])

    # Draw state:
    simon.penup()
    simon.setpos(-100, -100)
    simon.pendown()
    simon.write("Current State: " + curr_state, font=('Arial', 22, 'normal'))

def clearState(simon):
    simon.penup()
    simon.setpos(-100, -100)
    simon.fillcolor('#10F7DE')

    simon.begin_fill()
    for _ in range(2):
        simon.forward(500)
        simon.left(90)
        simon.forward(60)
        simon.left(90)
    
    simon.end_fill()



def clearString(simon,string):
    simon.penup()
    simon.setpos(-100, 100)
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