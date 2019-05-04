while true
    

    filename = input('Log file path: ', 's');

    if isempty(filename)
        filename = '\\files.brown.edu\Home\dboles\Desktop\flight_data.csv';
    end
    M = csvread(filename, 1, 0);
    
    %{
    dtime = M(1, :);
    time = M(2, :);
    flightTimeRemaining = M(3, :);
    acceleration = M(4:6, :);
    orientation = M(7:9, :);
    quad_pos = M(10:12, :);
    path_pos = M(13:15, :);
    path_psi = M(16, :);
	omega_psi = M(17, :);
    controls = M(18:21, :);
    v_bat = M(22, :);
    user_parameters = M(23, :);
    %}
    
    dtime = M(:, 1);
    time = M(:, 2);
    flightTimeRemaining = M(:, 3);
    acceleration = M(:, 4:6);
    orientation = M(:, 7:9);
    quad_pos = M(:, 10:12);
    path_pos = M(:, 13:15);
    path_psi = M(:, 16);
	omega_psi = M(:, 17);
    controls = M(:, 18:21);
    v_bat = M(:, 22);
    path_psi = M(:, 23);
    error_psi = M(:, 24);
    
    close all;
    
    figure;
    plot(time, dtime);
    title('Time step length vs time');
    
    figure;
    plot(time, acceleration(:, 1), time, acceleration(:, 2), time, acceleration(:, 3));
    title('Measured acceleration vs time');
    legend('aL','aT','aN');
    
    figure;
    plot(time, orientation(:, 1), time, orientation(:, 2), time, orientation(:, 3));
    title('Measured orientation vs time');
    legend('roll', 'pitch', 'yaw');
    
    figure;
    plot(time, quad_pos(:, 1), time, path_pos(:, 1));
    title('x position vs time');
    legend('measured', 'target');
    
    figure;
    plot(time, quad_pos(:, 2), time, path_pos(:, 2));
    title('y position vs time');
    legend('measured', 'target');
    
    figure;
    plot(time, quad_pos(:, 3), time, path_pos(:, 3));
    title('z position vs time');
    legend('measured', 'target');
    
    figure;
    plot(time, path_psi, time, orientation(:, 3) * (pi/180), time, error_psi, time, omega_psi);
    title('Psi');
    legend('target', 'quad', 'error', 'omega');
    
    % Can add the rest if needed...
end