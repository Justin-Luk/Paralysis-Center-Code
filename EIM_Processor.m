%% EIM Processor
%% Luk JH 
%% 7/12/22

%% Setup

clc;
% clear all;
[file, path] = uigetfile('*.xlsx*');

num = xlsread([path file]);

freq = num(:, 1);
phase = num(:,3);
resistance = num(:,4);
reactance = num(:,5);

n = 50;
[m,i] = min(abs(freq-n));
n1 = 100;
[m1,i1] = min(abs(freq-n1));
n2 = 500;
[m2,i2] = min(abs(freq-n2));
locationOf50 = i+1;
locationOf100 = i1+1;
locationOf500 = i2+1;

%% First 6 metrics
reactance50 = num(locationOf50, 5) % metric 1
reactance100 = num(locationOf100, 5) % metric 2
phase50 = num(locationOf50, 3) % metric 3
phase100 = num(locationOf100, 3) % metric 4
resistance50 = num(locationOf50, 4) % metric 5
resistance100 = num(locationOf100,4) % metric 6


%% Phase-Slope
figure;
set(gcf, 'Position', get(0,'Screensize'));
subplot(2,2,1)
%figure(1);
scatter(freq,phase) 
title('Phase-Slope')
xlabel('Frequency') 
ylabel('Phase') 

limitedRange = locationOf100:locationOf500;
coeffs = polyfit(freq(limitedRange), phase(limitedRange), 1);
%xFitting = 0:3;
%yFitted = polyval(coeffs, xFitting);
hold on; 
%disp(['Equation is y = ' num2str(coeffs(1)) '*x + ' num2str(coeffs(2))])
PhaseSlope = num2str(coeffs(1)) % metric 7

%% Reactance-Slope

subplot(2,2,2)
%figure(2);
scatter(freq,reactance)
title('Reactance-Slope')
xlabel('Frequency') 
ylabel('Reactance') 
limitedRange = locationOf100:locationOf500;

coeffs1 = polyfit(freq(limitedRange), reactance(limitedRange), 1);
%xFitting1 = 0:3; 
%yFitted1 = polyval(coeffs1, xFitting1);
hold on; 
%disp(['Equation is y = ' num2str(coeffs1(1)) '*x + ' num2str(coeffs1(2))])
ReactanceSlope = num2str(coeffs1(1)) % metric 8

%% Log-Resistance

logFreq = log10(freq);
logResistance = log10(resistance);

subplot(2,2,3.5);
%figure(3);
scatter(logFreq,logResistance) 
title('Log-Resistance')
xlabel('Log of Frequency') 
ylabel('Log of Resistance') 

limitedRange = locationOf50:locationOf500;
coeffs2 = polyfit(logFreq(limitedRange), logResistance(limitedRange), 1);
%xFitting2 = 0:3; 
%yFitted2 = polyval(coeffs2, xFitting2);
hold on; 
%disp(['Equation is y = ' num2str(coeffs(1)) '*x + ' num2str(coeffs(2))])
ResistanceSlope = num2str(coeffs2(1)) % metric 9