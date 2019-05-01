function simulation_manual(tau,phi,theta,lambda)
% function to calculate position (x,y,z), veloctiy
m=38*10^-3; %kilograms
Beta=7.923*10^-6; %Newtons
g=9.81; %Newtons
initial_w=[0,0,0,0,0,0,0]; %[x,y,z,vx,vy,vz,yaw]

time_range=[0,50];

[t_values,sol_values] = odemanual(diff_eq(t,w,m,Beta,g,tau,phi,theta,lambda),...
    time_range,initial_w);
plot(t_values,sol_values);
legend;
end

function odemanual(diff_eq(t,w,m,Beta,g,tau,phi,theta,lambda),...
    time_range,initial_w)

W=

end

function dwdt=diff_eq(t,w,m,Beta,g,tau,phi,theta,lambda)
%terms from w
vx=w(4);
vy=w(5);
vz=w(6);
yaw=w(7);

%equations
dxdt=vx;
dydt=vy;
dzdt=vz;
dvxdt=(sin(theta)*sin(yaw)+cos(theta)*sin(phi)*cos(yaw))*Beta*tau/m;
dvydt=(cos(theta)*sin(phi)*sin(yaw)-sin(theta)*cos(yaw))*Beta*tau/m;
dvzdt=cos(theta)*cos(phi)*Beta*tau/m-g;
dyawdt=lambda;

dwdt=[dxdt;dydt;dzdt;dvxdt;dvydt;dvzdt;dyawdt];
end