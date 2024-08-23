import numpy as np
import cv2
import requests
import yaml
import cv2.aruco
from time import time
import serial
import struct
from time import sleep

with open("Calibration.yml", 'r') as stream:
    dictionary = yaml.safe_load(stream)
C = dictionary.get("camera_matrix")
Dist = dictionary.get("dist_coeff")

filename = "C:\\Users\\Ammar Issa\\Downloads\\Project\\" + "CameraXYTheta" + ".mat"
# ser = serial.Serial('COM16', 115200)

cap = cv2.VideoCapture(0)
# cap = cv2.VideoCapture('1.mp4')
i = 0

cap.set(cv2.CAP_PROP_FPS, 30)
cap.set(cv2.CAP_PROP_FRAME_WIDTH, 1024)
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 576)
# ret, img = cap.read()
# filename = "C:\\Users\\Ammar Issa\\Desktop\\Camera\\" + "Potato" + ".jpg"
# cv2.imwrite(filename, img)

g1 = open('X.txt', 'a')
g2 = open('Y.txt', 'a')
g3 = open('Theta.txt', 'a')

lastPos = [-1, -1]
lastTheta = -1
lastVec = [-1, -1]
lastHor = [-1, -1]

t1 = time()
while True:
    i += 1
    ret, img = cap.read()
    dictionary = cv2.aruco.getPredefinedDictionary(cv2.aruco.DICT_4X4_50)
    parameters = cv2.aruco.DetectorParameters()
    detector = cv2.aruco.ArucoDetector(dictionary, parameters)
    markerCorners, markerIds, rejectedCandidates = detector.detectMarkers(img)
    if markerIds is None:
        pos = lastPos
        theta = lastTheta
        vec = lastVec
        hor = lastHor
    else:
        pos = np.mean(markerCorners, axis = 0)
        pos = np.mean(pos, axis = 0)
        pos = np.mean(pos, axis = 0)
        vec = np.mean(markerCorners, axis = 0)
        vec = np.mean(vec, axis = 0)
        vec = np.mean(vec[0:2], axis = 0)
        vecLen = np.sqrt(vec[0] ** 2 + vec[1] ** 2)
        vec = vec - pos
        hor = [vecLen, pos[1]] - pos
        theta = np.dot(vec, hor)/(np.sqrt(vec[0] ** 2 + vec[1] ** 2)*np.sqrt(hor[0] ** 2 + hor[1] ** 2))
        theta = np.arccos(theta)
        lastPos = pos
        lastTheta = theta
        lastVec = vec
        lastHor = hor
    data = bytearray(struct.pack("fff", pos[0]*0.1/71 - 0.7566901408450705, -pos[1]*0.1/60 + 0.3408333333333334, theta))
    with open(filename, 'w') as f:
        f.write(str(pos[0]*0.1/71 - 0.7566901408450705) + "\n" + str(-pos[1]*0.1/60 + 0.3408333333333334) + "\n" + str(theta))
    # sleep(0.05)
    # ser.write(data)
    # print(str(pos[0]*0.1/71 - 0.7566901408450705) + " " + str(-pos[1]*0.1/60 + 0.3408333333333334) + " " + str(theta))
    # print(data)
    # cv2.circle(img, (int(pos[0]), int(pos[1])), 4, (0, 0, 255), -1)
    # cv2.circle(img, (int(vec[0] + pos[0]), int(vec[1] + pos[1])), 4, (0, 0, 255), -1)
    # cv2.line(img, (int(pos[0]), int(pos[1])), ((int(vec[0] + pos[0])), int(vec[1] + pos[1])), (255, 0, 0), 2)
    # cv2.circle(img, (int(hor[0] + pos[0]), int(hor[1] + pos[1])), 4, (0, 0, 255), -1)
    # cv2.line(img, (int(pos[0]), int(pos[1])), ((int(hor[0] + pos[0])), int(hor[1] + pos[1])), (255, 0, 0), 2)
    # cv2.imshow("image", img)
    # filename = "C:\\Users\\Ammar Issa\\Desktop\\Camera\\Moving Ball\\" + str(i) + ".jpg"
    # cv2.imwrite(filename, img)
    # g1.write(str(pos[0]))
    # g1.write('\n')
    # g2.write(str(pos[1]))
    # g2.write('\n')
    # g3.write(str(theta))
    # g3.write('\n')
    # cv2.waitKey(1)
    # if cv2.waitKey(1) == 27:
    #     break
t2 = time()
print(200/(t2 - t1))
cv2.destroyAllWindows()