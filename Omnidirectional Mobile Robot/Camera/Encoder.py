with open('Encoder.txt', 'r') as f:
    lines = f.readlines()
i = 0
n = 1790
g1 = open('X.txt', 'a')
g2 = open('Y.txt', 'a')
g3 = open('Theta.txt', 'a')
g4 = open('Vx.txt', 'a')
g5 = open('Vy.txt', 'a')
g6 = open('w.txt', 'a')
g7 = open('u1.txt', 'a')
g8 = open('u2.txt', 'a')
g9 = open('u3.txt', 'a')
g10 = open('u4.txt', 'a')
while i < n:
    data = lines[i].split()
    g1.write(data[0][:-1])
    g1.write('\n')
    # g1.close()
    
    g2.write(data[1][:-1])
    g2.write('\n')
    # g2.close()
    
    g3.write(data[2][:-1])
    g3.write('\n')
    # g3.close()
    
    g4.write(data[3][:-1])
    g4.write('\n')
    # g4.close()
    
    g5.write(data[4][:-1])
    g5.write('\n')
    # g5.close()

    g6.write(data[5][:-1])
    g6.write('\n')
    # g2.close()
    
    g7.write(data[6][:-1])
    g7.write('\n')
    # g3.close()
    
    g8.write(data[7][:-1])
    g8.write('\n')
    # g4.close()
    
    g9.write(data[8][:-1])
    g9.write('\n')
    # g5.close()

    g10.write(data[9][:-1])
    g10.write('\n')
    # g5.close()
    i = i + 1
