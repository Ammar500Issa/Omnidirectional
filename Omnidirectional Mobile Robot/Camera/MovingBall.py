# This code is used to detect the position of the moving ball towards the robot, in respect to its position
import numpy as np
import cv2
import requests
import yaml
import imutils

url = "http://192.168.137.178:8080/shot.jpg"

with open("Calibration.yml", 'r') as stream:
    dictionary = yaml.safe_load(stream)
C = dictionary.get("camera_matrix")
Dist = dictionary.get("dist_coeff")
radius = 0.0485
L = 0.255
M = np.linalg.inv(C)
u = 0 # (u, v) will be assigned the indeces of the center of the ball
v = 0
# cap = cv2.VideoCapture('Ball.mp4')
i = 0
last_ballcorner = np.array([[1, 1], [1, 2], [2, 1], [2, 2]], dtype = np.float32)
lastu = 0
lastv = 0
lastr = 0
lasts = 1
R = 0.3 # The pre-known value of the ball's radius

while True:
    i = i + 1
    # ret, img = cap.read()
    img_resp = requests.get(url)
    img_arr = np.array(bytearray(img_resp.content), dtype=np.uint8)
    img = cv2.imdecode(img_arr, -1)
    img = imutils.resize(img, width = 720, height = 480)
    hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
    # Define range of purple color in HSV
    lower_purple = np.array([30, 50, 50])
    upper_purple = np.array([50, 255, 255])
    # img = cv2.inRange(hsv, lower_purple, upper_purple) # To filter all other noise circles in the environment
    if(i >= 0):
        # blur = cv2.GaussianBlur(img, (3, 3), 0)
        blur = cv2.normalize(src = img, dst = None, alpha = 0, beta = 255, norm_type = cv2.NORM_MINMAX, dtype = cv2.CV_8UC1)
        rgb = cv2.cvtColor(blur, cv2.COLOR_HSV2RGB_FULL)
        gray_image = cv2.cvtColor(rgb, cv2.COLOR_RGB2GRAY)
        # Getting the circles using Hough Transformation algorithm
        circles = cv2.HoughCircles(gray_image, cv2.HOUGH_GRADIENT, 1, 20, param1 = 50, param2 = 30, minRadius = 10, maxRadius = 50)
        if circles is not None:
            circles = np.round(circles[0, :]).astype("int")
            for (x, y, r) in circles:
                cv2.circle(img, (x, y), r, (0, 255, 0), 2)
                u = x
                v = y
                radius = r
                lastu = u
                lastv = v
                lastr = radius
                s = R / r # Standardization of the real length comparing to pixels
                lasts = s
                # ball_corner = np.array([[x - r, y - r], [x + r, y - r], [x - r, y + r], [x + r, y + r]], dtype = np.float32)
        else:
            # ball_corner = last_ballcorner
            u = lastu
            v = lastv
            s = lasts
            radius = lastr
        cv2.imshow("Android_cam", img)
        pos = np.array([0, 0, 0])
        pos = M.dot(np.array([u, v, 1]))
        X = (u - 360) * s # Reset the coordinate center
        sx = X / pos[0]
        Y = (v - 240) * s
        sy = Y / pos[0]
        pos = [X, Y, (sx + sy)/2] # Using the mean of the standardization of the rows and clms
        print(pos)
        pos = np.array([0, 0, 0])
        pos = M.dot(np.array([u, v, 1]))
        cv2.waitKey(1)
        # filename = "C:\\Users\\Ammar Issa\\Desktop\\Camera\\Moving Ball\\" + str(i - 415) + ".jpg"
        # cv2.imwrite(filename, img)
        if cv2.waitKey(1) == 27:
            break
cv2.destroyAllWindows()
