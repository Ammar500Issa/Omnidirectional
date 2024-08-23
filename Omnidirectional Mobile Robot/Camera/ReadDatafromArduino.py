import serial

ser = serial.Serial('COM16', 115200)

with open('data.csv', 'w') as f:
    while True:
        line = ser.readline().decode().strip()
        if line:
            f.write(line + '\n')
            print(line)