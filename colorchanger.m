% Use uigetfile to select the image
[fileName, pathName] = uigetfile({'*.jpg;*.jpeg;*.png;*.tif;*.bmp', 'Image Files (*.jpg, *.jpeg, *.png, *.tif, *.bmp)'}, 'Select an Image File');
if isequal(fileName,0) || isequal(pathName,0)
    disp('User canceled image selection.');
    return;
else
    fullPath = fullfile(pathName, fileName);
    % Load the selected image
    img = imread(fullPath);
end

% Convert the image from RGB to HSV color space
imgHSV = rgb2hsv(img);

% Convert hex color #99BBAA to RGB and then to HSV
hexColor = '#99BBAA';
rgbColor = sscanf(hexColor(2:end), '%2x%2x%2x', [1 3]) / 255;
targetHSV = rgb2hsv(rgbColor);

% Define the green color range you want to change
greenHueRange = [0.15, 0.50]; % Adjust based on your green's hue
greenSaturationMin = 0.2; % Adjust based on your green's saturation
valueMin = 0.2; % Adjust to avoid changing dark areas that are not the background

% Find pixels that are green (within the specified range)
greenMask = (imgHSV(:,:,1) >= greenHueRange(1) & imgHSV(:,:,1) <= greenHueRange(2)) & ...
            (imgHSV(:,:,2) >= greenSaturationMin) & ...
            (imgHSV(:,:,3) >= valueMin);

% Change the hue, saturation, and value of the green areas to the target
imgHSV(:,:,1) = imgHSV(:,:,1) .* ~greenMask + targetHSV(1) .* greenMask;
imgHSV(:,:,2) = imgHSV(:,:,2) .* ~greenMask + targetHSV(2) .* greenMask;
% For value (brightness), you might want to preserve the original or adjust it slightly.
% This line keeps the original brightness:
imgHSV(:,:,3) = imgHSV(:,:,3); % No change to the value channel

% Convert the image back to RGB color space
resultImg = hsv2rgb(imgHSV);

% Display the original and modified images
subplot(1, 2, 1), imshow(img), title('Original Image');
subplot(1, 2, 2), imshow(resultImg), title('Image with Background Changed to #99BBAA');

% Optionally, use uiputfile to save the modified image
[fileNameSave, pathNameSave] = uiputfile({'*.jpg;*.jpeg;*.png;*.tif;*.bmp', 'Image Files (*.jpg, *.jpeg, *.png, *.tif, *.bmp)'}, 'Save the Modified Image');
if isequal(fileNameSave,0) || isequal(pathNameSave,0)
    disp('User canceled saving the modified image.');
else
    fullPathSave = fullfile(pathNameSave, fileNameSave);
    imwrite(resultImg, fullPathSave);
    disp(['Modified image saved to ', fullPathSave]);
end
