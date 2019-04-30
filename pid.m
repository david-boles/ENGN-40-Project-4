% Takes current and target position ([x, y, z] in meters) and current and
% target yaw (in radians) and returns desired linear acceleration and yaw velocity
% ([a_x, a_y, a_z, omega_psi] in m/s^2 and rad/s)
function [a_x, a_y, a_z, omega_psi] = pid(position, target_position, yaw, target_yaw, dtime)
x = position(1);
y = position(2);
z = position(3);

xstar = target_position(1);
ystar = target_position(2);
zstar = target_position(3);



r_x = xstar-x;
r_y = ystar-y;
r_z = zstar-z;

a_x = 2*r_x./dtime^2;
a_y = 2*r_y./dtime^2;
a_z = 2*r_z./dtime^2;

angle = target_yaw - yaw;
omega_psi = angle/dtime;

end
