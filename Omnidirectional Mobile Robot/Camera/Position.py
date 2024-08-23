import numpy as np
import cv2
import requests
import yaml

url = "http://192.168.137.234:8080/shot.jpg"

with open("Calibration.yml", 'r') as stream:
    dictionary = yaml.safe_load(stream)
C = dictionary.get("camera_matrix")
Dist = dictionary.get("dist_coeff")
radius = 0.0485
L = 0.255
M = np.linalg.inv(C)
u = 0
v = 0

while True:
    img_resp = requests.get(url)
    img_arr = np.array(bytearray(img_resp.content), dtype=np.uint8)
    img = cv2.imdecode(img_arr, -1)
    # img = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
    # lower_purple = np.array([130, 50, 50])
    # upper_purple = np.array([170, 255, 255])
    # mask = cv2.inRange(img, lower_purple, upper_purple)
    ########## Contours
    # blur = cv2.GaussianBlur(img, (5, 5), 0)
    # edges = cv2.Canny(blur, 50, 150)
    # gray_image = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    # (thresh, BnW_image) = cv2.threshold(gray_image, 125, 255, cv2.THRESH_BINARY)
    # contours, hierarchy = cv2.findContours(BnW_image, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    # for contour in contours:
    #     area = cv2.contourArea(contour)
    #     if area > 100:
    #         (x, y), radius = cv2.minEnclosingCircle(contour)
    #         center = (int(x), int(y))
    #         radius = int(radius)
    #         cv2.circle(img, center, radius, (0, 255, 0), 2)
    # cv2.imshow("Android_cam", img)
    ########## Hough
    blur = cv2.GaussianBlur(img, (5, 5), 0)
    blur = cv2.normalize(src = blur, dst = None, alpha = 0, beta = 255, norm_type = cv2.NORM_MINMAX, dtype = cv2.CV_8UC1)
    gray_image = cv2.cvtColor(blur, cv2.COLOR_BGR2GRAY)
    circles = cv2.HoughCircles(gray_image, cv2.HOUGH_GRADIENT, 1, 20, param1 = 50, param2 = 30, minRadius = 40, maxRadius = 120)
    if circles is not None:
        circles = np.round(circles[0, :]).astype("int")
        for (x, y, r) in circles:
            cv2.circle(img, (x, y), r, (0, 255, 0), 2)
            u = x
            v = y
    cv2.imshow("Android_cam", img)
    s = L
    pos = np.array([0, 0, 0])
    pos = M.dot(np.array([u, v, 1]))
    pos = pos*s
    print(pos)
    cv2.waitKey(10)
    if cv2.waitKey(1) == 27:
        break
cv2.destroyAllWindows()