% Takes current error, derivative, and integral as [x, y, z, psi] with
% units of m, rad (/s or *s respectively), returns desired linear
% acceleration and yaw acceleration
% ([a_x, a_y, a_z, alpha_psi] in m/s^2 and rad/s^2)
function [a_x, a_y, a_z, alpha_psi] = quad_pid(error, error_derivative, error_integral)

error_x = error(1);
error_y = error(2);
error_z = error(3);
error_psi = error(4);

error_dx = error_derivative(1);
error_dy = error_derivative(2);
error_dz = error_derivative(3);
error_dpsi = error_derivative(4);

error_ix = error_integral(1);
error_iy = error_integral(2);
error_iz = error_integral(3);
error_ipsi = error_integral(4);

a_x = constants.Kpx*(error_x) + constants.Kdx*error_dx + constants.Kix*error_ix;
a_y = constants.Kpy*(error_y) + constants.Kdy*error_dy + constants.Kiy*error_iy;
a_z = constants.Kpz*(error_z) + constants.Kdz*error_dz + constants.Kiz*error_iz;

alpha_psi = constants.Kpyaw*(error_psi) + constants.Kdyaw*(error_dpsi) + constants.Kiyaw*(error_ipsi);

end
