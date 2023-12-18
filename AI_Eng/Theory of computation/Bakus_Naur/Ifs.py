import random
import time

# args
import argparse


def main(args):
    number_of_ifs =  input("Give me the number of If's you want to generate \n")

    if not number_of_ifs:
        lenght_palindrome = random.randint(100)

    number_of_ifs = int(number_of_ifs)
    print("Generatin: {}".format(number_of_ifs) + " If's")

    # Output files:
    states_output = open('Outputf_states.txt', 'w', encoding='utf-8')
    ifs_output = open('Outputf_ifs.txt', 'w', encoding='utf-8')

    rules = {
        'S': 'iCtSA',
        'A': ';eS'
    }
    
    number_of_ifs -= 1
    conditionals = "iCtSA"

    states_output.write("S" + " -> "+ conditionals + "\n")

    while number_of_ifs > 0:
        rule = random.choice(['S', 'A'])

        if rule == 'S':
            # Finding all S's
            S_indexes = [i for i, x in enumerate(conditionals) if x == "S"]
            # Choosing one S
            S_index = random.choice(S_indexes)

            # Replacing S with the rule
            conditionals = conditionals[:S_index] +"(" + rules[rule]+ ")" + conditionals[S_index + 1:]

            number_of_ifs -= 1
        else:
            # Two choices addin ";eS" or just elminationg A
            choice = random.randint(0, 1)
            A_indexes = [i for i, x in enumerate(conditionals) if x == "A"]
            A_index = random.choice(A_indexes)
            if choice:
                # Replacing A with the rule
                conditionals = conditionals[:A_index] + rules[rule] + conditionals[A_index + 1:]
            else:

                # Replcing A with the rule
                conditionals = conditionals[:A_index] + conditionals[A_index + 1:]

        states_output.write(str(rule) + " -> "+ conditionals + "\n")

        
    # Creating the ifs ttxt with xconditionals
        
    action = ""
    number_of_tabs = 0
    for letter in conditionals:
        if letter == "(" or letter == ")" or letter == ";":
            continue

        action += letter

        if action == "iCt":
            action = ""
            ifs_output.write( "\t" * number_of_tabs + "if (Condicional):" +"\n")
            number_of_tabs += 1
        elif action == "e":
            action = ""
            number_of_tabs -= 1
            ifs_output.write( "\t" * number_of_tabs + "else:" +"\n")
            number_of_tabs += 1
        elif action == "S":
            action = ""
            ifs_output.write( "\t" * number_of_tabs + "Statement" +"\n")
        elif action == "A":
            action = ""
            ifs_output.write( "\n")
        

    print(action)
            
        
    # CLosing file
    states_output.close()
    ifs_output.close()






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