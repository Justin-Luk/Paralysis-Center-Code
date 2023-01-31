## Project: Motor Control V2
## Luk JH, Krenn, MJ
## Date: 1/26/23
import time
import cv2
import pandas as pd
import cvzone
from cvzone.HandTrackingModule import HandDetector
import csv
import math
import cmath
import matplotlib.pyplot as plt
from datetime import datetime
import dropbox
import os

# Init
cap = cv2.VideoCapture(0)
#cap = cv2.VideoCapture("C:/Users/user/Downloads/test/2.mp4")

detector = HandDetector(detectionCon=0.9, maxHands=1)

i = 1
t=0
startTime = time.time()
#dbx = dropbox.Dropbox("sl.BXoWHjL9YiBxe1JEBwDQFhsOKP2WuYlK2V6UHJzOaMPkXO4S4y5_MDrYKPoQAlzrHdTBJXBIUADzfx9G5rdn305LZDkhrTRtwoK4pUQzvku70nUPS7W_a8vbwPbmXN4wRjtGFhk")

max_angle = 0
min_angle = 0
max_counter = 0
min_counter = 0
consecutive_threshold = 1

fig, axs = plt.subplots(5, 1)
axs[0].set(title="D1", xlabel="Frame", ylabel="Angle")
axs[1].set(title="D2", xlabel="Frame", ylabel="Angle")
axs[2].set(title="D3", xlabel="Frame", ylabel="Angle")
axs[3].set(title="D4", xlabel="Frame", ylabel="Angle")
axs[4].set(title="D5", xlabel="Frame", ylabel="Angle")

D1 = []
x_coordinates = []
y_coordinates = []
z_coordinates = []
D5 = []
frame_counter = 0

