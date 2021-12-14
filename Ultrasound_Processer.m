%A = imread('copy.jpg');
%imshow(A)

%First, outline the area of calibration in imagej and use the histogram to
%find the mean. Outline the area of interest in imagej and find the mean
%the same way. Subtract mean of area of calibration from area of interest
%and use this for v = [adjusted_mean adjusted_mean]

% Lowpass median filter
rawIMG = imread('copy.jpg');
medIMG = medfilt2(rawIMG(:,:,2), [10,10]);  

% Make contour plot
v = [ 37.688 37.688]
contourf(medIMG(:,:,1),v)
%Area=sum(contourf(medIMG(:,:,1),v)>1,'all')
set(gca,'xdir','normal','ydir','reverse')

Area1=sum(medIMG(:,:,1)==38,'all')
