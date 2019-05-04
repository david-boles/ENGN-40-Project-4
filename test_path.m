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
        [x, y, z, psi] = pattern((time - constants.TAKEOFF_TIME_S) * (1/constants.PATTERN_TIME_S), user_parameters);
        z = z + constants.PATTERN_START_HEIGHT_M;
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
function [x, y, z, psi] = pattern(p_time, user_parameters)
    if p_time < 0.1
        x = 0;
        y = 0;
        z = 0;
        psi = 0;
    elseif p_time < 0.2
        x = 0.5;
        y = 0;
        z = 0;
        psi = 0;
    elseif p_time < 0.3
        x = 0;
        y = 0;
        z = 0;
        psi = 0;
    elseif p_time < 0.4
        x = 0;
        y = 0.5;
        z = 0;
        psi = 0;
    elseif p_time < 0.5
        x = 0;
        y = 0;
        z = 0;
        psi = 0;
    elseif p_time < 0.6
        x = 0;
        y = 0;
        z = 0.5;
        psi = 0;
    elseif p_time < 0.7
        x = 0;
        y = 0;
        z = 0;
        psi = 0;
    elseif p_time < 0.8
        x = 0;
        y = 0;
        z = 0;
        psi = pi/2;
    else
        x = 0;
        y = 0;
        z = 0;
        psi = 0;
    end
end
