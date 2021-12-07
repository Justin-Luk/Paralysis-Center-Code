
[file, path] = uigetfile('*.*');

lines = readlines([path file]);

STMINT = 0;
PTP = 0;
ind1 = 0;
ind2 = 0;
for ll = 100:length(lines)
    
    str = lines{ll};

    if contains(str, 'Stimulus Intensity')
        ind1 = ind1 + 1;
        pos = strfind(str,'=');
        STMINT(ind1) = str2double(str((pos+1):end));
    end

    if contains(str, 'Peak Amplitude(mV)')
        ind2 = ind2 + 1;
        pos = strfind(str,'=');
        PTP(ind2) = str2double(str((pos+1):end));
    end
end

if ind1 ~= ind2
    disp('WARNING')
end

csvwrite('EMG.dat', [STMINT',PTP'])

plot(STMINT, PTP, '.r')