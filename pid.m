% Takes current error, derivative, and integral as [x, y, z, psi] with
% units of m, rad (/s or *s respectively), returns desired linear
% acceleration and yaw velocity
% ([a_x, a_y, a_z, omega_psi] in m/s^2 and rad/s)
function [a_x, a_y, a_z, omega_psi] = pid(error, error_derivative, error_integral)

error_x = error(1);
error_y = error(2);
error_z = error(3);
error_psi = error(4);

error_dx = error_derivative(1);
error_dy = error_derivative(2);
error_dz = error_derivative(3);

error_ix = error_integral(1);
error_iy = error_integral(2);
error_iz = error_integral(3);

a_x = Kpx*(error_x) + Kdx*error_dx + Kix*error_ix;
a_y = Kpy*(error_y) + Kdy*error_dy + Kiy*error_iy;
a_z = Kpz*(error_z) + Kdz*error_dz + Kiz*error_iz;

omega_psi = Kpyaw*(error_psi);

end
