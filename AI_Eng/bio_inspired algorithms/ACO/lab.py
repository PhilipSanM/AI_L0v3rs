p1 = [3,1,4,2]
p2 = [4,3,2,1]

d = [[]]


p1_sol = function(d,f,p1)
p2_sol = function(d,f,p2)

def function(d, f, p):
    sol = 0
    for i in range(len(p)):
        for j in range(len(p)):
            sol += d[i][j] * f[p[i], p[j]]

    return sol