while True:
    success, img = cap.read()
    img = cv2.flip(img, 1)
    img_rotate_90_clockwise = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
    img_rotate_90_clockwise = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
    # img = cv2.putText(img, f'Time: {time.ctime()}', (1000, 675), cv2.FONT_HERSHEY_SIMPLEX, 0.5,(250, 250, 250), 1, cv2.LINE_AA)

    hands, img = detector.findHands(img, flipType=False)

    key = cv2.waitKey(1)
    # Point drawing
    if hands:
        hand1 = hands[0]
        lmList1 = hand1["lmList"]
        x0, y0, z0 = lmList1[0]
        x1, y1, z1 = lmList1[1]
        x2, y2, z2 = lmList1[2]
        x3, y3, z3 = lmList1[3]
        x4, y4, z4 = lmList1[4]
        x5, y5, z5 = lmList1[5]
        x6, y6, z6 = lmList1[6]
        x7, y7, z7 = lmList1[7]
        x8, y8, z8 = lmList1[8]
        x9, y9, z9 = lmList1[9]
        x10, y10, z10 = lmList1[10]
        x11, y11, z11 = lmList1[11]
        x12, y12, z12 = lmList1[12]
        x13, y13, z13 = lmList1[13]
        x14, y14, z14 = lmList1[14]
        x15, y15, z15 = lmList1[15]
        x16, y16, z16 = lmList1[16]
        x17, y17, z17 = lmList1[17]
        x18, y18, z18 = lmList1[18]
        x19, y19, z19 = lmList1[19]
        x20, y20, z20 = lmList1[20]

        # Define vectors
        v1 = [x4 - x0, y4 - y0, z4 - z0]
        v2 = [x8 - x0, y8 - y0, z8 - z0]

        D1D1 = [x5 -x0, y5 - y0, z5 - z0]
        D1D2 = [x3 -x0, y3 - y0, z3 - z0]

        D1E1 = [x5 -x1, y5 - y1, z5 - z1]
        D1E2 = [x3 -x1, y3 - y1, z3 - z1]

        D2A1 = [x0 -x5, y0 - y5, z0 - z5]
        D2A2 = [x6 -x5, y6 - y5, z6 - z5]

        D2B1 = [x5 -x6, y5 - y6, z5 - z6]
        D2B2 = [x8 -x6, y8 - y6, z8 - z6]

        D2C1 = [x1 -x5, y1 - y5, z1 - z5]
        D2C2 = [x6 -x5, y6 - y5, z6 - z5]

        D3A1 = [x0 - x9, y0 - y9, z0 - z9]
        D3A2 = [x10 - x9, y10 - y9, z10 - z9]

        D3B1 = [x9 - x10, y9 - y10, z9 - z10]
        D3B2 = [x12 - x10, y12 - y10, z12 - z10]

        D3C1 = [x1 - x9, y1 - y9, z1 - z9]
        D3C2 = [x10 - x9, y10 - y9, z10 - z9]

        D4A1 = [x0 - x13, y0 - y13, z0 - z13]
        D4A2 = [x14 - x13, y14 - y13, z14 - z13]

        D4B1 = [x13 - x14, y13 - y14, z13 - z14]
        D4B2 = [x16 - x14, y16 - y14, z16 - z14]

        D4C1 = [x1 - x13, y1 - y13, z1 - z13]
        D4C2 = [x14 - x13, y14 - y13, z14 - z13]

        D5A1 = [x0 - x17, y0 - y17, z0 - z17]
        D5A2 = [x18 - x17, y18 - y17, z18 - z17]

        D5B1 = [x17 - x18, y17 - y18, z17 - z18]
        D5B2 = [x20 - x18, y20 - y18, z20 - z18]

        D5C1 = [x1 - x17, y1 - y17, z1 - z17]
        D5C2 = [x18 - x17, y18 - y17, z18 - z17]

        # Calculate angle
        dot_product = sum([v1[i] * v2[i] for i in range(3)])
        magnitude_v1 = math.sqrt(sum([i ** 2 for i in v1]))
        magnitude_v2 = math.sqrt(sum([i ** 2 for i in v2]))
        anglev1 = math.acos(dot_product / (magnitude_v1 * magnitude_v2)) #Radians

        # For D1D1 and D1D2
        dot_product = sum([D1D1[i] * D1D2[i] for i in range(3)])
        magnitude_D1D1 = math.sqrt(sum([i ** 2 for i in D1D1]))
        magnitude_D1D2 = math.sqrt(sum([i ** 2 for i in D1D2]))
        angleD1D = math.acos(dot_product / (magnitude_D1D1 * magnitude_D1D2)) #Radians

        # For D1E1 and D1E2
        dot_product = sum([D1E1[i] * D1E2[i] for i in range(3)])
        magnitude_D1E1 = math.sqrt(sum([i ** 2 for i in D1E1]))
        magnitude_D1E2 = math.sqrt(sum([i ** 2 for i in D1E2]))
        angleD1E = math.acos(dot_product / (magnitude_D1E1 * magnitude_D1E2)) #Radians

        # For D2A1 and D2A2
        dot_product = sum([D2A1[i] * D2A2[i] for i in range(3)])
        magnitude_D2A1 = math.sqrt(sum([i ** 2 for i in D2A1]))
        magnitude_D2A2 = math.sqrt(sum([i ** 2 for i in D2A2]))
        angleD2A = math.acos(dot_product / (magnitude_D2A1 * magnitude_D2A2))

        # For D2B1 and D2B2
        dot_product = sum([D2B1[i] * D2B2[i] for i in range(3)])
        magnitude_D2B1 = math.sqrt(sum([i ** 2 for i in D2B1]))
        magnitude_D2B2 = math.sqrt(sum([i ** 2 for i in D2B2]))
        angleD2B = math.acos(dot_product / (magnitude_D2B1 * magnitude_D2B2))

        # For D2C1 and D2C2
        dot_product = sum([D2C1[i] * D2C2[i] for i in range(3)])
        magnitude_D2C1 = math.sqrt(sum([i ** 2 for i in D2C1]))
        magnitude_D2C2 = math.sqrt(sum([i ** 2 for i in D2C2]))
        angleD2C = math.acos(dot_product / (magnitude_D2C1 * magnitude_D2C2))

        # For D3A1 and D3A2
        dot_product = sum([D3A1[i] * D3A2[i] for i in range(3)])
        magnitude_D3A1 = math.sqrt(sum([i ** 2 for i in D3A1]))
        magnitude_D3A2 = math.sqrt(sum([i ** 2 for i in D3A2]))
        angleD3A = math.acos(dot_product / (magnitude_D3A1 * magnitude_D3A2))

        # For D3B1 and D3B2
        dot_product = sum([D3B1[i] * D3B2[i] for i in range(3)])
        magnitude_D3B1 = math.sqrt(sum([i ** 2 for i in D3B1]))
        magnitude_D3B2 = math.sqrt(sum([i ** 2 for i in D3B2]))
        angleD3B = math.acos(dot_product / (magnitude_D3B1 * magnitude_D3B2))

        # For D3C1 and D3C2
        dot_product = sum([D3C1[i] * D3C2[i] for i in range(3)])
        magnitude_D3C1 = math.sqrt(sum([i ** 2 for i in D3C1]))
        magnitude_D3C2 = math.sqrt(sum([i ** 2 for i in D3C2]))
        angleD3C = math.acos(dot_product / (magnitude_D3C1 * magnitude_D3C2))

        # For D4A1 and D4A2
        dot_product = sum([D4A1[i] * D4A2[i] for i in range(3)])
        magnitude_D4A1 = math.sqrt(sum([i ** 2 for i in D4A1]))
        magnitude_D4A2 = math.sqrt(sum([i ** 2 for i in D4A2]))
        angleD4A = math.acos(dot_product / (magnitude_D4A1 * magnitude_D4A2))

        # For D4B1 and D4B2
        dot_product = sum([D4B1[i] * D4B2[i] for i in range(3)])
        magnitude_D4B1 = math.sqrt(sum([i ** 2 for i in D4B1]))
        magnitude_D4B2 = math.sqrt(sum([i ** 2 for i in D4B2]))
        angleD4B = math.acos(dot_product / (magnitude_D4B1 * magnitude_D4B2))

        # For D4C1 and D4C2
        dot_product = sum([D4C1[i] * D4C2[i] for i in range(3)])
        magnitude_D4C1 = math.sqrt(sum([i ** 2 for i in D4C1]))
        magnitude_D4C2 = math.sqrt(sum([i ** 2 for i in D4C2]))
        angleD4C = math.acos(dot_product / (magnitude_D4C1 * magnitude_D4C2))

        # For D5A1 and D5A2
        dot_product = sum([D5A1[i] * D5A2[i] for i in range(3)])
        magnitude_D5A1 = math.sqrt(sum([i ** 2 for i in D5A1]))
        magnitude_D5A2 = math.sqrt(sum([i ** 2 for i in D5A2]))
        angleD5A = math.acos(dot_product / (magnitude_D5A1 * magnitude_D5A2))

        # For D5B1 and D5B2
        dot_product = sum([D5B1[i] * D5B2[i] for i in range(3)])
        magnitude_D5B1 = math.sqrt(sum([i ** 2 for i in D5B1]))
        magnitude_D5B2 = math.sqrt(sum([i ** 2 for i in D5B2]))
        angleD5B = math.acos(dot_product / (magnitude_D5B1 * magnitude_D5B2))

        # For D5C1 and D5C2
        dot_product = sum([D5C1[i] * D5C2[i] for i in range(3)])
        magnitude_D5C1 = math.sqrt(sum([i ** 2 for i in D5C1]))
        magnitude_D5C2 = math.sqrt(sum([i ** 2 for i in D5C2]))
        angleD5C = math.acos(dot_product / (magnitude_D5C1 * magnitude_D5C2))

        comp_D1 = angleD1D + angleD1E
        comp_D2 = angleD2A + angleD2B
        comp_D3 = angleD3A + angleD3B
        comp_D4 = angleD4A + angleD4B
        comp_D5 = angleD5A + angleD5B
        angles = [comp_D1,comp_D2,comp_D3,comp_D4,comp_D5]

        #now = datetime.now()
        #current_time = now.strftime("%Y-%m-%d %H_%M_%S")
        plt.savefig('angles.png')
      #  with open("angles.png", "rb") as f:
       #     dbx.files_upload(f.read(), "/angles.png", mode=dropbox.files.WriteMode("overwrite"))

        # Delete the local copy of the file
      #  os.remove("angles.png")

        for angle in angles:
            if angle > max_angle:
                max_counter += 1
                if max_counter >= consecutive_threshold:
                    max_angle = angle
                    max_counter = 0
            else:
                max_counter = 0

            if angle < min_angle:
                min_counter += 1
                if min_counter >= consecutive_threshold:
                    min_angle = angle
                    min_counter = 0
            else:
                min_counter = 0

            print("Minimum angle:", min_angle)
            print("Maximum angle:", max_angle)
        x_coordinates.append(comp_D2)
        y_coordinates.append(comp_D3)
        z_coordinates.append(comp_D4)
        D5.append(comp_D5)
        D1.append(comp_D1)
        frame_counter += 1
        axs[0].plot(range(frame_counter), D1)
        axs[1].plot(range(frame_counter), x_coordinates)
        axs[2].plot(range(frame_counter), y_coordinates)
        axs[3].plot(range(frame_counter), z_coordinates)
        axs[4].plot(range(frame_counter), D5)

        plt.pause(0.01)

    cv2.imshow("email jluk2@mgh.harvard.edu for issues", img)
    cv2.waitKey(1)