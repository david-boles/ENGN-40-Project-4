% Gets position as [x, y, z] in meters, and returns getKinectCoords's OUTOFFRAME_all and FAIL_all
function [quad_pos,OUTOFFRAME_all,FAIL_all] = get_quad_pos( filter_vals,filter_wins,n_tracked_colors,dtime)
    [position_all,~,OUTOFFRAME_all,FAIL_all] = getKinectCoords( filter_vals,filter_wins,n_tracked_colors,dtime );
    cam_pos = position_all(:,1); % Position of quadcopter in camera units as a column vector [x;y;z]
    quad_pos = transpose(cam_pos) .* constants.CAM_UNITS_TO_M; % Position of quadcopter in meters as a row vector [x, y, z]
end