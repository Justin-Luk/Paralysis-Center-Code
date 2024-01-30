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
    
    % Add the angle measurement tool, frame number box, and timestamp
    my_angle_measurement_tool(markedFrame, figureHandle, currentTimeStrWithMillis);  % Pass currentTimeStrWithMillis instead of videoObj.CurrentTime

    % Add a "Save" button
    saveButton = uicontrol('Style', 'pushbutton', 'String', 'Save', ...
        'Units', 'normalized', 'Position', [0.9 0.01 0.1 0.05], ...
        'Callback', @(src, event) saveFigure(src, videoName, frameNumber, figureHandle));
end

% Callback function to save the figure
function saveFigure(src, videoName, frameNumber, figureHandle)
    % Save the figure as an image with the specified name
    saveFileName = [videoName, '_Time_', num2str(frameNumber), '.png'];
    
    % Get the image data from the figure
    frameImage = getframe(figureHandle);
    imageData = frameImage.cdata;
    
    % Save the image using imwrite
    imwrite(imageData, saveFileName);
    
    disp(['Figure saved as: ', saveFileName]);
    close(figureHandle);  % Close the figure after saving
end

% Function for angle measurement tool
% Callback function for angle measurement tool
function my_angle_measurement_tool(im, figureHandle, currentTimeStrWithMillis) % Note the parameter change here
    % Display image in the axes
    axesHandle = axes('Parent', figureHandle);
    imshow(im, 'Parent', axesHandle);

    % Get size of image.
    m = size(im, 1);
    n = size(im, 2);

    % Get center point of the image for initial positioning.
    midy = ceil(m / 2);
    midx = ceil(n / 2);

    % Position the first point vertically above the middle.
    firstx = midx;
    firsty = midy - ceil(m / 4);
    lastx = midx + ceil(n / 4);
    lasty = midy;

    % Create a two-segment right-angle polyline centered in the image.
    h = impoly(axesHandle, [firstx, firsty; midx, midy; lastx, lasty], "Closed", false);
    api = iptgetapi(h);
    initial_position = api.getPosition();

    % Display the initial position
    updateAngle(initial_position);

    % Set up a callback to update the angle in the title.
    api.addNewPositionCallback(@updateAngle);
    fcn = makeConstrainToRectFcn("impoly", get(axesHandle, "XLim"), get(axesHandle, "YLim"));
    api.setPositionConstraintFcn(fcn);

    % Add a box with the frame number
    annotation(figureHandle, 'textbox', [0.02, 0.02, 0.1, 0.03], 'String', ['Frame: ', currentTimeStrWithMillis], ...
        'FitBoxToText', 'on', 'EdgeColor', 'none', 'Color', 'none');

    % Display timestamp and angle information to the left of the "Save" button
    uicontrol('Style', 'text', 'String', ['Timestamp: ', currentTimeStrWithMillis], ...
        'Units', 'normalized', 'Position', [0.02 0.06 0.2 0.03]);

    % Callback function that calculates the angle and updates the title.
    % Function receives an array containing the current x, y position of
    % the three vertices.
    function updateAngle(p)
        % Create two vectors from the vertices.
        v1 = [p(1, 1) - p(2, 1), p(1, 2) - p(2, 2)];
        v2 = [p(3, 1) - p(2, 1), p(3, 2) - p(2, 2)];
        % Find the angle.
        theta = acos(dot(v1, v2) / (norm(v1) * norm(v2)));
        % Convert it to degrees with precision up to the hundredths.
        angle_degrees = theta * (180 / pi);
        % Display the angle in the title of the figure.
        title(axesHandle, sprintf('%.3f degrees', angle_degrees));
    end
end