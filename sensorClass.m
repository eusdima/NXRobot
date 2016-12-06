classdef sensorClass < handle
    properties
       rightSensorValue;                                                  %sets variables for different power settings
       leftSensorValue;    
       rightLightSensor;
       leftLightSensor;
       leftBlackThreshold;
       rightBlackThreshold;
    end
    methods(Static)
        function init(obj)
            OpenLight(obj.leftLightSensor,'ACTIVE');                                           %opens both light sensors, puts them into active mode
            OpenLight(obj.rightLightSensor,'ACTIVE');
        end
    end
    methods
        function calibrate ( obj , wheels )
            Disp('Calibrating: LightSensors \n');
            numberOfChecks = 0;
            timeout = 0.1;
            minLeftSensor = 9999;
            minRightSensor = 9999;
            thresholdDif = 100;
            wheels.turnLeftForward();
            while ( numberOfChecks < maxNumberOfChecks )
                sensorClass.getSensorData(obj);
                minLeftSensor = min( minLeftSensor, obj.leftSensorValue );
                minRightSensor = min( minRightSensor, obj.RightSensorValue );
                pause (timeout);
                numberOfChecks = numberOfChecks - 1; 
            end
            wheels.turnLeftBackwards();
            pause (timeout * maxNumberOfChecks);
            wheels.turnLeftBackwards();
            obj.leftBlackThreshold =  minLeftSensor + thresholdDif;
            obj.rightBlackThreshold =  minRightSensor + thresholdDif;
            Disp('Light sensors calibrated succesfully  \n');
        end    
        function obj = getSensorData(obj)
            obj.rightSensorValue = GetLight(obj.rightLightSensor);                                          %and the light values of both sensors being collected
            obj.leftSensorValue = GetLight(obj.leftLightSensor);
        end
        function result = toMoveForward(obj)
            result = false;
            if ( obj.rightSensorValue > obj.leftBlackThreshold && obj.leftSensorValue > obj.rightBlackThreshold )
                result = true;
            end
            return;
        end
        function result = toTurnLeft(obj)
            result = false;
            if ( obj.rightSensorValue < obj.leftBlackThreshold && obj.leftSensorValue > obj.rightBlackThreshold )
                result = true;
            end
            return;
        end
        function result = toTurnRight(obj)
            result = false;
            if ( obj.rightSensorValue > obj.leftBlackThreshold && obj.leftSensorValue < obj.rightBlackThreshold )
                result = true;
            end
            return;
        end
        function result = isBlack(obj)
            result = false;
            if ( obj.rightSensorValue < obj.leftBlackThreshold || obj.leftSensorValue < obj.rightBlackThreshold )
                result = true;
            end
            return;
        end

    end
end