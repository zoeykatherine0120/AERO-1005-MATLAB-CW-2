% Insert name here
% Muyun ZHONG
% Insert email address here
% ssymz8@nottingham.edu.cn


%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [5 MARKS]

% Insert answers here
clear;
clc;
close all;

% Establish communication between MATLAB and Arduino
a = arduino();

%Setup one LED on digital pin D1 and make it blink at 0.5s intervals
testLedPin = 'D2';
for i = 1:5
    writeDigitalPin(a,testLedPin,1);%LED ON
    pause(0.5);
    writeDigitalPin(a,testLedPin,0);%LED OFF
    pause(0.5);
end
disp('Preliminary task completed: Arduino connected and LED tested')

%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]

% Insert answers here
% Task 1a: Connect thermistor to A0 (example)
analogPin = 'A0';
duration = 600; % seconds
fs = 1;         % sampling frequency (Hz)
numSamples = duration * fs;

% Preallocate arrays
voltage = zeros(1, numSamples);
temperature = zeros(1, numSamples);
timeVec = (0:numSamples-1)';

% Thermistor parameters (from datasheet)
T_C = 0.01;      % Temperature coefficient (V/°C) - example value
V_OC = 0.5;      % Zero-degree voltage (V) - example value

% Data acquisition
fprintf('Acquiring temperature data for 10 minutes...\n');
for i = 1:numSamples
    voltage(i) = readVoltage(a, analogPin);
    temperature(i) = (voltage(i) - V_OC) / T_C;
    pause(fs);
end

% Statistical quantities
minTemp = min(temperature);
maxTemp = max(temperature);
avgTemp = mean(temperature);

% Task 1c: Plot and save as image
figure;
plot(timeVec, temperature, 'b-', 'LineWidth', 1.5);
xlabel('Time (seconds)');
ylabel('Temperature (°C)');
title('Capsule Temperature over 10 Minutes');
grid on;
saveas(gcf, 'temperature_plot.png');
% Include this image in your .docx file

% Task 1d & 1e: Print to screen and write to log file
fileID = fopen('capsule_temperature.txt', 'w');
currentDate = datestr(now, 'dd/mm/yyyy');
location = 'Nottingham';

fprintf(fileID, 'Data logging initiated - %s\n', currentDate);
fprintf(fileID, 'Location - %s\n', location);
fprintf('Data logging initiated - %s\n', currentDate);
fprintf('Location - %s\n', location);

for minute = 0:10
    idx = minute * 60 + 1;
    if idx <= numSamples
        tempVal = temperature(idx);
        fprintf(fileID, 'Minute%d\tTemperature%.2f C\n', minute, tempVal);
        fprintf('Minute%d\tTemperature%.2f C\n', minute, tempVal);
    end
end

fprintf(fileID, 'Max temp\t%.2f C\n', maxTemp);
fprintf(fileID, 'Min temp\t%.2f C\n', minTemp);
fprintf(fileID, 'Average temp\t%.2f C\n', avgTemp);
fprintf(fileID, 'Data logging terminated\n');

fprintf('Max temp\t%.2f C\n', maxTemp);
fprintf('Min temp\t%.2f C\n', minTemp);
fprintf('Average temp\t%.2f C\n', avgTemp);
fprintf('Data logging terminated\n');

fclose(fileID);

%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]

% Insert answers here
%Task 2f: Connect LEDs to pins (example)
greenPin = 'D3';
yellowPin = 'D5';
redPin = 'D6';

% Call temperature monitoring function
Task_2_temp_monitor(a, analogPin, greenPin, yellowPin, redPin);

%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [30 MARKS]

% Insert answers here
% Call prediction function


Task_3_temp_prediction(a, analogPin, greenPin, yellowPin, redPin);

%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

% Insert answers here
