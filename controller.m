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
%
%   Output arguments
%      controls: [thrust,roll,pitch,yawrate]
%                       Thrust is a number from 0 to 60000
%                       roll, pitch, are in degrees
%                       yawrate is in degrees per second
%      flightTimeRemaining  Time left to end of flight
%      FAIL: Set to 0 if the position of the quadcopter was determined
%            correctly
%            Set to 1 if quadcopter not detected - this will 
%            cause the client to ramp down the motors and isconnect.
%      OUTOFFRAME: Set to 0 if position is inside depth image
%                  Set to 1 if quadcopter is about to fly out of frame.
%                  This causes the client to ramp down the motors and
%                  hopefully land the quadcopter safely.
    
function [controls,flightTimeRemaining,OUTOFFRAME,FAIL ] = controller(time,dtime,INITIALIZING,...
                       vbat,orientation,acceleration,...
                       datafile_path,user_parameters, ...
                       filter_vals,filter_wins,n_tracked_colors)
    
    persistent output_file;
    persistent format_string;
    persistent n_printed_variables;
    persistent initial_position;
    persistent last_errors;
    persistent error_integrals;
    persistent last_omega_psi;
    
    if (INITIALIZING>0.5)   % We evaluate this block while initializing
       if (isempty(output_file))   % This opens a csv file for printing
         output_filename = strcat(datafile_path,'\flight_data.csv');
         output_file = fopen(output_filename,'w');
       end
       
       if isempty(format_string)
          n_printed_variables = 23;  % This is the # of variables printed to the .csv file 
          format_string = '%12.8f';
          for i=1:n_printed_variables-1
              format_string = strcat(format_string,', %12.8f');
          end
          format_string = strcat(format_string,'\n');
       end
       
       initial_position = get_quad_pos( filter_vals,filter_wins,n_tracked_colors,dtime );
       
       if isempty(last_errors)
          last_errors = [0, 0, 0, 0];
       end
       
       if isempty(error_integrals)
          error_integrals = [0, 0, 0, 0];
       end
       
       if isempty(last_omega_psi)
           last_omega_psi = 0;
       end
       
       fprintf(output_file,strcat( ...
            'dtime, time, flightTimeRemaining, ' , ...
            'acceleration, acceleration(2), acceleration(3), ' , ...
            'orientation(1), orientation(2), orientation(3), ' , ...
            'quad_pos(1), quad_pos(2), quad_pos(3), ' , ...
            'path_pos(1), path_pos(2), path_pos(3), ' , ...
            'path_psi, ' , ...
            'omega_psi, ' , ...
            'controls(1), controls(2), controls(3), controls(4), ' , ...
            'vbat, ' , ...
            'user_parameters' , ...
            '\n'));
       controls = [0, 0, 0, 0];
       flightTimeRemaining = 30;
       OUTOFFRAME = 0;
       FAIL = 0;
        return;  % This exits the function imeediately on completion of initialization.
    else
    
        [quad_pos,OUTOFFRAME_all,FAIL_all] = get_quad_pos( filter_vals,filter_wins,n_tracked_colors,dtime );
        disp('init pos');
        disp(initial_position);
        disp('quad_pos:');
        disp(quad_pos);
        disp('=========');
        FAIL = FAIL_all(1);             
        OUTOFFRAME = OUTOFFRAME_all(1);

        if (FAIL>0.5) return; end         % Exit if the kinect can't find the quadcopter
        if (OUTOFFRAME>0.5) return; end   % Exit if the quadcopter left the tracking frame 

        [path_x, path_y, path_z, path_psi, flightTimeRemaining] = path(time, user_parameters);
        path_pos = [path_x, path_y, path_z] + initial_position; % Target position of the quadcopter in meters as a row vector [x, y, z]

        if (flightTimeRemaining<0)
            FAIL=1;    % Activates the crash-land sequence if the clock ran out
            return
        end

        quad_psi = orientation(3) * (pi / 180);
        
        errors = [path_pos, path_psi] - [quad_pos, quad_psi];
        
        if dtime == 0
            d_errors_dt = [0,0,0,0];
        else
            d_errors_dt = (errors - last_errors) / dtime;
        end
        
        

        % Compute controller results
        [thrust, roll, pitch, a_psi] = controller_core(quad_psi, errors, d_errors_dt, error_integrals);
        
        % Compute omega psi
        omega_psi = last_omega_psi + (a_psi * dtime);
        
        controls = [thrust * (1/constants.THRUST_UNITS_TO_N), roll * (180 / pi), pitch * (180 / pi), omega_psi * (180 / pi)];
        
        % Print data to the log file - if changed, also edit above header
        % printing
        % and the plot_data function
        fprintf(output_file, format_string, ...
            dtime, time, flightTimeRemaining, ...
            acceleration(1), acceleration(2), acceleration(3), ...
            orientation(1), orientation(2), orientation(3), ...
            quad_pos(1), quad_pos(2), quad_pos(3), ...
            path_pos(1), path_pos(2), path_pos(3), ...
            path_psi, ...
            omega_psi, ...
            controls(1), controls(2), controls(3), controls(4), ...
            vbat, ...
            user_parameters);

        % Update persistent variables
        last_errors = errors;
        error_integrals = error_integrals + (errors * dtime);
        last_omega_psi = omega_psi;
    end
    
end

