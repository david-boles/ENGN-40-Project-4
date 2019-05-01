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

ex = ex +(xstar-x)*dtime;
ey = ey +(ystar-y)*dtime;
ez = ez +(zstar-z)*dtime;

a_x = Kpx*(xstar-x) + (Kdx*(xstar-x))/dtime + Kix*ex;
a_y = Kpy*(ystar-y) + (Kdy*(ystar-y))/dtime + Kiy*ey;
a_z = Kpz*(zstar-z) + (Kdz*(zstar-z))/dtime + Kiz*ez;

omega_psi = Kpyaw*(target_yaw - yaw);

end
