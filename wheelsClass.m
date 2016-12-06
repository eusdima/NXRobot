classdef wheelsClass < handle
    properties
       leftMotorFullPower;                                                  %sets variables for different power settings
       rightMotorFullPower;                                                  
       leftMotorTurnPower;                                                  
       rightMotorTurnPower; 
       noPower;
       rightWheel;                                                  %specifies which motor is connected to which wheel
       leftWheel;
       actualSpeedLeft=0;
       actualSpeedRight=0;
       bothWheels = [rightWheel; leftWheel];  
    end
    methods(Static)
        function sendPower(obj)
            NXTMotor(obj.rightWheel, 'Power', obj.actualSpeedLeft).SendToNXT();    
            NXTMotor(obj.obj.leftWheel, 'Power', obj.actualSpeedRight).SendToNXT()            
        end
    end
    methods
        function calibrate(obj, lightSensor)
            Disp('Calibrating: wheels \n');
            Disp('Let the robot follow a straight line \n');
            %init the calibration 
            timeout = 0.1 ;
            speedStep = 2;
            maxNumberOfChecks = 10;
            notCalibrated = true ;
            wheelsClass.brake(obj);
            while ( notCalibrated )
                numberOfChecks = 0;
                wheelsClass.moveForward(obj);
                notCalibrated = false;
                while ( numberOfChecks < maxNumberOfChecks )
                    lightSensor.getSensorData();
                    if ( lightsensor.toTurnLeft( ))  
                        notCalibrated = true ;
                        
                        Disp('Going back to the starting point \n'); 
                        wheelsClass.moveBackwards(obj);
                        pause(timeout * numberOfChecks);
                        
                        obj.leftMotorFullPower = obj.leftMotorFullPower + speedStep;
                        Disp('Increasing the left motor speed \n');
                        break;
                    end
                    if ( lightsensor.toTurnRight( ))  
                        notCalibrated = true ;
                        
                        Disp('Going back to the starting point \n');
                        wheelsClass.moveBackwards(obj);
                        pause(timeout * numberOfChecks);
                        
                        obj.rightMotorFullPower = obj.rightMotorFullPower + speedStep;
                         Disp('Decreasing the left motor speed \n');
                        break;
                    end
                    pause (timeout);
                    numberOfChecks = numberOfChecks - 1; 
                    Disp('Wheels calibrated succesfully \n');
                end    
            end
        end
        function obj = moveForward(obj)
            obj.actualSpeedLeft = obj.leftMotorFullPower;
            obj.actualSpeedRight = obj.rightMotorFullPower;
            wheelsClass.sendPower(obj);
        end
        function obj = moveBackwards(obj)
            obj.actualSpeedLeft = -obj.leftMotorFullPower;
            obj.actualSpeedRight = -obj.rightMotorFullPower;
            wheelsClass.sendPower(obj);
        end
        
        function obj = turnLeftForward(obj)
            obj.actualSpeedLeft = obj.leftMotorTurnPower;
            obj.actualSpeedRight = obj.noPower;
            wheelsClass.sendPower(obj);
        end
        function obj = turnRightForward(obj)
            obj.actualSpeedLeft = obj.noPower;
            obj.actualSpeedRight = obj.rightMotorTurnPower;
            wheelsClass.sendPower(obj);
        end
        %Have negative power for rewinding 
        function obj = turnLeftRewind(obj)
            obj.actualSpeedLeft = -obj.leftMotorTurnPower;
            obj.actualSpeedRight = obj.noPower;
            wheelsClass.sendPower(obj);
        end
        function obj = turnRightRewind(obj)
            obj.actualSpeedLeft = obj.noPower;
            obj.actualSpeedRight = -obj.rightMotorTurnPower;
            wheelsClass.sendPower(obj);
        end
        function obj = moveForwardSlowly(obj)
            obj.actualSpeedLeft = obj.leftMotorTurnPower;
            obj.actualSpeedRight = obj.rightMotorTurnPower;
            wheelsClass.sendPower(obj);
        end
        function obj = brake(obj)
            obj.actualSpeedLeft = obj.noPower;
            obj.actualSpeedRight = obj.noPower;
            NXTMotor(obj.bothWheels, 'Power', obj.noPower).Stop('brake'); 
        end
        function speed = getSpeed(obj)
            speed={ obj.actualSpeedLeft, obj.actualSpeedRight };
            return;
        end
        function obj = setSpeed(obj, valueX, valueY)
            obj.actualSpeedLeft = valueX;
            obj.actualSpeedRight = valueY;
            wheelsClass.sendPower(obj);
        end
    end
end