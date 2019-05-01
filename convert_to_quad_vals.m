% Takes in acceleration ([x, y, z] in m/s^2) and current yaw (radians),
% assuming frame of reference is in relation to the  room/camera
% assuming aerospace convention for calculation of yaw compnesation, roll,
% and pitch
% assuming gravity unaccounted for in provided acceleration
% returns desired thrust (newtons), pitch, and roll (radians).

function [thrust, pitch, roll] = convert_to_quad_vals(acceleration, yaw)
    mass = 5; %TODO: CHANGE TO CORRECT VALUE

    % Rotation matrix to rotate coordinate space to match quadcopter
    % This allows us to continue calculations as if yaw=0
    R = [0, -sin(-yaw), 0; sin(-yaw), cos(-yaw), -sin(-yaw); 0, 0, 1];
    a_rotated = R*acceleration;
    
    % Compensate for gravity (we still want to be in the air!!)
    g = 9.81;
    a_desired = a_rotated + [0, g, 0];
    
    % calculate accel norm for thrust
    norm_a = norm(a_desired);
    
    
    % calculating pitch and roll (in that order)
    a_nose_proj = [a_desired(1), 0, a_desired(3)];
    theta = acos(dot(a_nos_proj,[0,0,1])/norm(a_nose_proj);
    phi = acos(dot(a_nose_proj, a_desired)/(norm(a_nose_proj)*norm_a));
    
    [thrust, pitch, roll] = [norm_a*m, theta, phi];
    
  
end