from time import sleep

filename = "C:\\Users\\Ammar Issa\\Downloads\\Project\\" + "CameraXYTheta" + ".txt"
i = 0
while True:
    i = i + 1
    with open(filename, 'w') as f:
        f.write(str(i))
    sleep(0.05)