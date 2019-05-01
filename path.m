% Takes in current time and user parameters, returns displacement (from
% initial position) vector [x, y, z, psi, time_remaining] in meters and seconds.
% THIS FUNCTION MAY BE CALLED WITH NON-STRICTLY INCREASING TIMES
function [x, y, z, psi, time_remaining] = path(time, user_parameters)
    time_remaining = constants.TAKEOFF_TIME_S + constants.PATTERN_TIME_S + constants.LANDING_TIME_S - time;

    if time < constants.TAKEOFF_TIME_S
        x = 0;
        y = 0;
        z = time * (constants.PATTERN_START_HEIGHT_M / constants.TAKEOFF_TIME_S);
        psi = 0;
    elseif time < (constants.TAKEOFF_TIME_S + constants.PATTERN_TIME_S)
        [x, y, z, psi] = pattern((time - constants.TAKEOFF_TIME_S) * (1/constants.PATTERN_TIME_S));
    elseif time < (constants.TAKEOFF_TIME_S + constants.PATTERN_TIME_S + constants.LANDING_TIME_S)
        x = 0;
        y = 0;
        z = constants.PATTERN_START_HEIGHT_M - ...
            ((time - constants.TAKEOFF_TIME_S - constants.PATTERN_TIME_S) *...
            (constants.PATTERN_START_HEIGHT_M / constants.LANDING_TIME_S));
        psi = 0;
    else
        x = 0;
        y = 0;
        z = 0;
        psi = 0;
    end
end

% Pattern function, starting and ending (p_time = 0 or 1) at [0, 0, 0, 0]
function [x, y, z, psi] = mypattern(p_time)
times = [0,0.2,0.4,0.8,1];

waypoint_relative_positions = [0.,0.,0.,0.;...
                               0.,0,0.9,0.;...
                              0.0,-0.3,0.9,0.;...
                              0.0,-0.3,0.9,0.;...
                              0.0,-0.3,0.3,0.];
                          
if p_time < 1
    relative_position = interp1(times,waypoint_relative_positions,p_time);
else
    relative_position = waypoint_relative_positions(end,1:3);
end

x = relative_position(1);
y = relative_position(2);
z = relative_position(3);
psi = 0;

end
