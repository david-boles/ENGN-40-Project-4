classdef constants
    properties (Constant = true)
        G = 9.81;
        CAM_UNITS_TO_M = [1, 1, 1];
        MASS_KG = 0.038;
        THRUST_UNITS_TO_N = 7.923*(10^(-6));
        TAKEOFF_TIME_S = 5;
        PATTERN_TIME_S = 100;
        LANDING_TIME_S = 5;
        PATTERN_START_HEIGHT_M = 0.5;
        MIN_THRUST_N = 0;
        MAX_THRUST_N = 60000*constants.THRUST_UNITS_TO_N;
        Kpx = 4.386;
        Kpy = 4.386;
        Kpz = 2.47;
        Kdx = 2.75;
        Kdy = 2.75;
        Kdz = 2.51;
        Kix = 1.3;
        Kiy = 1.3;
        Kiz = 0.5;
        Kpyaw = 1.5;
        SIM_DERIV_DT = 0.0001;
    end
end
