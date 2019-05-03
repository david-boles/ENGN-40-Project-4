% Based on current psi, error ([x, y, z] in m), error
% derivative, error integral, and psi error calculates thrust in newtons,
% roll and pitch in radians, and yaw velocity in rad/s
function [thrust, roll, pitch, omega_psi] = controller_core(psi, error, error_derivative, error_integral, error_psi)
    [a_x, a_y, a_z, omega_psi] = quad_pid(error, error_derivative, error_integral, error_psi);
    [thrust, pitch, roll] = convert_to_quad_vals([a_x, a_y, a_z],psi);
    thrust = min(max(thrust, constants.MIN_THRUST_N), constants.MAX_THRUST_N);
end