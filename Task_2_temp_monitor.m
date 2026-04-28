function Task_2_temp_monitor(a)
%TEMP_MONITOR Continuously monitors temperature, updates live plot, and controls LEDs.
%   TEMP_MONITOR(a) uses the arduino object 'a' to read from an MCP9700A 
%   thermistor on pin A0. It plots the live temperature updated every 1s.
%   Comfort range is 18-24 C (Green LED constant).
%   Below 18 C: Yellow LED blinks at 0.5s interval.
%   Above 24 C: Red LED blinks at 0.25s interval.

tempSensorPin = 'A0';
greenLED = 'D2';
yellowLED = 'D3';
redLED = 'D4';

% Thermistor constants
v_0 = 0.5; 
t_c = 0.01;

% Initialize Live Plot
figure;
hPlot = plot(nan, nan, 'b-', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Temperature (C)');
title('Live Capsule Temperature Monitoring');
xlim([0, 100]); 
ylim([10, 35]);
grid on;

startTime = tic;
timeData = [];
tempData = [];

lastGraphUpdate = 0;
ledState = 0;
lastLEDToggle = 0;

disp('Starting Task 2 Continuous Monitor. Press Ctrl+C to stop.');

while true
    currentTime = toc(startTime);
    v_read = readVoltage(a, tempSensorPin);
    currentTemp = (v_read - v_0) / t_c;

    % Update graph roughly every 1s
    if currentTime - lastGraphUpdate >= 1
        timeData = [timeData, currentTime];
        tempData = [tempData, currentTemp];
        set(hPlot, 'XData', timeData, 'YData', tempData);
        if currentTime > 100
            xlim([currentTime - 100, currentTime]);
        end
        drawnow;
        lastGraphUpdate = currentTime;
    end

    % LED Control Logic based on temperature
    if currentTemp >= 18 && currentTemp <= 24
        writeDigitalPin(a, greenLED, 1);
        writeDigitalPin(a, yellowLED, 0);
        writeDigitalPin(a, redLED, 0);

    elseif currentTemp < 18
        writeDigitalPin(a, greenLED, 0);
        writeDigitalPin(a, redLED, 0);
        if currentTime - lastLEDToggle >= 0.5
            ledState = ~ledState;
            writeDigitalPin(a, yellowLED, ledState);
            lastLEDToggle = currentTime;
        end

    elseif currentTemp > 24
        writeDigitalPin(a, greenLED, 0);
        writeDigitalPin(a, yellowLED, 0);
        if currentTime - lastLEDToggle >= 0.25
            ledState = ~ledState;
            writeDigitalPin(a, redLED, ledState);
            lastLEDToggle = currentTime;
        end
    end

    pause(0.05);
end
end