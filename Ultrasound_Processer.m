%First, outline the area of calibration in imagej and use the histogram to
%find the mean. Outline the area of interest in imagej and find the mean
%the same way. Add mean of area of calibration from area of interest
%and use this for v = [adjusted_mean adjusted_mean]
%Potential other ideas for correction: Ratio, Adding 

% Lowpass median filter
rawIMG = imread('11.38.44 hrs __[0003131]copy.jpg');
medIMG = medfilt2(rawIMG(:,:,2), [10,10]);  

% Make contour plot
v = [100.704 100.704]; %height of interest
contourf(medIMG(:,:,1),v) % Cross section of contour plot 
set(gca,'xdir','normal','ydir','reverse') % Flip to orient it correctly 

%The math
Area1=sum(medIMG(:,:,1)>88.073,'all') % number of pixels at the mean level 
B = 273*512 % Number of pixels in the picture
Area2 = Area1 / B;  % Gives a percentage of the image that is colored
Percent_Colored = Area2*100 
blobs = 10
Average_Blob_Size = Area1/blobs





