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

%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]

% Insert answers here


%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [30 MARKS]

% Insert answers here


%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

% Insert answers here