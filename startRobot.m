connect;                                                                %runs a script to setup the robot connection

rewind = rewindClass;
wheels = wheelsClass;
lightSensor = sensorClass;

framesPerSecond = 60;                                                   %number of frames per second 
timeout = 1 / framesPerSecond; 
backupTime = 5;
numberOfBackups =  uint8( backupTime / timeout );                                % backup each timeout ms -> 60 times per second 
lastmove.increment=50; %increment with 50ms 

wheels.rightWheel = MOTOR_A;                                                   %specifies which motor is connected to which wheel
wheels.leftWheel = MOTOR_C;

wheels.leftMotorFullPower = 50;                                                  %sets variables for different power settings
wheels.rightMotorFullPower = 50; 
wheels.leftMotorTurnPower = 30;                                                  
wheels.rightMotorTurnPower = 30; 
wheels.noPower = 0;

lightSensor.rightLightSensor = SENSOR_2;
lightSensor.leftLightSensor = SENSOR_3;
lightSensor.blackThreshold = 550; 
         
lightSensor.init();
lightSensor.calibrate(wheels);
wheels.calibrate(lightSensor);
moving = true;                                                          %sets a boolean for movement

while (moving)                                                          %starts the infinite while loop
    wheels.moveForward();                                               %with the robot moving forward
    lightsensor.getSensorData();
    
    if ( stopSign || redLight )
        wheels.brake();
        rewind.add(wheels.getSpeed( ));
        pause(timeout);
        continue;
    end
    if ( yellowLight )
        wheels.moveForwardSlowly();
        rewind.add(wheels.getSpeed( ));
        pause(timeout);
        continue;
    end
    if ( rewindSign )
        while ( rewind.canRewind( ))
            [X,Y] = rewind.pop();
            wheels.setSpeed(X,Y);
            pause(timeout);
        end
        continue;
    end
    
    if ( lightSensor.toMoveForward( ))                  
        wheels.moveForward();
        rewind.add(wheels.getSpeed( ));
        pause(timeout);
        continue;
    end
    if ( lightsensor.toTurnLeft( ))                
        wheels.turnLeftForward();                      
        rewind.add(wheels.getSpeed( ));
        pause(timeout);
        continue;
    end
    if ( lightsensor.toTurnRight( ))
        wheels.turnRightForward(); 
        rewind.add(wheels.getSpeed( ));
        pause(timeout);
        continue;
    end
end 