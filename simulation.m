function simulation
close all;
% function to calculate position (x,y,z), veloctiy
m=constants.MASS_KG;
%Beta=7.923*10^-6; %Newtons
g=constants.G; %Newtons
initial_w=[0,0,0,0,0,0,0,0,0,0]; %[x,y,z,yaw,vx,vy,vz,ex,ey,ez]

time_range=[0,30];

[t_values,sol_values] = ode45(@(t,w) diff_eq(t,w,m,g),time_range,initial_w);
figure
plot(t_values,sol_values(:,[1 5 8]),"LineWidth",2);
title("x values");
legend("x","vx","ex");

figure
plot(t_values,sol_values(:,[2 6 9]),"LineWidth",2);
title("y values");
legend("y","vy","ey");

figure
plot(t_values,sol_values(:,[3 7 10]),"LineWidth",2);
title("z values");
legend("z","vz","ez");

figure
plot(t_values,sol_values(:,4),"LineWidth",2);
title("yaw values");
legend("yaw");

end

function dwdt=diff_eq(t,w,m,g)

[xstar,ystar,zstar,yawstar]=path(t);

%terms from w
x=w(1);
y=w(2);
z=w(3);
yaw=w(4);
vx=w(5);
vy=w(6);
vz=w(7);
ex=w(8);
ey=w(9);
ez=w(10);

xerror = xstar - x;
yerror = ystar - y;
zerror = zstar - z;
yawerror = yawstar - yaw;

[xstarold,ystarold,zstarold,yawstarold]=path(t-constants.SIM_DERIV_DT);
dxstardt=(xstar-xstarold)/constants.SIM_DERIV_DT;
dystardt=(ystar-ystarold)/constants.SIM_DERIV_DT;
dzstardt=(zstar-zstarold)/constants.SIM_DERIV_DT;

dxerrordt=dxstardt-vx;
dyerrordt=dystardt-vy;
dzerrordt=dzstardt-vz;


[tau,theta,phi,omega_psi]=controller_core(yaw, [xerror,yerror,zerror],...
    [dxerrordt,dyerrordt,dzerrordt],[ex,ey,ez], yawerror);

if t >= 0.2
    disp('BAHAHAS');
end

%equations
dxdt=vx;
dydt=vy;
dzdt=vz;
dyawdt=omega_psi;
dvxdt=(sin(theta)*sin(yaw)+cos(theta)*sin(phi)*cos(yaw))*tau/m;
dvydt=(cos(theta)*sin(phi)*sin(yaw)-sin(theta)*cos(yaw))*tau/m;
dvzdt=(cos(theta)*cos(phi)*tau/m)-g;

dwdt=[dxdt;dydt;dzdt;dyawdt;dvxdt;dvydt;dvzdt;xerror;yerror;zerror];
end