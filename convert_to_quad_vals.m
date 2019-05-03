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
        thrust_accel = [cos(yaw), sin(yaw), 0; -sin(yaw), cos(yaw), 0; 0, 0, 1] * (acceleration + [0; 0; g]);
        flip_fix = 1;
        if thrust_accel(3) < 0
            flip_fix = -1;
        end
        unit_thrust_a = flip_fix*thrust_accel ./ norm(acceleration);
        pitch = -atan2(-unit_thrust_a(1), unit_thrust_a(3));
        roll = atan2(-unit_thrust_a(2), unit_thrust_a(3));
        thrust = flip_fix*norm(thrust_accel)* m;
    else
        thrust = m*g;
        pitch = 0;
        roll = 0;
    end
end