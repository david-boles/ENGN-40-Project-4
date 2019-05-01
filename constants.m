classdef constants
    properties (Constant = true)
        G = 9.81;
        CAM_UNITS_TO_M = [1, 1, 1];
        MASS_KG = 0.038;
        THRUST_UNITS_TO_N = 7.923*(10^(-6));
        TAKEOFF_TIME_S = 0.001;
        PATTERN_TIME_S = 20;
        LANDING_TIME_S = 0.001;
        PATTERN_START_HEIGHT_M = 0;
        MIN_THRUST_N = 0;
        MAX_THRUST_N = 60000*constants.THRUST_UNITS_TO_N;
        Kpx = 2.5;
        Kpy = 0;
        Kpz = 2.5;
        Kdx = 0;
        Kdy = 0;
        Kdz = 2.5;
        Kix = 0;
        Kiy = 0;
        Kiz = 0.5;
        Kpyaw = 0;
        Kdyaw = 0;
        Kiyaw = 0;
        SIM_DERIV_DT = 0.0001;
    end
end
