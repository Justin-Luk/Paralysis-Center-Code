% Project: Screenshotter and inserter
% Luk JH 
% Date: 06FEB24
% The purpose of this script is to centralize processing videos into images without angle measurements

close all;
clear;
clc;

% Prompt user to select a video file
[filename, filepath] = uigetfile({'*.mp4;*.avi;*.mov', 'Video Files (*.mp4, *.avi, *.mov)'}, 'Select Video File');

[file, path] = uigetfile({'*.pptx';'*.ppt'}, 'Select a PowerPoint file');
    save('shared_variables.mat', 'path', 'file');

% Check if the user canceled the selection
if isequal(filename, 0) || isequal(filepath, 0)
    disp('User canceled video selection.');
    return;
end

% Construct the full file path
fullFilePath = fullfile(filepath, filename);

% Read the video file
videoObj = VideoReader(fullFilePath);

% Display video information
disp(['Selected Video: ', fullFilePath]);
disp(['Video Duration: ', num2str(videoObj.Duration), ' seconds']);
disp(['Frame Rate: ', num2str(videoObj.FrameRate), ' frames per second']);

% Create a figure for displaying the video
mainFigure = figure;

% Create a slider for navigating frames
slider = uicontrol('Style', 'slider', 'Min', 1, 'Max', videoObj.NumFrames, ...
    'Value', 1, 'SliderStep', [1/videoObj.NumFrames, 10/videoObj.NumFrames], ...
    'Units', 'normalized', 'Position', [0.1 0.01 0.8 0.05], ...
    'Callback', @(src, event) updateFrame(src, videoObj, mainFigure)); % Pass mainFigure as an argument

% Create a "Mark Frame" button
markFrameButton = uicontrol('Style', 'pushbutton', 'String', 'Mark Frame', ...
    'Units', 'normalized', 'Position', [0.9 0.01 0.1 0.05], ...
    'Callback', @(src, event) markFrame(videoObj, slider));

% Create a text box to display current frame number
frameNumberText = uicontrol('Style', 'text', 'String', 'Current Time: 00:00:00', ...
    'Units', 'normalized', 'Position', [0.02 0.95 0.4 0.03]);

% Initialize with the first frame
currentFrame = readFrame(videoObj);
imshow(currentFrame);
% Callback function to update the displayed frame
function updateFrame(slider, videoObj, mainFigure)
    % Read the frame corresponding to the slider value
    frameNumber = round(get(slider, 'Value'));
    videoObj.CurrentTime = (frameNumber - 1) / videoObj.FrameRate;
    currentFrame = readFrame(videoObj);
    
    % Display the frame
    imshow(currentFrame);
    
    % Calculate milliseconds and format time string
    currentTime = videoObj.CurrentTime;
    currentTimeStr = datestr(seconds(currentTime), 'HH:MM:SS');
    milliseconds = floor((currentTime - floor(currentTime)) * 1000); % milliseconds part
    currentTimeStrWithMillis = sprintf('%s:%03d', currentTimeStr, milliseconds);
    % Update the text box with the current time in HH:MM:SS:FFF format
    frameNumberText = findobj(gcf, 'Type', 'uicontrol', 'Style', 'text');
    set(frameNumberText, 'String', ['Current Time: ', currentTimeStrWithMillis])
end

% Callback function to mark the current frame
function markFrame(videoObj, slider)
    % Get the current frame number
    frameNumber = round(get(slider, 'Value'));
    
    % Read the frame
    videoObj.CurrentTime = (frameNumber - 1) / videoObj.FrameRate;
    markedFrame = read(videoObj, frameNumber);
    
    % Calculate milliseconds and format time string
    currentTime = videoObj.CurrentTime;
    currentTimeStr = datestr(seconds(currentTime), 'HH:MM:SS');
    milliseconds = floor((currentTime - floor(currentTime)) * 1000); % milliseconds part
    currentTimeStrWithMillis = sprintf('%s:%03d', currentTimeStr, milliseconds);
    
    % Create a figure window with a name based on the original video name and frame number
    [~, videoName, ~] = fileparts(videoObj.Name);
    figureHandle = figure('Name', ['Marked Frame - ', videoName, ' - Time Stamp: ', num2str(currentTimeStrWithMillis)], 'NumberTitle', 'off');
    
    % Display the marked frame
    imshow(markedFrame, 'Parent', axes('Parent', figureHandle));
    
    % Add a "Save" button
    saveButton = uicontrol('Style', 'pushbutton', 'String', 'Save', ...
        'Units', 'normalized', 'Position', [0.9 0.01 0.1 0.05], ...
        'Callback', @(src, event) saveFigure(src, videoName, frameNumber, figureHandle));
end

% Callback function to save the figure
function saveFigure(src, videoName, frameNumber, figureHandle)
    % Save the figure as an image with the specified name
    saveFileName = [videoName, '_Frame_', num2str(frameNumber), '.png'];
    
    % Get the image data from the figure
    frameImage = getframe(figureHandle);
    imageData = frameImage.cdata;
    
    % Save the image using imwrite
    imwrite(imageData, saveFileName);
    
    disp(['Figure saved as: ', saveFileName]);
    close(figureHandle);  % Close the figure after saving
    save('shared_variables2.mat', 'saveFileName');
    run('powerpointinserter.m');
end
