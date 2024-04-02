close all;
clear;
clc;

% Prompt user to select an image file
[filename, filepath] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp', 'Image Files (*.jpg, *.jpeg, *.png, *.bmp)'}, 'Select Image File');

% Check if the user canceled the selection
if isequal(filename, 0) || isequal(filepath, 0)
    disp('User canceled image selection.');
    return;
end

% Construct the full file path
fullFilePath = fullfile(filepath, filename);

% Read the image file
img = imread(fullFilePath);

% Display selected image information
disp(['Selected Image: ', fullFilePath]);

% Create a figure for displaying the image
figureHandle = figure;
imshow(img);
title('Selected Image');

% Initialize global variable to store the latest angle measurement
global latestAngle;
latestAngle = 0;

% Call the angle measurement tool for the selected image
my_angle_measurement_tool(img, figureHandle, filename);  % Pass filename for saving

% Function for angle measurement tool
function my_angle_measurement_tool(im, figureHandle, imageName)
    % Display image in the axes
    axesHandle = axes('Parent', figureHandle);
    imshow(im, 'Parent', axesHandle);

    % Initialize polyline for angle measurement
    [m, n, ~] = size(im);
    midy = ceil(m / 2);
    midx = ceil(n / 2);
    firstx = midx;
    firsty = midy - ceil(m / 4);
    lastx = midx + ceil(n / 4);
    lasty = midy;
    h = impoly(axesHandle, [firstx, firsty; midx, midy; lastx, lasty], 'Closed', false);
    api = iptgetapi(h);
    api.setPositionConstraintFcn(makeConstrainToRectFcn('impoly', get(axesHandle, 'XLim'), get(axesHandle, 'YLim')));
    api.addNewPositionCallback(@(pos) updateAngle(axesHandle, pos));

    % Add a "Save" button to the figure for saving the measurement
    uicontrol('Style', 'pushbutton', 'String', 'Save Angle Measurement', ...
              'Units', 'normalized', 'Position', [0.8 0.01 0.2 0.05], ...
              'Callback', @(src, event) saveFigure(figureHandle, imageName));
end

% Function to calculate and display the angle
function updateAngle(axesHandle, position)
    global latestAngle;
    v1 = [position(1, 1) - position(2, 1), position(1, 2) - position(2, 2)];
    v2 = [position(3, 1) - position(2, 1), position(3, 2) - position(2, 2)];
    theta = acos(dot(v1, v2) / (norm(v1) * norm(v2)));
    angle_degrees = theta * (180 / pi);
    latestAngle = angle_degrees; % Update the global variable with the latest angle
    title(axesHandle, sprintf('Angle: %.2f degrees', angle_degrees));
end

% Callback function to save the figure as an image
function saveFigure(figureHandle, imageName)
    global latestAngle;
    
    % Define the options
    options = {'WE', 'FWS', 'MCP2'};
    
    % Ask the user to choose an option
    [indx, tf] = listdlg('PromptString', {'Select a suffix for the filename:', '', 'WE - Wrist Extension', 'FWS - First Webspace', 'MCP2 - 2nd MCP'}, 'SelectionMode', 'single', 'ListString', options);
    
    % Check if the user made a selection
    if tf
        selectedOption = options{indx};
    else
        disp('User canceled the save operation.');
        return;
    end
    
    % Format the filename to include the angle measurement and selected option
    saveFileName = sprintf('%s_%.2f_Degrees_%s.png', erase(imageName, {'*', '.png','/', '?', '"', '<', '>', '|', ':'}), latestAngle, selectedOption);
    frameImage = getframe(figureHandle);
    imwrite(frameImage.cdata, saveFileName);
    disp(['Figure saved as: ', saveFileName]);
end
