% Takes in current time and user parameters, returns displacement (from
% initial position) vector [x, y, z, time_remaining] in meters and seconds.
function path = path(time, user_parameters)

% TEMPLATE CODE BELOW, IGNORE THE DETAILS

% You can use this function to calculate the desired position
% as a function of time - you can do more sophisticated calculations
% as well, of course.
%
% To do a simple path you can enter a set of waypoints
% where you would like the quadcopter to be at a set of different
% times, and then interpolate between them.

% Table of time values
times = [0,5,10,20,25];
% Table of waypoints - these are the positions, relative to the
% initial position of the quadcopter, of several points on the path.
% eg at time t=0 the relative position is (0,0,0)
%    at time t=5s the relative position is (0,0,0.4)
%    and so on....
waypoint_relative_positions = [0.,0.,0.;...
                               0.,0,0.4;...
                              0.0,-0.3,0.4;...
                              0.0,-0.3,0.4;...
                              0.0,-0.3,-0.5];
% Defines a smooth path by interpolating between the waypoints
% Check the matlab manual for how the interp1 function works
if (time<25)
   relative_position = interp1(times,waypoint_relative_positions,time);
else
   relative_position = waypoint_relative_positions(end,1:3);
end

% Make the output a column vector.
% Note that we need to specify the desired position in absolute
% coords relative to the kinect, so we add the initial position
% of the quadcopter.
%
desired_position = initial_position + transpose(relative_position);


end
