%% Project: Analyze Muscle Ultrasound Image
%% Luk JH, Krenn MJ
%% Date:
%% Copyright:

%% FOLDER AND FILE DEFINITION
if(~isdeployed)
  cd(fileparts(which(mfilename)));
end
clc;
clear;  % Delete all variables.
close all;  % Close all figure windows except those created by imtool.
imtool close all;  % Close all figure windows created by imtool.
workspace;  % Make sure the workspace panel is showing.
fontSize = 16;

% Read in a standard MATLAB gray scale demo image.
input_folder = fileparts(which('Screenshot 2022-01-18 150342.png')); % Determine where demo folder is (works with all versions).
baseFileName = 'Screenshot 2022-01-18 150342.png ';
%[file, path] = uigetfile('*.*');

%baseFileName = readlines([path file]);

baseFileNameNOext = baseFileName(1:(end-4));

% Get the full filename, with path prepended.
fullFileName = fullfile(input_folder, baseFileName);
% Check if file exists.
if ~exist(fullFileName, 'file')
  % File doesn't exist -- didn't find it there.  Check the search path for it.
  fullFileName = baseFileName; % No path this time.
  if ~exist(fullFileName, 'file')
    % Still didn't find it.  Alert user.
    errorMessage = sprintf('Error: %s does not exist in the search path folders.', fullFileName);
    uiwait(warndlg(errorMessage));
    return;
  end
end

output_folder = 'C:\Users\justi\OneDrive\Documents\MATLAB\EMG/Matlab Ultrasound Pictures';

%% READ IN IMAGE
rgbImage = imread(fullFileName);

%% DEFINE SEGMENTATIONS
iterREF = 1;
iterMSC = 1; 

while(1)
    %iter = iter + 1;
    T= datetime;

    imshow(rgbImage, []);
    axis on;
    title('Original Image', 'FontSize', fontSize);
    set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
    
    hFH = imfreehand(); % Actual line of code to do the drawing.
    % Create a binary image ("mask") from the ROI object.
    binaryImage = hFH.createMask();
    xy = hFH.getPosition;
    
    % Now make it smaller so we can show more images.
    subplot(2, 2, 1);
    imshow(rgbImage, []);
    axis on;
    drawnow;
    title('Original gray scale image', 'FontSize', fontSize);
    
    % Display the freehand mask.
   % subplot(2, 2, 2);
    %imshow(binaryImage);
   % axis on;
   % title('Binary mask of the region', 'FontSize', fontSize);
    
    % Get coordinates of the boundary of the freehand drawn region.
    structBoundaries = bwboundaries(binaryImage);
    xy=structBoundaries{1}; % Get n by 2 array of x,y coordinates.
    x = xy(:, 2); % Columns.
    y = xy(:, 1); % Rows.
    subplot(2, 2, 1); % Plot over original image.
    hold on; % Don't blow away the image.
    plot(x, y,'g', 'LineWidth', 1);
    drawnow; % Force it to draw immediately.
   
    % Extract the individual red, green, and blue color channels.
    redChannel = rgbImage(:, :, 1);
    greenChannel = rgbImage(:, :, 2);
    blueChannel = rgbImage(:, :, 3);

    % Assign colors within each color channel individually.
    redChannel(~binaryImage) = 0;
    greenChannel(~binaryImage) = 0;
    blueChannel(~binaryImage) = 0;

    % Recombine separate masked color channels into a single, true color RGB image.
    maskedRgbImage = cat(3, redChannel, greenChannel, blueChannel);

    burnedImage(~binaryImage) = 255;
    % Display the image with the mask "burned in."
    subplot(2, 2, 3);
    imshow(maskedRgbImage);

    subplot(1,2,2);
    [pixelCounts grayLevels] = imhist(maskedRgbImage, 256);
    bar(grayLevels, pixelCounts);
    xlim([1 255]);

    %Finds the average value of the pixels in the freehanded section.
    %Adjusts for the fact that the background of maskedRgb is black
        numPix = sum(binaryImage(:));
        numPix2 = sum(~binaryImage(:));
        totalPix = numPix + numPix2;
    choice = menu('Press Subcutaneous fat Muscle ','Subcutaneous segmentation','Muscle segmentation');
    if choice==2 | choice==0
        maskFileName = [baseFileNameNOext '_SubCu'  num2str(iterREF) '#' datestr(now,'mm-dd-yyyy HH-MM') '.bmp'];
        imwrite(maskedRgbImage,[output_folder '\' maskFileName], 'bmp')

        csvFileName = [baseFileNameNOext '_SubCu' num2str(iterREF) '_xy.csv'];
        csvwrite([output_folder '\' csvFileName],xy)
        meanValSub = ((mean2(maskedRgbImage)*(totalPix)))/(numPix);
        disp(meanValSub)
        iterREF = iterREF + 1;
    else
         maskFileName = [baseFileNameNOext '_Muscle' num2str(iterMSC) '#' datestr(now,'mm-dd-yyyy HH-MM') '.bmp'];
         imwrite(maskedRgbImage,[output_folder '\' maskFileName], 'bmp')

         csvFileName = [baseFileNameNOext '_Muscle' num2str(iterMSC) '_xy.csv'];
         csvwrite([output_folder '\' csvFileName],xy)

         meanValMus = ((mean2(maskedRgbImage)*(totalPix)))/(numPix);
         disp(meanValMus)

         iterMSC = iterMSC + 1;
    end

  %  maskFileName = [baseFileNameNOext '_Mask' num2str(iter) '.bmp'];
   % imwrite(maskedRgbImage,[output_folder '\' maskFileName], 'bmp')
    axis on;
   % caption = sprintf('Your Selection');
    title(caption, 'FontSize', fontSize);
    
    choice = menu('Do you have more drawings?','Yes','No');
    if choice==2 | choice==0
       break;
    else
         close all;
    end
end

close all;