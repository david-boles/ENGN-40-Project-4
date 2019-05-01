function simulation
close all;
% function to calculate position (x,y,z), veloctiy
m=constants.MASS_KG;
%Beta=7.923*10^-6; %Newtons
g=constants.G; %Newtons
initial_w=[0,0,0,0,0,0,0,0,0,0,0,0]; %[x,y,z,yaw,vx,vy,vz,omega_psi,ex,ey,ez,e_psi]

time_range=[0,16];

[t_values,sol_values] = ode45(@(t,w) diff_eq(t,w,m,g),time_range,initial_w);
figure
plot(t_values,sol_values(:,[1 5 9]),"LineWidth",2);
title("x values");
legend("x","vx","ex");

figure
plot(t_values,sol_values(:,[2 6 10]),"LineWidth",2);
title("y values");
legend("y","vy","ey");

figure
plot(t_values,sol_values(:,[3 7 11]),"LineWidth",2);
title("z values");
legend("z","vz","ez");

figure
plot(t_values,sol_values(:,[4 8 12]),"LineWidth",2);
title("yaw values");
legend("yaw","omega_psi","e_psi");

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
omega_psi=w(8);
ex=w(9);
ey=w(10);
ez=w(11);
e_psi=w(12);

xerror = xstar - x;
yerror = ystar - y;
zerror = zstar - z;
yawerror = yawstar - yaw;

[xstarold,ystarold,zstarold,yawstarold]=path(t-constants.SIM_DERIV_DT);
dxstardt=(xstar-xstarold)/constants.SIM_DERIV_DT;
dystardt=(ystar-ystarold)/constants.SIM_DERIV_DT;
dzstardt=(zstar-zstarold)/constants.SIM_DERIV_DT;
dyawstardt=(yawstar-yawstarold)/constants.SIM_DERIV_DT;

dxerrordt=dxstardt-vx;
dyerrordt=dystardt-vy;
dzerrordt=dzstardt-vz;
dyawerrordt=dyawstardt-omega_psi;

[tau,theta,phi,alpha_psi]=controller_core(yaw, [xerror,yerror,zerror,yawerror],...
    [dxerrordt,dyerrordt,dzerrordt,dyawerrordt],[ex,ey,ez,e_psi]);

%equations
dxdt=vx;
dydt=vy;
dzdt=vz;
dyawdt=omega_psi;
dvxdt=(sin(theta)*sin(yaw)+cos(theta)*sin(phi)*cos(yaw))*tau/m;
dvydt=(cos(theta)*sin(phi)*sin(yaw)-sin(theta)*cos(yaw))*tau/m;
dvzdt=cos(theta)*cos(phi)*tau/m-g;
domega_psidt=alpha_psi;

dwdt=[dxdt;dydt;dzdt;dyawdt;dvxdt;dvydt;dvzdt;domega_psidt;xerror;yerror;zerror;yawerror];
end