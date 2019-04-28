function [controls,flightTimeRemaining,OUTOFFRAME,FAIL ] = controller(time,dtime,INITIALIZING,...
                       vbat,orientation,acceleration,...
                       datafile_path,user_parameters, ...
                       filter_vals,filter_wins,n_tracked_colors)
%   Feedback controller function for crazyflie 2
%
%   Input arguments
%      orientation:     Vector specifying (roll,pitch,yaw) in degrees
%                       The roll and pitch are zero unless the user%
%                       selects the checkbox in the flight manager
%                       GUI to record gyro data.
%      acceleration:    Vector specifying (aL,aT,aN) in g (includes
%                       gravity). These are zero unless the user
%                       selects the checkbox in the flight manager
%                       GUI to record accelerations.
%      vbat:            Battery voltage, in Volts (from onboard sensor)
%      time:            Total elapsed time since start of flight (s)
%      dtime:           Time increment since controller was last called
%      INITIALIZING:    If this is set to 1, the motor is not yet turned on.
%                       You can use this to initialize variables.
%                       Both time and dtime are zero while initializing.
%      datafile_path    User-selected path for output data file
%      user_parameters  A character string containing data entered by
%                       the user into the GUI managing the flight.
%                       You can use data = strsplit(user_parameters,',')
%                       to extract a comma separated list into a list
%                       of strings.
%                       You can use value = str2num(data(i)) to convert
%                       the ith entry into a number, if you need to
%                       pass numerical data to your code.
%      filter_vals      Matrix of RGB color values for all tracked objects
%      filter_wins      Matrix of RGB color windows for detecting tracked objects
%                       A pixel is assumed to be part of the kth tracked object if it
%                       has RGB values
%                       filter_vals(1,k)-filter_wins(1,k) < R < filter_vals(1,k)+filter_wins(1,k)
%                       filter_vals(2,k)-filter_wins(2,k) < G < filter_vals(2,k)+filter_wins(2,k)
%                       filter_vals(3,k)-filter_wins(3,k) < R < filter_vals(3,k)+filter_wins(3,k)
%     n_tracked_objects No. objects to be tracked
%                       By default, a single blue object is tracked. You can choose to track additional
%                       objects using the 'preview kinect image' button in the python controller GUI
%                       then click the 'Filtered Color Image' in the MATLAB window, then click 'add object'
%                       and follow the instructions
%%
%   Output arguments
%      controls: [thrust,roll,pitch,yawrate]
%                       Thrust is a number from 0 to 60000
%                       roll, pitch, are in degrees
%                       yawrate is in degrees per second
%      flightTimeRemaining  Time left to end of flight
%      FAIL: Set to 0 if the position of the quadcopter was determined
%            correctly
%            Set to 1 if quadcopter not detected - this will 
%            cause the client to ramp down the motors and disconnect.
%      OUTOFFRAME: Set to 0 if position is inside depth image
%                  Set to 1 if quadcopter is about to fly out of frame.
%                  This causes the client to ramp down the motors and
%                  hopefully land the quadcopter safely.
%
%   The variables below are 'persistent' - MATLAB stores their values
%   if they are updated in this function and remembers them the
%   next time the function is called.
%
    persistent output_file;
    persistent format_string;
    persistent n_printed_variables;
    persistent integrated_error;  % This is the error for the PID controller - you must update it
    persistent initial_position;  
    
%
%%  CONTROLLER PARAMETERS (fill these in from your design calculations)
%
%    tau0 = ???   Motor thrust offset
%    KPz = ???;   KIz = ???;    KDz = ???;   %PID for thrust
%    KPxy = ???;  KIxy = ???;   KDxy = ???; %PID for roll and pitch
%    KPyaw = ???;  % Feedback gain for yaw 
    

    flight_time = 25;  % Total time of flight - change this as needed
%
    flightTimeRemaining = flight_time-time; % This is an output argument - flight time is displayed on GUI
 %%
 %  The 'getKinectCoords' function measures coords of multiple tracked objects.  The function is already installed in the computers in 096
 %
    [position_all,velocity_all,OUTOFFRAME_all,FAIL_all] = getKinectCoords( filter_vals,filter_wins,n_tracked_colors,dtime );
    controls = [0.,0.,0.,0.];

%   The output arguments from getKinectCoords contain data for all tracked objects:
%           position_all      Positions:  position_all(i,k) is the ith coord for kth tracked object 
%           velocity_all      Velocities: velocity_all(i,k) is the ith velocity component for kth tracked object
%           OUTOFFRAME_all    OUTOFFRAME_all(k) set to 0 if kth object is inside tracking frame, 1 otherwise
%           FAIL_all          FAIL_all(k) set to 0 if kth object was detected successfully, 1 otherwise
%                      
%   The lines below assume that the quadcopter is the first tracked object.    
    FAIL = FAIL_all(1);             
    OUTOFFRAME = OUTOFFRAME_all(1); 
    pos_quad = position_all(:,1);   % Position of quadcopter is a column vector [x;y;z]
    vel_quad = velocity_all(:,1);   % Veloocity of quadcopter is a column vector [vx;vy;vz]
%   If you track more objects you can extract their positions, eg, with
%   pos_ball = position_all(:,2);
%   vel_ball = velocity_all(:,2);
%
%    
    if (FAIL>0.5) return; end         % Exit if the kinect can't find the quadcopter
    if (OUTOFFRAME>0.5) return; end   % Exit if the quadcopter left the tracking frame 


    
    if (flightTimeRemaining<0)
        FAIL=1;    % Activates the crash-land sequence if the clock ran out
        return
    end
       
    if (INITIALIZING>0.5)   % We evaluate this block while initializing
       if (isempty(output_file))   % This opens a csv file for printing
         output_filename = strcat(datafile_path,'\flight_data.csv');
         output_file = fopen(output_filename,'w');
       end
       if isempty(format_string)
          n_printed_variables = 21;  % This is the # of variables printed to the .csv file 
          format_string = '%12.8f';
          for i=1:n_printed_variables-1
              format_string = strcat(format_string,', %12.8f');
          end
          format_string = strcat(format_string,'\n');
       end
       integrated_error = zeros(3,1); % Error is zero at time t=0.  This is a column vector (like position and velocity)
       initial_position = pos_quad; % Useful to store the initial position of the quadcopter.
       
%      You can add additional initialization calculations here - for example, if you are programming
%      a flight that follows some stationary colored balls you can read their positions here with the
%      getKinectCoords function and store them in persistent variables.   
%      You can then speed up the code a bit by using getKinectCoords to track only the moving quadcopter
%      during flight
       
       return;  % This exits the function
    end
 
 %  In the rest of this code you should:
 %     1. Compute the desired position of the quadcopter at the current
 %     time instant (you could use the function provided below for your
 %     first flight, but you will probably want to do something more fancy)
 %     2. Update the integrated error variable
 %     3. Use the PID equations (see the project description)
 %        to calculate the thrust, roll, pitch and yaw rate to be sent
 %        to the quadcopter.
 %        Don't forget that the orientation variable is in degrees, and
 %        you need to send roll and pitch in degrees, and 
 %        yaw rate to degrees per second.
 
    controls = [thrust,roll,pitch,yawrate];

% Print data to the log file - you can add or remove variables as you wish....
    fprintf(output_file,format_string,time,desired_position(1:3),pos_quad(1:3),vel_quad(1:3),...
           acceleration(1:3),orientation(1:3),vbat,thrust,roll,pitch,yawrate);
%
% Before your first flight you should write a separate code that will read
% the csv file and plot at least the desired position as a function of time
% We will use this to test your code during the flight.
% 
    
end
%%

