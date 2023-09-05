dictionary = {}
translation = {}
mistakes = {}

# Function to find the length of the
# longest LCS
def longestCommonSubstring(s, t, n, m):
	# Create DP table
	dp = [[0 for i in range(m + 1)] for j in range(2)]
	res = 0
	
	for i in range(1,n + 1):
		for j in range(1,m + 1):
			if(s[i - 1] == t[j - 1]):
				dp[i % 2][j] = dp[(i - 1) % 2][j - 1] + 1
				if(dp[i % 2][j] > res):
					res = dp[i % 2][j]
			else:
				dp[i % 2][j] = 0
	return res


def longestCommonSubsequence(s: str, t: str) -> int:
    prev=[0 for i in range(len(t)+1)] 
    curr=[0 for i in range(len(t)+1)]

    for i in range(1,len(s)+1):
        for j in range(1,len(t)+1):

            if s[i-1]==t[j-1]:
                curr[j]=1+prev[j-1]
            else:
                curr[j]=max(prev[j],curr[j-1])
        prev=curr[:]

    return prev[len(t)]

def nearestWord(word):
    nearest = ""
    punctuation = -1
    # for key in dictionary.keys():
    #     if longestCommonSubstring(word, key, len(word), len(key)) > punctuation:
    #         nearest = key
    #         punctuation = longestCommonSubstring(word, key, len(word), len(key))
        
    # for key in translation.keys():
    #     if longestCommonSubstring(word, key, len(word), len(key)) > punctuation:
    #         nearest = key
    #         punctuation = longestCommonSubstring(word, key, len(word), len(key))
    for key in dictionary.keys():
         if longestCommonSubsequence(word, key) > punctuation:
            nearest = key
            punctuation = longestCommonSubsequence(word, key)
    
    for key in translation.keys():
        if longestCommonSubsequence(word, key) > punctuation:
            nearest = key
            punctuation = longestCommonSubsequence(word, key)

    
    return nearest
    

print("\n\n\n")
print("=============================================")
print("== Welcome to the English-Spanish translator ==")
print("=============================================")
print("\n\n\n")



while True:
    print("\n\n\n")
    word = input("Give me a word:  ")
    if word in dictionary:
        print(f"La traduccion es: {dictionary[word]}")
    elif word in translation:
        print(f"La traduccion es: {translation[word]}")
    elif word in mistakes:
        print(f"Creo que te has equivocado, talvez quisiste decir {mistakes[word]}")
        if mistakes[word] in dictionary:
            print(f"Y su traduccion es: {dictionary[mistakes[word]]}")
        else:
            print(f"Y su traduccion es: {translation[mistakes[word]]}")
    else:
        print("La palabra no se encontro, que deseas hacer?")
        error = input("1.- Marcar como error \n2.- Agregar palabra \n")
        if error == "1":
            mistakes[word] = nearestWord(word)
        else: 
            meaning = input("Dame su traduccion:  ")
            dictionary[word] = meaning
            translation[meaning] = word