clc;
clear all;
close all;

%% Original Image
[File,Path] = uigetfile('*.bmp');
rgbImage=imread(strcat(Path,File));

%% Get green mask
[r,g,b] = imsplit(rgbImage);
mask = r == 0 & g == 255 & b == 0;

%% Get "luminosity image"
labImage = rgb2gray(rgbImage);
luminosityImage = labImage(:,:,1);

%% Get the histogram where the mask is false (the hole in the green mask);
edges = 0 : 255;
pixelCounts = histcounts(luminosityImage(~mask), edges);
plot(pixelCounts)
bar(edges(1:end-1), pixelCounts);
grid on;
title('Luminosity Histogram')

%% Finding mean and median
dataMean = mean(luminosityImage(~mask))
dataMedian = median(luminosityImage(~mask))