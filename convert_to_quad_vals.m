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

        % Rotation matrix to rotate coordinate space to match quadcopter
        % This allows us to continue calculations as if yaw=0
        R = [cos(yaw), sin(yaw), 0; -sin(yaw), cos(yaw), 0; 0, 0, 1];
        a_rotated = R*acceleration;

        % Compute acceleration caused by applied thrust to compensante for gravity (we still want to be in the air!!)
        
        a_desired = a_rotated + [0; 0; g];

        is_nose_diving = a_desired(3) < 0;

        % check if force applied is heading downward - if so, we'll be
        % computing negative thrust to avoid nose-diving
        % here we reverse vector direction
        if is_nose_diving
            a_desired = -a_desired;
        end

        % calculate norm for thrust acceleration
        norm_a = norm(a_desired);


        % calculating pitch and roll (in that order)
        a_nose_proj = [a_desired(1), 0, a_desired(3)];
        theta = acos(dot(a_nose_proj,[0,0,1])/norm(a_nose_proj));
        phi = acos(dot(a_nose_proj, a_desired)/(norm(a_nose_proj)*norm_a));

        % negative thrust correction (see lines 24-27)
        if is_nose_diving
            norm_a = -norm_a;
        end

        thrust=norm_a*m;
        pitch=theta;
        roll=phi;
    else
        thrust = m*g;
        pitch = 0;
        roll = 0;
    end
end