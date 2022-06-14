close("all")

% Change the current folder to the folder of this m-file.
if(~isdeployed)
	cd(fileparts(which(mfilename)));
end
clc;	% Clear command window.
%close all;	% Close all figure windows except those created by imtool.
workspace;	% Make sure the workspace panel is showing.
fontSize = 16;

% Read in standard MATLAB color demo images.
% Construct the folder name where the demo images live.
imagesFolder = fullfile('./C:\Users\justi\OneDrive\Documents\MATLAB\EMG');
if ~exist(imagesFolder, 'dir')
	% That folder didn't exist.  Ask user to specify folder.
 	message = sprintf('Please browse to your image folder');
	button = questdlg(message, 'Specify Folder', 'OK', 'Cancel', 'OK');
	drawnow;	% Refresh screen to get rid of dialog box remnants.
	if strcmpi(button, 'Cancel')
	   return;
	else
		imagesFolder = uigetdir();
		if imagesFolder == 0
			% Exit if uer clicked Cancel.
			return;
		end
	end
end

% Read the directory to get a list of images.
filePattern = [imagesFolder, '\*.bmp'];
bmpFiles = dir(filePattern);
% Add more extensions if you need to.
imageFiles = [bmpFiles];

% Bail out if there aren't any images in that folder.
numberOfImagesProcessed = 0;
numberOfImagesToProcess = length(imageFiles);
if numberOfImagesToProcess <= 0
 	message = sprintf('I did not find any JPG, TIF, PNG, or BMP images in the folder\n%s\nClick OK to Exit.', imagesFolder);
	uiwait(msgbox(message));
	return;
end
%% Where stuff actually starts to happen
% Create a figure for our images.
figure;
set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
set(gcf,'name','Image Analysis Demo','numbertitle','off') 

% Preallocate arrays to hold the mean intensity values of all the images.
redChannel_Mean = zeros(numberOfImagesToProcess, 1);
greenChannel_Mean = zeros(numberOfImagesToProcess, 1);
blueChannel_Mean = zeros(numberOfImagesToProcess, 1);

numberOfImagesToProcess2 = numberOfImagesToProcess;

for k = 1 : numberOfImagesToProcess
    % Read in this one file.
    baseFileName = imageFiles(k).name;
    fullFileName = fullfile(imagesFolder, baseFileName);
    rgbImage = imread(fullFileName);

    % Check to see that it is a color image (3 dimensions).
    % Skip it if it is not true RGB color.
    if ndims(rgbImage) < 3
	    % Skip monochrome or indexed images.
	    fprintf('Skipped %s.  It is a grayscale or indexed image.\n', baseFileName);
	    % Decrement the number of images that we'll report that we need to look at.
	    numberOfImagesToProcess2 = numberOfImagesToProcess2 - 1;  
	    continue;
    end
    
    [r,g,b] = imsplit(rgbImage);
    invMask = r == 0 & g == 255 & b == 0;
    
    %% Get "luminosity image"
    labImage = rgb2gray(rgbImage);
    luminosityImage = labImage(:,:,1);

    if ~isempty(strfind(baseFileName,'SubCu'))
        col = 'r';
    else
        col = 'b';
    end
    
    %% Get the histogram where the mask is false (the hole in the green mask);
    edges = 0 : 255;
    pixelCounts = histcounts(luminosityImage(~invMask), edges);
    mu = mean2(luminosityImage(~invMask)) % mean of the values of pixel counts
    su1 = mu - std2(luminosityImage(~invMask)) % standard deviation bottom range
    su2 = mu + std2(luminosityImage(~invMask)) % standard deviation top range
    hold on
    plot(pixelCounts,col)
    xlabel('Luminosity Value', 'FontSize', 15);
    ylabel('Pixel Count', 'FontSize', 15);

    xline(su1, 'Color', 'c', 'LineWidth', 3); % Line 
    xline(su2, 'Color', 'c', 'LineWidth', 3);
    xline(mu, 'Color', 'g', 'LineWidth', 3);
    
    title('Composite Histogram', 'FontSize', fontSize)
    legend('Muscle','Mean', 'Subcu')
    grid on;

    
end
