%% Automatic conversion of multiple .wav files to .csv
%% Luk, JH
%% Date: 7/16/22

%% A one time manual input is required on lines 14 & 41

close("all")

if(~isdeployed)
	cd(fileparts(which(mfilename)));
end
clc;	

wavFolder = fullfile('./C:\Users\user\OneDrive\Documents\MATLAB\EMG\wavfolder\'); %change to wherever you store your .wav files

if ~exist(wavFolder, 'dir')
 	message = sprintf('Please browse to your .wav folder');
	button = questdlg(message, 'Specify Folder', 'OK', 'Cancel', 'OK');
	drawnow;	
	if strcmpi(button, 'Cancel')
	   return;
	else
		wavFolder = uigetdir();
		if wavFolder == 0
			return;
		end
	end
end

filePattern = [wavFolder, '\*.wav'];
wavFiles = dir(filePattern);
audioFiles = [wavFiles];

numberOfFilesToProcess = length(audioFiles);

w = waitbar(0, 'Starting');

for k = 1 : numberOfFilesToProcess
    files_left_to_process = numberOfFilesToProcess - k + 1
    file = audioFiles(k).name;
    fs = 'C:\Users\user\OneDrive\Documents\MATLAB\EMG\wavfolder\'; % change this to whatever your filepath is
    converted = audioread([fs file]);
    convertedTimesThousand = converted.*1000;
    lastnumber = convertedTimesThousand(1:find(convertedTimesThousand,1,'last'));
    %roundedC = round(convertedTimesThousand,2); 
    baseFileNameNOext = file(1:(end-4));
    filename = [baseFileNameNOext '.csv'];

    csvwrite(filename, lastnumber)
    pause(1)
    csv = readtable(filename);
    filenametxt = [baseFileNameNOext '.txt'];
    writetable(csv, [fs filenametxt]);

    fid = fopen(filenametxt, 'rt');
    S = textscan(fid,'%s','delimiter','\n');
    S = S{1} ;
    fclose(fid) ;
    idx = contains(S,'Var1');
    S(idx) = [] ;   
    fid = fopen(filenametxt,'wt');
    fprintf(fid,'%s\n',S{:});
    fclose(fid);

    fid1 = fopen(filenametxt, 'rt');
    S1 = textscan(fid1,'%s','delimiter','\n') ;
    S2 = [{'44100' ; '1' ; ''}; S1{1}];
    fclose(fid1);
    fid1 = fopen(filenametxt,'wt');
    fprintf(fid1,'%s\n', S2{:});
    fclose(fid1);

    delete(filename)
    waitbar(k/numberOfFilesToProcess, w, sprintf('Progress: %d %%', floor(k/numberOfFilesToProcess*100)));
    pause(0.1)
end  
pause(1)
close(w)