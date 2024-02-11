% Create COM Automation server
pptApp = actxserver('PowerPoint.Application');
pptApp.Visible = 1;

% Open a dialog box to select the PowerPoint file
%[file, path] = uigetfile({'*.pptx';'*.ppt'}, 'Select a PowerPoint file');
%if isequal(file, 0)
%   disp('User selected Cancel');
%else
load('shared_variables.mat');
load('shared_variables2.mat');
    presentationPath = fullfile(path, file);
    disp(['User selected ', presentationPath]);
    
    % Open the selected presentation
    presentation = pptApp.Presentations.Open(presentationPath);
        imagePath = 'C:\Users\justi\Downloads\_temp_matlab_R2023b_win64';
        fullImagePath = fullfile(imagePath, saveFileName);
        disp(['User selected ', fullImagePath]);
        
        % Input dialog for user to enter settings and slide number
        prompt = {
            'Enter the position number:', 
            'Enter the slide number:'
        };
        dlgtitle = 'Input';
        dims = [1 35];
        definput = {'0', '1'}; % default inputs
        userInput = inputdlg(prompt, dlgtitle, dims, definput);
        
        % Check if the user entered '1' or '2' for position/scaling
        positionScalingInput = userInput{1};
        if strcmp(positionScalingInput, '1')
            % Predefined position and scaling for '1'
            positionLeft = 614; % Modify as needed
            positionTop = 155; % Modify as needed
            desiredMaxWidth = 150; % in points
            desiredMaxHeight = 100; % in points
        elseif strcmp(positionScalingInput, '2')
            % Predefined position and scaling for '2'
            positionLeft = 783; % As specified
            positionTop = 155; % As specified
            desiredMaxWidth = 150; % in points
            desiredMaxHeight = 100; % in pointsc
        elseif strcmp(positionScalingInput, '3')
            % Predefined position and scaling for '3'
            positionLeft = 614; % As specified
            positionTop = 296; % As specified
            desiredMaxWidth = 150; % in points
            desiredMaxHeight = 100; % in points
        elseif strcmp(positionScalingInput, '4')
            % Predefined position and scaling for '4'
            positionLeft = 783; % As specified
            positionTop = 296; % As specified
            desiredMaxWidth = 150; % in points
            desiredMaxHeight = 100; % in points
        elseif strcmp(positionScalingInput, '5')
            % Predefined position and scaling for '5'
            positionLeft = 20; % As specified
            positionTop = 250; % As specified
            desiredMaxWidth = 150; % in points
            desiredMaxHeight = 175; % in points
        elseif strcmp(positionScalingInput, '6')
            % Predefined position and scaling for '6'
            positionLeft = 225; % As specified
            positionTop = 145; % As specified
            desiredMaxWidth = 375; % in points
            desiredMaxHeight = 300; % in points
        elseif strcmp(positionScalingInput, '7')  %not done yet
            % Predefined position and scaling for '7'
            positionLeft = 225; % As specified
            positionTop = 145; % As specified
            desiredMaxWidth = 375; % in points
            desiredMaxHeight = 300; % in points
       elseif strcmp(positionScalingInput, '8')
            % Predefined position and scaling for '5'
            positionLeft = 572; % As specified
            positionTop = 162; % As specified
            desiredMaxWidth = 145; % in points
            desiredMaxHeight = 110; % in points
        elseif strcmp(positionScalingInput, '9')
            % Predefined position and scaling for '5'
            positionLeft = 572+180; % As specified
            positionTop = 162; % As specified
            desiredMaxWidth = 145; % in points
            desiredMaxHeight = 110; % in points
        elseif strcmp(positionScalingInput, '10')
            % Predefined position and scaling for '5'
            positionLeft = 572; % As specified
            positionTop = 162+136; % As specified
            desiredMaxWidth = 145; % in points
            desiredMaxHeight = 110; % in points
        elseif strcmp(positionScalingInput, '11')
            % Predefined position and scaling for '5'
            positionLeft = 572+180; % As specified
            positionTop = 162+136; % As specified
            desiredMaxWidth = 145; % in points
            desiredMaxHeight = 110; % in points
        elseif strcmp(positionScalingInput, '12')
            % Predefined position and scaling for '5'
            positionLeft = 572; % As specified
            positionTop = 162+136*2; % As specified
            desiredMaxWidth = 145; % in points
            desiredMaxHeight = 110; % in points
        elseif strcmp(positionScalingInput, '13')
            % Predefined position and scaling for '5'
            positionLeft = 572+180; % As specified
            positionTop = 162+136*2; % As specified
            desiredMaxWidth = 145; % in points
            desiredMaxHeight = 110; % in points
        elseif strcmp(positionScalingInput, '14')
            % Predefined position and scaling for '5'
            positionLeft = 185; % As specified
            positionTop = 402; % As specified
            desiredMaxWidth = 140; % in points
            desiredMaxHeight = 180; % in points
        elseif strcmp(positionScalingInput, '15')
            % Predefined position and scaling for '5'
            positionLeft = 185+158; % As specified
            positionTop = 402; % As specified
            desiredMaxWidth = 140; % in points
            desiredMaxHeight = 180; % in points
        elseif strcmp(positionScalingInput, '16')
            % Predefined position and scaling for '5'
            positionLeft = 185+158*2; % As specified
            positionTop = 402; % As specified
            desiredMaxWidth = 140; % in points
            desiredMaxHeight = 180; % in points
        elseif strcmp(positionScalingInput, '17')
            % Predefined position and scaling for '5'
            positionLeft = 185+158*3; % As specified
            positionTop = 402; % As specified
            desiredMaxWidth = 140; % in points
            desiredMaxHeight = 180; % in points
        elseif strcmp(positionScalingInput, '18')
            % Predefined position and scaling for '5'
            positionLeft = 185+158*3; % As specified
            positionTop = 402; % As specified
            desiredMaxWidth = 140; % in points
            desiredMaxHeight = 180; % in points
        elseif strcmp(positionScalingInput, '19')   %not done yet
            % Predefined position and scaling for '5'
            positionLeft = 185+158*3; % As specified
            positionTop = 402; % As specified
            desiredMaxWidth = 140; % in points
            desiredMaxHeight = 180; % in points
        elseif strcmp(positionScalingInput, '20')  
            % Predefined position and scaling for '5'
            positionLeft = 758; % As specified
            positionTop = 126; % As specified
            desiredMaxWidth = 180; % in points
            desiredMaxHeight = 135; % in points
        elseif strcmp(positionScalingInput, '21')  
            % Predefined position and scaling for '5'
            positionLeft = 758; % As specified
            positionTop = 126+152; % As specified
            desiredMaxWidth = 180; % in points
            desiredMaxHeight = 135; % in points
        elseif strcmp(positionScalingInput, '22')   %not done yet
            % Predefined position and scaling for '5'
            positionLeft = 758; % As specified
            positionTop = 126+152; % As specified
            desiredMaxWidth = 180; % in points
            desiredMaxHeight = 135; % in points
        elseif strcmp(positionScalingInput, '23')  
            % Predefined position and scaling for '5'
            positionLeft = 20; % As specified
            positionTop = 413; % As specified
            desiredMaxWidth = 175; % in points
            desiredMaxHeight = 135; % in points
        elseif strcmp(positionScalingInput, '24')  
            % Predefined position and scaling for '5'
            positionLeft = 20+188; % As specified
            positionTop = 413; % As specified
            desiredMaxWidth = 175; % in points
            desiredMaxHeight = 135; % in points
        elseif strcmp(positionScalingInput, '25')  
            % Predefined position and scaling for '5'
            positionLeft = 20+188*2; % As specified
            positionTop = 413; % As specified
            desiredMaxWidth = 175; % in points
            desiredMaxHeight = 135; % in points
        elseif strcmp(positionScalingInput, '26')  
            % Predefined position and scaling for '5'
            positionLeft = 20+188*3; % As specified
            positionTop = 413; % As specified
            desiredMaxWidth = 175; % in points
            desiredMaxHeight = 135; % in points
        elseif strcmp(positionScalingInput, '27')  
            % Predefined position and scaling for '5'
            positionLeft = 20+188*4; % As specified
            positionTop = 413; % As specified
            desiredMaxWidth = 175; % in points
            desiredMaxHeight = 135; % in points
        elseif strcmp(positionScalingInput, '28')  
            % Predefined position and scaling for '5'
            positionLeft = 49; % As specified
            positionTop = 105; % As specified
            desiredMaxWidth = 225; % in points
            desiredMaxHeight = 170; % in points
        elseif strcmp(positionScalingInput, '29')  
            % Predefined position and scaling for '5'
            positionLeft = 49+264; % As specified
            positionTop = 105; % As specified
            desiredMaxWidth = 225; % in points
            desiredMaxHeight = 170; % in points
        elseif strcmp(positionScalingInput, '30')  
            % Predefined position and scaling for '5'
            positionLeft = 49; % As specified
            positionTop = 105+220; % As specified
            desiredMaxWidth = 225; % in points
            desiredMaxHeight = 170; % in points
        elseif strcmp(positionScalingInput, '31')  
            % Predefined position and scaling for '5'
            positionLeft = 49+264; % As specified
            positionTop = 105+220; % As specified
            desiredMaxWidth = 225; % in points
            desiredMaxHeight = 170; % in points
        elseif strcmp(positionScalingInput, '32')  %not done yet
            % Predefined position and scaling for '5'
            positionLeft = 49+264; % As specified
            positionTop = 105+220; % As specified
            desiredMaxWidth = 225; % in points
            desiredMaxHeight = 170; % in points
        elseif strcmp(positionScalingInput, '33')  
            % Predefined position and scaling for '5'
            positionLeft = 125; % As specified
            positionTop = 165; % As specified
            desiredMaxWidth = 190; % in points
            desiredMaxHeight = 145; % in points
        elseif strcmp(positionScalingInput, '34')  
            % Predefined position and scaling for '5'
            positionLeft = 125+208; % As specified
            positionTop = 165; % As specified
            desiredMaxWidth = 190; % in points
            desiredMaxHeight = 145; % in points
        elseif strcmp(positionScalingInput, '35')  
            % Predefined position and scaling for '5'
            positionLeft = 124+208*2; % As specified
            positionTop = 165; % As specified
            desiredMaxWidth = 190; % in points
            desiredMaxHeight = 145; % in points
        elseif strcmp(positionScalingInput, '36')  
            % Predefined position and scaling for '5'
            positionLeft = 123+208*3; % As specified
            positionTop = 165; % As specified
            desiredMaxWidth = 190; % in points
            desiredMaxHeight = 145; % in points
        elseif strcmp(positionScalingInput, '37')  
            % Predefined position and scaling for '5'
            positionLeft = 125; % As specified
            positionTop = 165+200; % As specified
            desiredMaxWidth = 190; % in points
            desiredMaxHeight = 145; % in points
        elseif strcmp(positionScalingInput, '38')  
            % Predefined position and scaling for '5'
            positionLeft = 125+208; % As specified
            positionTop = 165+200; % As specified
            desiredMaxWidth = 190; % in points
            desiredMaxHeight = 145; % in points
         elseif strcmp(positionScalingInput, '39')  
            % Predefined position and scaling for '5'
            positionLeft = 124+208*2; % As specified
            positionTop = 165+200; % As specified
            desiredMaxWidth = 190; % in points
            desiredMaxHeight = 145; % in points
         elseif strcmp(positionScalingInput, '40')  
            % Predefined position and scaling for '5'
            positionLeft = 123+208*3; % As specified
            positionTop = 165+200; % As specified
            desiredMaxWidth = 190; % in points
            desiredMaxHeight = 145; % in points
        else
            % Default or different position and scaling
            positionLeft = 50; % Modify as needed
            positionTop = 50; % Modify as needed
            desiredMaxWidth = 200; % in points
            desiredMaxHeight = 200; % in points
        end
        
        % Get the slide number from user input and ensure it's within the range
        slideNumberInput = str2double(userInput{2});
        if isnan(slideNumberInput) || slideNumberInput < 1 || slideNumberInput > presentation.Slides.Count
            slideNumberInput = max(1, min(presentation.Slides.Count, slideNumberInput)); % correct invalid slide number
            disp(['Invalid slide number. Using slide ', num2str(slideNumberInput)]);
        end
        
        % Select the specified slide
        slide = presentation.Slides.Item(slideNumberInput);
        
        % Read the image to get its size
        info = imfinfo(fullImagePath);
        origWidth = info.Width;
        origHeight = info.Height;
        
        % Calculate scaling factor
        scaleFactor = min(desiredMaxWidth / origWidth, desiredMaxHeight / origHeight);
        
        % Calculate new dimensions
        newWidth = origWidth * scaleFactor;
        newHeight = origHeight * scaleFactor;
        
        % Insert the image
        picture = slide.Shapes.AddPicture(fullImagePath , 'msoFalse', 'msoCTrue', positionLeft, positionTop, newWidth, newHeight);
        
        % Optionally, you can save the presentation
        presentation.SaveAs(fullfile(path, [file]));
        
        % Close the presentation (optional, depending on whether you want it to stay open)
        presentation.Close;
        
        % Quit PowerPoint application (optional, depending on whether you want PowerPoint to close)
        pptApp.Quit;
        
        % Release the COM objects
        pptApp.release;
    %end
%end
