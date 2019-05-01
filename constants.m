classdef constants
    properties (Constant = true)
        CAM_UNITS_TO_M = [1, 1, 1];
        MASS_KG = 0.038;
        THRUST_UNITS_TO_N = 7.923*(10^(-6));
        TAKEOFF_TIME_S = 3;
        PATTERN_TIME_S = 10;
        LANDING_TIME_S = 3;
        PATTERN_START_HEIGHT_M = 0.5;
    end
end
