clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fprintf('Beginning to run %s.m ...\n', mfilename);
% Read in image
grayImage = imread('copy.jpg');
[rows, columns, numColorChannels] = size(grayImage) 
imshow(grayImage);
axis on;
impixelinfo
numBandsVertically = 2;
numBandsHorizontally = 2;
topRows = round(linspace(1, rows+1, numBandsVertically + 1));
leftColumns = round(linspace(1, columns+1, numBandsHorizontally + 1));
% Draw lines over image
for k = 1 : length(topRows)
	yline(topRows(k), 'Color', 'y', 'LineWidth', 2);
end
for k = 1 : length(leftColumns)
	xline(leftColumns(k), 'Color', 'y', 'LineWidth', 2);
end
% Extract into subimages and display on a new figure.
hFig2 = figure();
plotCounter = 1;
for row = 1 : length(topRows) - 1
	row1 = topRows(row);
	row2 = topRows(row + 1) - 1;
	for col = 1 : length(leftColumns) - 1
		col1 = leftColumns(col);
		col2 = leftColumns(col + 1) - 1;
		subplot(numBandsVertically, numBandsHorizontally, plotCounter);
		subImage = grayImage(row1 : row2, col1 : col2, :);
		imshow(subImage);
		caption = sprintf('Rows %d-%d, Columns %d-%d', row1, row2, col1, col2);
		title(caption);
		drawnow;
		plotCounter = plotCounter + 1;
	end
end
hFig2.WindowState = 'Maximized';
fprintf('Done running %s.m.\n', mfilename);