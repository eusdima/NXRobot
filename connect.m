COM_CloseNXT('all');                                    %safe to close all previous open connections
close all;
h = COM_OpenNXT();                                      %opens a new connection to the robot via USB
COM_SetDefaultNXT(h);      