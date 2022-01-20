if(~isdeployed)
  cd(fileparts(which(mfilename)));
end
%clc;  % Clear command window.
clear;  % Delete all variables.
close all;  % Close all figure windows except those created by imtool.
imtool close all;  % Close all figure windows created by imtool.
workspace;  % Make sure the workspace panel is showing.
fontSize = 16;

% Read in a standard MATLAB gray scale demo image.
folder = fileparts(which('Screenshot 2022-01-18 150342.png')); % Determine where demo folder is (works with all versions).
baseFileName = 'Screenshot 2022-01-18 150342.png ';

baseFileNameNOext = baseFileName(1:(end-4));

% Get the full filename, with path prepended.
fullFileName = fullfile(folder, baseFileName);
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
rgbImage = imread(fullFileName);

output_folder = 'C:\Users\justi\OneDrive\Documents\MATLAB\EMG/Matlab Ultrasound Pictures';

iter = 0;
while(1)
    iter = iter + 1;
    T= datetime;

    imshow(rgbImage, []);
    axis on;
    title('Original Color Image', 'FontSize', fontSize);
    set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
    
    % Ask user to draw freehand mask.
    %message = sprintf('Left click and hold to begin drawing.\nSimply lift the mouse button to finish');
    %uiwait(msgbox(message));
    hFH = imfreehand(); % Actual line of code to do the drawing.
    % Create a binary image ("mask") from the ROI object.
    binaryImage = hFH.createMask();
    xy = hFH.getPosition;

    csvFileName = [baseFileNameNOext '_Mask' num2str(iter) '_xy.csv'];
    csvwrite([output_folder '\' csvFileName],xy)
    
    % Now make it smaller so we can show more images.
    subplot(2, 2, 1);
    imshow(rgbImage, []);
    axis on;
    drawnow;
    title('Original gray scale image', 'FontSize', fontSize);
    
    % Display the freehand mask.
    subplot(2, 2, 2);
    imshow(binaryImage);
    axis on;
    title('Binary mask of the region', 'FontSize', fontSize);
    
    % Get coordinates of the boundary of the freehand drawn region.
    structBoundaries = bwboundaries(binaryImage);
    xy=structBoundaries{1}; % Get n by 2 array of x,y coordinates.
    x = xy(:, 2); % Columns.
    y = xy(:, 1); % Rows.
    subplot(2, 2, 1); % Plot over original image.
    hold on; % Don't blow away the image.
    plot(x, y,'k', 'LineWidth', 2);
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

    %Finds the average value of the pixels in the freehanded section.
    %Adjusts for the fact that the background of maskedRgb is black
    numPix = sum(binaryImage(:));
    numPix2 = sum(~binaryImage(:));
    totalPix = numPix + numPix2;
    meanval = ((mean2(maskedRgbImage)*(totalPix)))/(numPix)

        choice = menu('Press Subcutaneous tissue Muscle ','Subcutaneous tissue','Muscle');
    if choice==2 | choice==0
        maskFileName = [baseFileNameNOext '_SubCu'  num2str(iter) '#' datestr(now,'mm-dd-yyyy HH-MM') '.bmp'];
        imwrite(maskedRgbImage,[output_folder '\' maskFileName], 'bmp')
    
    else
         maskFileName = [baseFileNameNOext '_Muscle' num2str(iter) '#' datestr(now,'mm-dd-yyyy HH-MM') '.bmp'];
         imwrite(maskedRgbImage,[output_folder '\' maskFileName], 'bmp')
    end

  %  maskFileName = [baseFileNameNOext '_Mask' num2str(iter) '.bmp'];
   % imwrite(maskedRgbImage,[output_folder '\' maskFileName], 'bmp')
    axis on;
    caption = sprintf('Masked black outside the region');
    title(caption, 'FontSize', fontSize);
    
    choice = menu('Do you have more drawings?','Yes','No');
    if choice==2 | choice==0
       break;
    end
end
close all;