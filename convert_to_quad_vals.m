% Takes in acceleration ([x, y, z] in m/s^2) and current yaw (radians),
% assuming frame of reference is in relation to the  room/camera
% assuming aerospace convention for calculation of yaw compnesation, roll,
% and pitch
% assuming gravity unaccounted for in provided acceleration
% returns desired thrust (newtons), pitch, and roll (radians).

function [thrust, pitch, roll] = convert_to_quad_vals(acceleration, yaw)
    acceleration=transpose(acceleration);
    m = constants.MASS_KG; 
    g = constants.G;
    if norm(acceleration)
        thrust_accel = (acceleration + [0, 0, g]);
        unit_thrust_a = thrust_accel ./ norm(acceleration);
        pitch = -atan2d(-unit_thrust_a(1), unit_thrust_a(3));
        roll = atan2d(-unit_thrust_a(2), unit_thrust_a(3));
        thrust = norm(thrust_accel) * m;
    else
        thrust = m*g;
        pitch = 0;
        roll = 0;
    end
end