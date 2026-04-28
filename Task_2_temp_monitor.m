function Task_2_temp_monitor(a, analogPin, greenPin, yellowPin, redPin)
% TEMP_MONITOR Monitors temperature and controls LEDs accordingly.
%   This function reads temperature from a thermistor connected to
%   analogPin, plots live temperature data, and controls three LEDs
%   based on comfort range (18-24°C):
%       - Green: constant ON when temp in range.
%       - Yellow: blink 0.5s when temp < 18°C.
%       - Red: blink 0.25s when temp > 24°C.
%
%   Inputs:
%       a         - Arduino object
%       analogPin - Analog pin for thermistor (e.g., 'A0')
%       greenPin  - Digital pin for green LED
%       yellowPin - Digital pin for yellow LED
%       redPin    - Digital pin for red LED
%
%   See also ARDUINO, READVOLTAGE, WRITEDIGITALPIN

% Thermistor parameters (must match main script)
T_C = 0.01;
V_OC = 0.5;

% Setup figure for live plotting
figure;
h = plot(nan, nan);
xlabel('Time (seconds)');
ylabel('Temperature (°C)');
title('Live Temperature Monitoring');
grid on;
xlim([0 60]);
ylim([10 40]);

timeData = [];
tempData = [];
t0 = tic;

fprintf('Temperature monitoring started. Press Ctrl+C to stop.\n');

while true
    % Read temperature
    voltage = readVoltage(a, analogPin);
    temperature = (voltage - V_OC) / T_C;
    
    % Update live plot
    elapsedTime = toc(t0);
    timeData = [timeData, elapsedTime];
    tempData = [tempData, temperature];
    set(h, 'XData', timeData, 'YData', tempData);
    drawnow;
    
    % LED control logic
    if temperature >= 18 && temperature <= 24
        % Green constant ON, others OFF
        writeDigitalPin(a, greenPin, 1);
        writeDigitalPin(a, yellowPin, 0);
        writeDigitalPin(a, redPin, 0);
    elseif temperature < 18
        % Yellow blinking 0.5s
        writeDigitalPin(a, greenPin, 0);
        writeDigitalPin(a, redPin, 0);
        writeDigitalPin(a, yellowPin, 1);
        pause(0.5);
        writeDigitalPin(a, yellowPin, 0);
        pause(0.5);
    else % temperature > 24
        % Red blinking 0.25s
        writeDigitalPin(a, greenPin, 0);
        writeDigitalPin(a, yellowPin, 0);
        writeDigitalPin(a, redPin, 1);
        pause(0.25);
        writeDigitalPin(a, redPin, 0);
        pause(0.25);
    end
    
    pause(1 - mod(toc(t0), 1)); % Maintain 1s sampling
end
end