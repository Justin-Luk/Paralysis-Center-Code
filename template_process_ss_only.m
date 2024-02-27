close all;
clear;
clc;

% Prompt user to select a video file
[filename, filepath] = uigetfile({'*.mp4;*.avi;*.mov', 'Video Files (*.mp4, *.avi, *.mov)'}, 'Select Video File');

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

% Ensure there is an axes object in the figure for displaying the image
mainAxes = axes('Parent', mainFigure);

% Create a slider for navigating frames
slider = uicontrol('Style', 'slider', 'Min', 1, 'Max', videoObj.NumFrames, ...
    'Value', 1, 'SliderStep', [1/videoObj.NumFrames, 10/videoObj.NumFrames], ...
    'Units', 'normalized', 'Position', [0.1 0.01 0.8 0.05], ...
    'Callback', @(src, event) updateFrame(src, videoObj, mainAxes));

% Create a "Mark Frame" button
markFrameButton = uicontrol('Style', 'pushbutton', 'String', 'Mark Frame', ...
    'Units', 'normalized', 'Position', [0.9 0.01 0.1 0.05], ...
    'Callback', @(src, event) markFrame(videoObj, slider));

% Create a text box to display current frame number
frameNumberText = uicontrol('Style', 'text', 'String', 'Current Time: 00:00:00', ...
    'Units', 'normalized', 'Position', [0.02 0.95 0.4 0.03]);

% Set the KeyPressFcn for the figure
set(mainFigure, 'KeyPressFcn', @(fig_obj, event) figureKeyPress(event, slider, videoObj, mainAxes));

% Display the first frame
updateFrame(slider, videoObj, mainAxes); % Adjusted to pass mainAxes

% Callback function to update the displayed frame
function updateFrame(slider, videoObj, mainAxes)
    frameNumber = round(slider.Value);
    videoObj.CurrentTime = (frameNumber - 1) / videoObj.FrameRate;
    currentFrame = readFrame(videoObj);
    imshow(currentFrame, 'Parent', mainAxes); % Use mainAxes for imshow
    
    currentTime = videoObj.CurrentTime;
    currentTimeStr = datestr(seconds(currentTime), 'HH:MM:SS');
    milliseconds = floor((currentTime - floor(currentTime)) * 1000);
    currentTimeStrWithMillis = sprintf('%s:%03d', currentTimeStr, milliseconds);
    
    frameNumberText = findobj(gcf, 'Type', 'uicontrol', 'Style', 'text');
    set(frameNumberText, 'String', ['Current Time: ', currentTimeStrWithMillis])
end

% Simplified Callback function to mark and save the current frame
function markFrame(videoObj, slider)
    frameNumber = round(slider.Value);
    
    videoObj.CurrentTime = (frameNumber - 1) / videoObj.FrameRate;
    markedFrame = readFrame(videoObj);
    
    currentTime = videoObj.CurrentTime;
    currentTimeStr = datestr(seconds(currentTime), 'HH:MM:SS');
    milliseconds = floor((currentTime - floor(currentTime)) * 1000);
    currentTimeStrWithMillis = sprintf('%s:%03d', currentTimeStr, milliseconds);
    
    [~, videoName, ~] = fileparts(videoObj.Name);
    saveFileName = [videoName, '_Frame_', num2str(frameNumber), '.png'];
    imwrite(markedFrame, saveFileName);
    
    disp(['Frame saved as: ', saveFileName]);
end

% Function to handle key press events for figure navigation
function figureKeyPress(event, slider, videoObj, mainAxes)
    switch event.Key
        case 'leftarrow'
            newValue = max(slider.Value - 1, slider.Min);
            slider.Value = newValue;
            updateFrame(slider, videoObj, mainAxes);
        case 'rightarrow'
            newValue = min(slider.Value + 1, slider.Max);
            slider.Value = newValue;
            updateFrame(slider, videoObj, mainAxes);
    end
end
