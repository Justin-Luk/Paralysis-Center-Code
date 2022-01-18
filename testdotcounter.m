I = imread('Screenshot 2022-01-17 114755.jpg');
BW = im2bw(I, 0.8);
imshow(BW)

cc = bwconncomp(BW,4);
number  = cc.NumObjects