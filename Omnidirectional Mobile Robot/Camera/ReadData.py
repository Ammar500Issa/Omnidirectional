with open('C2.txt', 'r') as f:
    lines = f.readlines()
i = 0
n = 30000
g1 = open('X.txt', 'a')
g2 = open('Y.txt', 'a')
g3 = open('Theta.txt', 'a')
while i < n:
    data = lines[i].split()
    g1.write(data[0])
    g1.write('\n')
    # g1.close()
    
    g2.write(data[1])
    g2.write('\n')
    # g2.close()
    
    g3.write(data[2])
    g3.write('\n')
    # g3.close()
    i = i + 1

# u1 = []
# u2 = []
# u3 = []
# u4 = []
# T = []
# while i < 10:
#     u1.append(lines[i][0])
#     u2.append(lines[i][2])
#     u3.append(lines[i][4])
#     u4.append(lines[i][6])
#     if(lines[i][11] == '\n'):
#         T.append(lines[i][8] + lines[i][9] + lines[i][10])
#     else:
#         T.append(lines[i][8] + lines[i][9] + lines[i][10] + lines[i][11])
#     i = i + 1
# i = 0