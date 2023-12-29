import random
import time

# args
import argparse


def main(args):
    lenght_palindrome =  input("Give me the length if the palindrome to generate, or press enter to generate randomly \n")

    if not lenght_palindrome:
        lenght_palindrome = random.randint(1,10000)

    lenght_palindrome = int(lenght_palindrome)
    print("Generating palindrome of length: {}".format(lenght_palindrome))

    # Output files:
    output = open('Outputf.txt', 'w', encoding='utf-8')

    rules = {
        5: '1P1',
        4: '0P0',
        2: '0',
        3: '1',
    }

    palindrome = ""

    is_odd = lenght_palindrome % 2 == 1 #NONE

    index = 0
    while obtain_length(palindrome) != lenght_palindrome:    #11p11

        # Nones
        if obtain_length(palindrome) > lenght_palindrome:
            # epsilon
            palindrome = palindrome[:index] + palindrome[index + 1:]
            output.write(f"1 -> {palindrome}\n")
        else:
            rule = random.randint(4,5)

            palindrome = palindrome[:index] + rules[rule] + palindrome[index + 1:]
            output.write(f"{str(rule)} -> {palindrome}\n")

        index = obtain_length(palindrome) // 2
        

    
    # ODDs
    if is_odd:
        rule = random.randint(2,3)

        palindrome = palindrome[:index] + str(rules[rule])+ palindrome[index + 1:]
        output.write(f"{str(rule)} -> {palindrome}\n")


    # CLosing file
    output.close()


def obtain_length(string):
    length = 0
    for char in string:
        length += 1

    return length



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