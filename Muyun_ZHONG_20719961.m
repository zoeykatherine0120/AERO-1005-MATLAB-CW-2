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
duration = 600; % 10 minutes (600 seconds)
tempSensorPin = 'A0';

% MCP9700A Thermistor constants (from datasheet)
v_0 = 0.5; % 500 mV at 0°C
t_c = 0.01; % 10 mV/°C

time_data = zeros(1, duration);
temp_data = zeros(1, duration);

disp('Task 1: Data logging initiated. This will take 10 minutes...');
for t = 1:duration
    v_read = readVoltage(a, tempSensorPin);
    % Convert voltage to temperature
    temp_C = (v_read - v_0) / t_c;
    
    time_data(t) = t - 1;
    temp_data(t) = temp_C;
    
    pause(1); % Read approx every 1 second
end

% Calculate statistics
max_temp = max(temp_data);
min_temp = min(temp_data);
avg_temp = mean(temp_data);

% Plotting the data
figure;
plot(time_data, temp_data, 'b-', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Temperature (C)');
title('Capsule Temperature over 10 Minutes');
grid on;

% Output formatting (matching Table 1 in the brief)
log_text = sprintf('Data logging initiated - %s\nLocation - Nottingham\n\n', datestr(now, 'dd/mm/yyyy'));
for m = 0:10
    idx = m * 60 + 1;
    if idx > duration
        idx = duration; 
    end
    log_text = [log_text, sprintf('Minute\t\t%d\nTemperature\t%.2f C\n\n', m, temp_data(idx))];
end
log_text = [log_text, sprintf('Max temp\t%.2f C\nMin temp\t%.2f C\nAverage temp\t%.2f C\n\nData logging terminated\n', max_temp, min_temp, avg_temp)];

% Print to screen
fprintf('%s', log_text);

% Write to file
fileID = fopen('capsule_temperature.txt', 'w');
fprintf(fileID, '%s', log_text);
fclose(fileID);
disp('Task 1 complete: Log saved to capsule_temperature.txt');


%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]

% Insert answers here


%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [30 MARKS]

% Insert answers here


%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

% Insert answers here
