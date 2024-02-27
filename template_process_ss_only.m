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

% Create a text box to display current frame number and time
frameNumberText = uicontrol('Style', 'text', 'String', 'Frame: 1, Time: 00:00:00:000', ...
    'Units', 'normalized', 'Position', [0.02 0.95 0.5 0.03]);

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
    
    % Here we add the frame number to the display
    frameDisplayStr = sprintf('Frame: %d, Time: %s', frameNumber, currentTimeStrWithMillis);
    
    frameNumberText = findobj(gcf, 'Type', 'uicontrol', 'Style', 'text');
    set(frameNumberText, 'String', frameDisplayStr);
end

% Simplified Callback function to mark and save the current frame with dialogue for custom naming
function markFrame(videoObj, slider)
    frameNumber = round(slider.Value);
    
    videoObj.CurrentTime = (frameNumber - 1) / videoObj.FrameRate;
    markedFrame = readFrame(videoObj);
    
    % Pop-up dialog for label selection
    choice = questdlg('Choose the label for the frame:', ...
        'Frame Label', ...
        'Approach', 'Reach', 'Approach'); % Default to 'Approach'
    
    % Prepare to ask for numeric input after the label selection
    prompt = {'Enter a number to follow the label:'};
    dlgtitle = 'Input Number';
    num_lines = 1;
    defaultans = {'1'}; % Default number
    
    % Handle response for label selection
    switch choice
        case 'Approach'
            label = 'Approach';
        case 'Reach'
            label = 'Reach';
        otherwise
            disp('No label selected. Frame not saved.');
            return;
    end
    
    % Ask for numeric input
    answer = inputdlg(prompt, dlgtitle, num_lines, defaultans);
    if isempty(answer)
        disp('Numeric input cancelled. Frame not saved.');
        return;
    end
    % Append numeric input to label
    label = [label, '_', answer{1}];
    
    [~, videoName, ~] = fileparts(videoObj.Name);
    saveFileName = sprintf('%s_%s_Frame_%d.png', videoName, label, frameNumber);
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
