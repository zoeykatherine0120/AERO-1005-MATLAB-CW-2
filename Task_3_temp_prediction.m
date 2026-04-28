function Task_3_temp_prediction(a, analogPin, greenPin, yellowPin, redPin)
% TEMP_PREDICTION Predicts temperature in 5 minutes based on rate of change.
%   Continuously reads temperature, calculates rate of change (°C/s),
%   predicts temperature after 5 minutes, and controls LEDs:
%       - Green constant: rate within ±4°C/min
%       - Red constant: rate > +4°C/min
%       - Yellow constant: rate < -4°C/min
%
%   Inputs:
%       a         - Arduino object
%       analogPin - Analog pin for thermistor
%       greenPin  - Digital pin for green LED
%       yellowPin - Digital pin for yellow LED
%       redPin    - Digital pin for red LED
%
%   See also ARDUINO, READVOLTAGE, WRITEDIGITALPIN

T_C = 0.01;
V_OC = 0.5;

% Initialise previous temperature
prevTemp = readVoltage(a, analogPin);
prevTemp = (prevTemp - V_OC) / T_C;
prevTime = tic;

fprintf('Temperature prediction started. Press Ctrl+C to stop.\n');

while true
    % Current reading
    voltage = readVoltage(a, analogPin);
    currentTemp = (voltage - V_OC) / T_C;
    currentTime = toc(prevTime);
    
    % Rate of change (°C/s)
    if currentTime > 0
        rate_per_sec = (currentTemp - prevTemp) / currentTime;
        rate_per_min = rate_per_sec * 60;
    else
        rate_per_min = 0;
    end
    
    % Prediction in 5 minutes
    predictedTemp = currentTemp + rate_per_sec * 300;
    
    % Print to screen
    fprintf('Current: %.2f°C, Rate: %.2f°C/min, Predicted (5min): %.2f°C\n', ...
        currentTemp, rate_per_min, predictedTemp);
    
    % LED control based on rate of change
    if abs(rate_per_min) <= 4
        writeDigitalPin(a, greenPin, 1);
        writeDigitalPin(a, yellowPin, 0);
        writeDigitalPin(a, redPin, 0);
    elseif rate_per_min > 4
        writeDigitalPin(a, greenPin, 0);
        writeDigitalPin(a, yellowPin, 0);
        writeDigitalPin(a, redPin, 1);
    elseif rate_per_min < -4
        writeDigitalPin(a, greenPin, 0);
        writeDigitalPin(a, yellowPin, 1);
        writeDigitalPin(a, redPin, 0);
    end
    
    % Update previous values
    prevTemp = currentTemp;
    prevTime = tic;
    
    pause(1);
end
end