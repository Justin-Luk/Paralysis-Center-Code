## Project: Motor Control
## Luk JH, Krenn, MJ
## Date: 4/5/22
import time
import cv2
import cvzone
from cvzone.HandTrackingModule import HandDetector
import csv
import math
import cmath

# Init
cap = cv2.VideoCapture(0)
# cap.set(3, 1920)
# cap.set(4, 1080)
detector = HandDetector(detectionCon=0.9, maxHands=1)
color0 = (0, 255, 0)
color1 = (0, 255, 0)
color2 = (0, 255, 0)
color3 = (0, 255, 0)
color4 = (0, 255, 0)
color5 = (0, 255, 0)
r = 12
R = 10
ax, ay, az = (0, 0, 0)
bx, by, bz = (0, 0, 0)
dx, dy, dz = (0, 0, 0)
ex, ey, ez = (0, 0, 0)
fx, fy, fz = (0, 0, 0)
gx, gy, gz = (0, 0, 0)

Score = 0
i = 1
t=0
startTime = time.time()

state = ''
distance = 0
distance1 = 0
distance2 = 0
distance3 = 0

mode = 0
mode1 = 0
nowE = 0
nowC = 0

saveMode = 0

while True:
    success, img = cap.read()
    img = cv2.flip(img, 1)
    img_rotate_90_clockwise = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
    img_rotate_90_clockwise = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
    # img = cv2.putText(img, f'Time: {time.ctime()}', (1000, 675), cv2.FONT_HERSHEY_SIMPLEX, 0.5,(250, 250, 250), 1, cv2.LINE_AA)

    hands, img = detector.findHands(img, flipType=False)

    key = cv2.waitKey(1)
    img = cv2.putText(img, f'Score: {Score}', (50, 50), cv2.FONT_HERSHEY_SIMPLEX, 1, (250, 250, 250), 3, cv2.LINE_AA)

    # Instructions
    if key == ord('h'):
        print("Instructions:")
        print("Press 1 to calibrate extended hand position")
        print("Press 2 to calibrate neutral hand position")
        print("Press 3 to calubrate closed hand position")
        print("Press t to reset points")
        print("Press r to reset score")

    if key == ord('1'):
        hands, img = detector.findHands(img)
        hand1 = hands[0]
        lmList1 = hand1["lmList"]
        ax, ay, az = lmList1[4]
        bx, by, bz = lmList1[8]


    if key == ord('2'):
        hands, img = detector.findHands(img)
        hand1 = hands[0]
        lmList1 = hand1["lmList"]
        dx, dy, dz = lmList1[4]
        ex, ey, ez = lmList1[8]

    if key == ord('3'):
        hands, img = detector.findHands(img)
        hand1 = hands[0]
        lmList1 = hand1["lmList"]
        fx, fy, fz = lmList1[4]
        gx, gy, gz = lmList1[8]

    # Point drawing
    if hands:
        hand1 = hands[0]
        lmList1 = hand1["lmList"]

        cv2.circle(img, (dx, dy), R, color0, cv2.FILLED)
        cv2.circle(img, (ex, ey), R, color1, cv2.FILLED)
        cv2.circle(img, (ax, ay), R, color2, cv2.FILLED)
        cv2.circle(img, (bx, by), R, color3, cv2.FILLED)
        cv2.circle(img, (fx, fy), R, color4, cv2.FILLED)
        cv2.circle(img, (gx, gy), R, color5, cv2.FILLED)


        # Touch Detection
        if lmList1:

            cursor = lmList1[4]
            if dx - r < cursor[0] < dx + r and dy - r < cursor[1] < dy + r and dz - 3 < cursor[2] < dz + 3:
                color0 = (0, 0, 255)
            else:
                color0 = (0, 255, 0)

            cursor1 = lmList1[8]
            if ex - r < cursor1[0] < ex + r and ey - r < cursor1[1] < ey + r and ez - 3 < cursor1[2] < ez + 3:
                color1 = (0, 0, 255)
            else:
                color1 = (0, 255, 0)

            if dx - r < cursor[0] < dx + r and dy - r < cursor[1] < dy + r and ex - r < cursor1[0] < ex + r and ey - r < \
                    cursor1[1] < ey + r:
                img = cv2.putText(img, f'Neutral', (50, 100), cv2.FONT_HERSHEY_SIMPLEX, 1,
                                  (0, 250, 0), 2, cv2.LINE_AA)

            cursor2 = lmList1[4]
            if ax - r < cursor2[0] < ax + r and ay - r < cursor2[1] < ay + r and az - 3 < cursor2[2] < az + 3:
                color2 = (0, 0, 255)
            else:
                color2 = (0, 255, 0)

            cursor3 = lmList1[8]
            if bx - r < cursor3[0] < bx + r and by - r < cursor3[1] < by + r and bz - 3 < cursor3[2] < bz + 3:
                color3 = (0, 0, 255)
            else:
                color3 = (0, 255, 0)
            if key == ord('e'):
                mode += 1
                nowE = time.time()
                print('Extend Fingers')

            if key == ord('c'):
                mode1 += 1
                nowC = time.time()
                print('Close Fingers')

            newMode = mode
            newMode1 = mode1

            if mode == 1:
                state = 'Open'

            if mode1 == 1:
                state = 'Closed'


            curTime = time.time()
            timeDifE = curTime - nowE
            timeDifC = curTime - nowC

            if color4 == (0, 0, 255) and color5 == (0, 0, 255) and newMode1 == 1:
                img = cv2.putText(img, f'Closed', (50, 100), cv2.FONT_HERSHEY_SIMPLEX, 1,(250, 250, 250), 2, cv2.LINE_AA)
                print(timeDifC)
                mode1 = 0
                Score += 1

            if color2 == (0, 0, 255) and color3 == (0, 0, 255) and newMode == 1:
                img = cv2.putText(img, f'Extended', (50, 100), cv2.FONT_HERSHEY_SIMPLEX, 1,(0, 250, 0), 2, cv2.LINE_AA)
                print(timeDifE)
                Score += 1
                mode = 0

            cursor4 = lmList1[4]
            if fx - r < cursor4[0] < fx + r and fy - r < cursor4[1] < fy + r and fz - 3 < cursor4[2] < fz + 3:
                color4 = (0, 0, 255)
            else:
                color4 = (0, 255, 0)

            cursor5 = lmList1[8]
            if gx - r < cursor5[0] < gx + r and gy - r < cursor5[1] < gy + r and gz - 3 < cursor5[2] < gz + 3:
                color5 = (0, 0, 255)
            else:
                color5 = (0, 255, 0)

            if key == ord('r'):
                Score = 0

            if key == ord('t'):
                ax, ay, az = (0, 0, 0)
                bx, by, bz = (0, 0, 0)
                dx, dy, dz = (0, 0, 0)
                ex, ey, ez = (0, 0, 0)
                fx, fy, fz = (0, 0, 0)
                gx, gy, gz = (0, 0, 0)

            if key == ord('s'):
                print("Saving")
                saveMode = 1

            which = 0
            which1 = 0

            if state == 'Open':
                which = distance1
                which1 = distance3

            if state == 'Closed':
                which = distance2
                which1 = distance4

            if saveMode == 1:
                with open('C:\\Users\\justi\\OneDrive\\Documents\\MotorControlData.csv','a+', newline='') as f:
                    fieldnames = ['Time', 'Index x', 'Index y', 'Index z', 'Thumb x', 'Thumb y', 'Thumb z', '', 'Closed Thumb x', 'Closed Thumb y', 'Closed Thumb z','Neutral Thumb x', 'Neutral Thumb y', 'Neutral Thumb z', 'Open Thumb x', 'Open Thumb y', 'Open Thumb z', 'Closed Index x', 'Closed Index y', 'Closed Index z', 'Neutral Index x', 'Neutral Index y', 'Neutral Index z', 'Open Index x', 'Open Index y', 'Open Index z', 'Command', '', 'Distance', 'Distance1']
                    writer = csv.DictWriter(f, fieldnames=fieldnames)
                    if i == 1:
                            writer.writeheader()
                            i = 0
                    xx, yy, zz = lmList1[8]
                    jj, kk, ll = lmList1[4]

                    t=time.time_ns()
                    this = t - startTime*1000000000

                    distance1 = math.sqrt(abs((xx-fx)^2+(yy-fy)^2+(zz-fz)^2))
                    distance2 = math.sqrt(abs((xx-gx)^2+(yy-gy)^2+(zz-gz)^2))
                    distance3 = math.sqrt(abs((jj-ax)^2+(kk-ay)^2+(ll-az)^2))
                    distance4 = math.sqrt(abs((jj-bx)^2+(kk-by)^2+(ll-bz)^2))

                    writer.writerow({'Time':this,'Index x' : xx, 'Index y' : yy, 'Index z' : zz, 'Thumb x' : jj, 'Thumb y' : kk, 'Thumb z': ll, 'Closed Thumb x':fx, 'Closed Thumb y':fy, 'Closed Thumb z':fz, 'Neutral Thumb x':dx, 'Neutral Thumb y':dy, 'Neutral Thumb z':dz, 'Open Thumb x':ax, 'Open Thumb y':ay, 'Open Thumb z':az, 'Closed Index x':gx, 'Closed Index y':gy, 'Closed Index z': gz, 'Neutral Index x': ex, 'Neutral Index y': ey, 'Neutral Index z': ez, 'Open Index x': bx, 'Open Index y': by, 'Open Index z': bz, 'Command': state, 'Distance': which, 'Distance1': which1})

            if key == ord('f'):
                print("Finished Saving")
                saveMode = 0

    cv2.imshow("Motor Control Game", img)
    cv2.waitKey(1)
