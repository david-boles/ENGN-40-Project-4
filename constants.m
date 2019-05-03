classdef constants
    properties (Constant = true)
        G = 9.81;
        CAM_UNITS_TO_M = [1, 1, 1];
        MASS_KG = 0.038;
        THRUST_UNITS_TO_N = 7.923*(10^(-6));
        TAKEOFF_TIME_S = 5;
        PATTERN_TIME_S = 20;
        LANDING_TIME_S = 5;
        PATTERN_START_HEIGHT_M = 0.4;
        MIN_THRUST_N = 0;
        MAX_THRUST_N = 60000*constants.THRUST_UNITS_TO_N;
        Kpx = 5;
        Kpy = 5;
        Kpz = 2.5;
        Kdx = 3;
        Kdy = 3;
        Kdz = 8;
        Kix = 0;
        Kiy = 0;
        Kiz = 0;
        Kpyaw = 1;
        Kdyaw = 2;
        Kiyaw = 0.20;
        SIM_DERIV_DT = 0.0001;
    end
end
