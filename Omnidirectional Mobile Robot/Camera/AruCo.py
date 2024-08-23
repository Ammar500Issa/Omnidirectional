import numpy as np
import cv2
import requests
import yaml
import cv2.aruco
from time import time

url = "http://192.168.137.234:8080/shot.jpg"

with open("Calibration.yml", 'r') as stream:
    dictionary = yaml.safe_load(stream)
C = dictionary.get("camera_matrix")
Dist = dictionary.get("dist_coeff")

i = 98
n = 320

t1 = time()
while i < n:
    i = i + 1
    img_resp = requests.get(url)
    img_arr = np.array(bytearray(img_resp.content), dtype=np.uint8)
    img = cv2.imdecode(img_arr, -1)
    # img = cv2.imread("C:\\Users\\Ammar Issa\\Desktop\\Camera\\New folder\\New folder\\" + str(i) + ".jpg")
    cv2.imshow("Android_cam", img)
    dictionary = cv2.aruco.getPredefinedDictionary(cv2.aruco.DICT_4X4_50)
    parameters = cv2.aruco.DetectorParameters()
    detector = cv2.aruco.ArucoDetector(dictionary, parameters)
    markerCorners, markerIds, rejectedCandidates = detector.detectMarkers(img)
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
    cv2.circle(img, (int(pos[0]), int(pos[1])), 4, (0, 0, 255), -1)
    # cv2.circle(img, (int(vec[0] + pos[0]), int(vec[1] + pos[1])), 4, (0, 0, 255), -1)
    cv2.line(img, (int(pos[0]), int(pos[1])), ((int(vec[0] + pos[0])), int(vec[1] + pos[1])), (255, 0, 0), 2)
    # cv2.circle(img, (int(hor[0] + pos[0]), int(hor[1] + pos[1])), 4, (0, 0, 255), -1)
    cv2.line(img, (int(pos[0]), int(pos[1])), ((int(hor[0] + pos[0])), int(hor[1] + pos[1])), (255, 0, 0), 2)
    cv2.imshow("Android_cam", img)
    print(pos, theta)
    filename = "C:\\Users\\Ammar Issa\\Desktop\\Camera\\" + str(i) + ".jpg"
    # cv2.imwrite(filename, img)
    cv2.waitKey(1)
    if cv2.waitKey(1) == 27:
        break
t2 = time()
print(t2 - t1)
cv2.destroyAllWindows()