% Based on current psi, error ([x, y, z, psi] in m or radians), error
% derivative, and error integral, calculates thrust in newtons,
% roll and pitch in radians, and yaw acceleration in rad/s^2
function [thrust, roll, pitch, a_psi] = controller_core(psi, error, error_derivative, error_integral)
    disp(psi, error, error_derivative, error_integral)
    [a_x, a_y, a_z, a_psi] = quad_pid(error, error_derivative, error_integral)
    [thrust, pitch, roll] = convert_to_quad_vals([a_x, a_y, a_z],psi)
    thrust = min(max(thrust, constants.MIN_THRUST_N), constants.MAX_THRUST_N);
end