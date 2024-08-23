# This code is similar to AruCo.py, but uses many AruCo markers instead of one
import numpy as np
import cv2
import requests
import yaml
import cv2.aruco
from time import time, sleep
import imutils

url = "http://192.168.24.32:8080/shot.jpg"

with open("Calibration.yml", 'r') as stream:
    dictionary = yaml.safe_load(stream)
C = dictionary.get("camera_matrix")
Dist = dictionary.get("dist_coeff")

Yar = 0.1
M = np.linalg.inv(C)
u = 0
v = 0
ConvY = [0.6, 0.4, 0.2, 0, -0.2, -0.4, -0.6]
ConvX = 0.5

# img_resp = requests.get(url)
# img_arr = np.array(bytearray(img_resp.content), dtype=np.uint8)
img = cv2.imread("ArUco.jpg")
img = imutils.resize(img, width = 720, height = 480)
dictionary = cv2.aruco.getPredefinedDictionary(cv2.aruco.DICT_4X4_50)
parameters = cv2.aruco.DetectorParameters()
detector = cv2.aruco.ArucoDetector(dictionary, parameters)
markerCorners, markerIds, rejectedCandidates = detector.detectMarkers(img)
cv2.waitKey(1)
j = -1
pos = [[-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1]] # There are 7 markers set in the environment, with known positions of each of them (ConvX, ConvY)
vec = [[-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1]]
hor = [[-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1]]
while True:
    for i in range(0, 7):
        if i in markerIds:
            j = j + 1
            p = np.mean(markerCorners[j], axis = 0)
            pos[i] = np.mean(p, axis = 0)
            Xt = np.array([0, Yar, 0])
            Xons = M.dot(np.array([pos[i][0], pos[i][1], 1]))
            s = Yar/Xons[1]
            Xt[2] = s
            Xt[0] = Xons[0]*s
            X = [-Xt[2] - ConvX, Xt[0] + ConvY[i], Xt[1]]
            v = np.mean(markerCorners[j], axis = 0)
            vec[i] = np.mean(v[0:2], axis = 0)
            vecLen = np.sqrt(vec[i][0] ** 2 + vec[i][1] ** 2)
            vec[i] = vec[i] - pos[i]
            hor[i] = [vecLen, pos[i][1]] - pos[i]
            theta = np.dot(vec[i], hor[i])/(np.sqrt(vec[i][0] ** 2 + vec[i][1] ** 2)*np.sqrt(hor[i][0] ** 2 + hor[i][1] ** 2))
            theta = np.arccos(theta)
            cv2.circle(img, (int(pos[i][0]), int(pos[i][1])), 4, (0, 0, 255), -1)
            marker_size = 0.1
            marker_points = np.array([[-marker_size / 2, marker_size / 2, 0],
                                [marker_size / 2, marker_size / 2, 0],
                                [marker_size / 2, -marker_size / 2, 0],
                                [-marker_size / 2, -marker_size / 2, 0]], dtype = np.float32)
            trash = [[], [], [], [], [], [], []]
            rvecs = [[], [], [], [], [], [], []]
            tvecs = [[], [], [], [], [], [], []]
            for c in markerCorners[j]:
                amm, R, t = cv2.solvePnP(marker_points, markerCorners[j][0], np.float32(C), np.float32(Dist), False, cv2.SOLVEPNP_IPPE_SQUARE)
                rvecs.append(R)
                tvecs.append(t)
                trash.append(amm)
            print([tvecs[i][0][2] - ConvX, -tvecs[i][0][0] + ConvY[i], -tvecs[i][0][1]])
            print(rvecs[i][0][0] - np.pi)

            # cv2.circle(img, (int(vec[0] + pos[0]), int(vec[1] + pos[1])), 4, (0, 0, 255), -1)
            # cv2.line(img, (int(pos[i][0]), int(pos[i][1])), ((int(vec[i][0] + pos[i][0])), int(vec[i][1] + pos[i][1])), (255, 0, 0), 2)
            # cv2.circle(img, (int(hor[0] + pos[0]), int(hor[1] + pos[1])), 4, (0, 0, 255), -1)
            # cv2.line(img, (int(pos[i][0]), int(pos[i][1])), ((int(hor[i][0] + pos[i][0])), int(hor[i][1] + pos[i][1])), (255, 0, 0), 2)
            cv2.imshow("image", img)
            cv2.waitKey(1)
    # sleep(100)
    # cv2.imshow("Android_cam", img)
    # print(pos, theta)
    # filename = "C:\\Users\\Ammar Issa\\Desktop\\Camera\\" + str(i) + ".jpg"
    # # cv2.imwrite(filename, img)
    # cv2.destroyAllWindows()
