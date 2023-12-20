import random
import time

# args
import argparse


def main(args):
    # Output files:
    output = open('Outputf_states.txt', 'w', encoding='utf-8')


    # Logic:

    
    string =  input("Input a String in the language: {0^n 1^n | n >= 1} or just press enter to generate a random string \n")

    max_length_string = 10
    # max_length_string = 10000

    if not string:
        string = generate_random_string(max_length_string)
        print("Random string generated: {}".format(string))

    string += '\n'

    current_state = 'q0'    
    move = 0

    output.write(f"{current_state} -> {string}\n")

    while move < len(string) and current_state != 'q4' and current_state != 'N/A':
        
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

    
    if current_state == 'q4':
        print("String is ACCEPTED by the Turing Machine in the language: {0^n 1^n | n >= 1}")
    else:
        print("String is NOT accepted by the Turing Machine in the language: {0^n 1^n | n >= 1}")
        
        
    

    # CLosing file
    output.close()



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