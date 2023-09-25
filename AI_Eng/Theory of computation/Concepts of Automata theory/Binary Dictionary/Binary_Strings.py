import random
import time
# graph libs
import pandas as pd
import matplotlib.pyplot as plt
# args
import argparse
import math

def main(args):
    
    while True:

        k_length = input("Pls give me the 'k' for the alphabet or just press 'enter': ")
        if k_length == '':
            k_length = random.randint(0, 1000)
        else:
            k_length = int(k_length)
        
        print(f"Your k is: {k_length}")


        # OUTPUT FILES
        output = open('Outputf_BinaryStrings.txt', 'w', encoding='utf-8')
        


        # BASIC INFO
        output.write("{0, 1}")
        output.write(f"^{k_length} = ")
        output.write("{\u03B5, ")


        # LOGIC
        number_zeros_left = 0

        for i in range(1, k_length + 1):
            number_zeros_left += 1
            bits = 2**i
            for j in range(bits):
                if i == k_length and j == bits - 1:
                    output.write(bin(j)[2::].zfill(number_zeros_left))
                else:
                    output.write(bin(j)[2::].zfill(number_zeros_left)+ ', ')
                
        output.write('}')

        bits = 2**k_length
        # CLOSE FILES
        output.close()

        # """
        # k =3

        # output :  {e, 0, 1, 00, 01, 10, 11, 000, 001, 010, 011, 100, 101, 110, 111}   

        # T: O(2^k + 2^k-1 + 2^k-2 + ... + 2^1 + 2^0) = O(2^k) 
        # O: O(1)   only output.txt

        # """ 


        # # PLOT
        # '''
        # Data frame:
        # # k = 3
        # # bits = 2**3
        # bits = 8
        # chain        number_of_1s
        # 1              0         -> epsilon   
        # 2              0         -> '000'
        # 3              1         -> '001'
        # 4              1         -> '010'
        # 5              2         -> '011'
        # 6              1         -> '100'
        # 7              2         -> '101'
        # 8              2         -> '110'
        # 9              3         -> '111'

        # '''
        # OUTPUT FILES
        df = open('Binary_Strings.txt', 'w')
        blog = open('Binary_Strings_Log.txt', 'w')

        # BASIC INFO
        df.write('chain' + ',' + 'number_of_1s\n')
        df.write('1' + ','+ '0 \n')

        blog.write('chain' + ',' + 'number_of_1s_baselog10\n')



        for i in range(2, bits + 2):
            df.write(str(i) + ',' + str(hammingWeight(i - 2)) + '\n')
            if hammingWeight(i - 2) != 0:
                blog.write(str(i) + ',' + str(round(math.log10(hammingWeight(i - 2)), 4)) + '\n')

        # CLOSE FILES
        df.close()
        blog.close()

        # SAVE DATA FRAME
        df = pd.read_csv('Binary_Strings.txt')

        # PLotting
        plt.plot(df['chain'], df['number_of_1s'], 'bo')
        plt.title('Binary Strings')
        plt.xlabel('Chain')
        plt.ylabel('Number of 1s')
        plt.show()

        # SAVE DATA FRAME
        blog = pd.read_csv('Binary_Strings_Log.txt')

        # PLotting
        plt.plot(blog['chain'], blog['number_of_1s_baselog10'], 'bo')
        plt.title('Binary Strings base Log10')
        plt.xlabel('Chain')
        plt.ylabel('Number of 1s')
        plt.show()

        if input("Do you want to continue? (y/n): ") == 'n':
            break
        print("-"*60)


def hammingWeight(n):
    """
    :type n: int
    :rtype: int
    """
    mask = 1
    count = 0
    while n != 0:
        if (mask & n == 1):
            count = count + 1
        n = n>>1

    return count




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