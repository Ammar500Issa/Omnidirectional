clear;
clc;
%% Method of Kinematic Model
L = 0.1;
r = 0.05;
h1 = 1/r*[1 0]*[-sqrt(2)/2 sqrt(2)/2; -sqrt(2)/2 -sqrt(2)/2]*[-L*sqrt(2)/2 1 0; L*sqrt(2)/2 0 1];
h2 = 1/r*[1 0]*[-sqrt(2)/2 -sqrt(2)/2; sqrt(2)/2 -sqrt(2)/2]*[-L*sqrt(2)/2 1 0; -L*sqrt(2)/2 0 1];
h3 = 1/r*[1 0]*[sqrt(2)/2 -sqrt(2)/2; sqrt(2)/2 sqrt(2)/2]*[L*sqrt(2)/2 1 0; -L*sqrt(2)/2 0 1];
h4 = 1/r*[1 0]*[sqrt(2)/2 sqrt(2)/2; -sqrt(2)/2 sqrt(2)/2]*[L*sqrt(2)/2 1 0; L*sqrt(2)/2 0 1];
R = [1 0 0; 0 sqrt(2)/2 -sqrt(2)/2; 0 sqrt(2)/2 sqrt(2)/2];
H0 = [h1; h2; h3; h4]*R; % [u1; u2; u3; u4] = H0*[w; vx_b; vy_b]
%% Kinematic Model
L = 0.1;
r = 0.05;
Xi = [0; 0; 0];
Xf = [1; 1; 0];
T = 1;
dt = 0.001;
N = T/dt;
t = 0:dt:T - dt;
tv = t(2:N);
s = 3*t.^2/T^2 - 2*t.^3/T^3;
X = Xi + s.*(Xf - Xi);
V = zeros(3, N - 1);
Q = zeros(4, N - 1);
for i = 1:N - 1
    V(:, i) = (X(:, i + 1) - X(:, i))/dt;
    Q(:, i) = PseudoInvJacobian(X(3, i), L)*V(:, i);
end
figure;
plot(tv, V(1, :));
hold on;
plot(tv, V(2, :));
hold on;
plot(tv, V(3, :));
grid on;
legend("\nu_x", "\nu_y", "\omega")
figure;
plot(tv, Q(1, :));
hold on;
plot(tv, Q(2, :));
hold on;
plot(tv, Q(3, :));
hold on;
plot(tv, Q(4, :));
grid on;
legend("\nu_1", "\nu_2", "\nu_3", "\nu_4")
ActualX = zeros(3, N);
ActualV = zeros(3, N - 1);
for i = 2:N - 1
    ActualV(:, i) = Jacobian(ActualX(3, i - 1), L)*Q(:, i);
    ActualX(:, i) = ActualV(:, i - 1)*dt + ActualX(:, i - 1);
end
ActualX(:, N) = ActualV(:, N - 1)*dt + ActualX(:, N - 1);
figure;
plot(ActualX(1, :), ActualX(2, :));
figure;
plot(t, ActualX(1, :));
hold on;
plot(t, ActualX(2, :));
hold on;
plot(t, ActualX(3, :));
grid on;
legend("x", "y", "\theta");
%% Dynamic Model
M = 6;
g = 9.81;
L = 0.1;
r = 0.05;
J = 0.015; % 0.0185
Bv = 0.55;
Bw = 0.015;
Cv = 2;
Cw = 0.14;
Xi = [0; 0; 0];
Xf = [0; 0; pi];
T = 1;
dt = 0.001;
N = T/dt;
t = 0:dt:T - dt;
tv = t(2:N);
s = 3*t.^2/T^2 - 2*t.^3/T^3;
% s = t/T;
X = Xi + s.*(Xf - Xi);
Q = zeros(4, N - 1);
V = zeros(3, N - 1);
for i = 1:N - 1
    V(:, i) = (X(:, i + 1) - X(:, i))/dt;
    Q(:, i) = PseudoInvJacobian(X(3, i), L)*V(:, i);
end
figure;
plot(tv, Q(1, :));
hold on;
plot(tv, Q(2, :));
hold on;
plot(tv, Q(3, :));
hold on;
plot(tv, Q(4, :));
grid on;
legend("\nu_1", "\nu_2", "\nu_3", "\nu_4");
Acc = zeros(3, N - 2);
Velb = zeros(3, N - 1);
Acc_1 = zeros(3, N - 2);
Velb_1 = zeros(3, N - 1);
u = zeros(4, N - 2);
ptheta = Xi(3);
ptheta_1 = Xi(3);
Velb(1, 1) = cos(Xi(3))*V(1, 1) + sin(Xi(3))*V(2, 1);
Velb(2, 1) = -sin(Xi(3))*V(1, 1) + cos(Xi(3))*V(2, 1);
Velb_1(1, 1) = cos(Xi(3))*V(1, 1) + sin(Xi(3))*V(2, 1);
Velb_1(2, 1) = -sin(Xi(3))*V(1, 1) + cos(Xi(3))*V(2, 1);
for i = 1:N - 2
    u(:, i) = (Q(:, i + 1) - Q(:, i))/(r*dt);
    theta = Velb(3, i)*dt + ptheta;
    theta_1 = Velb_1(3, i)*dt + ptheta_1;
    Acc(:, i) = ForwardDynamicModel(u(:, i), Velb(:, i), theta, L, r, M, J, Bv/5, Cv/5, Bw/20, Cw/20);
    Velb(:, i + 1) = Acc(:, i)*dt + Velb(:, i);
    Acc_1(:, i) = ForwardDynamicModel(u(:, i), Velb_1(:, i), theta_1, L, r, M, J, Bv, Cv, Bw/10, Cw/10);
    Velb_1(:, i + 1) = Acc_1(:, i)*dt + Velb_1(:, i);
    ptheta = theta;
    ptheta_1 = theta_1;
end
figure;
plot(t(3:length(t)), u(1, :));
hold on;
plot(t(3:length(t)), u(2, :));
hold on;
plot(t(3:length(t)), u(3, :));
hold on;
plot(t(3:length(t)), u(4, :));
grid on;
legend("\alpha_1", "\alpha_2", "\alpha_3", "\alpha_4");
theta = zeros(1, N);
theta_1 = zeros(1, N);
theta(1) = Xi(3);
theta_1(1) = Xi(3);
Vel = zeros(3, N - 1);
Vel_1 = zeros(3, N - 1);
for i = 1:N - 1
    theta(i + 1) = Vel(3, i)*dt + theta(i);
    Vel(1, i) = cos(theta(i))*Velb(1, i) - sin(theta(i))*Velb(2, i);
    Vel(2, i) = sin(theta(i))*Velb(1, i) + cos(theta(i))*Velb(2, i);
    theta_1(i + 1) = Velb_1(3, i)*dt + theta_1(i);
    Vel_1(1, i) = cos(theta_1(i))*Velb_1(1, i) - sin(theta_1(i))*Velb_1(2, i);
    Vel_1(2, i) = sin(theta_1(i))*Velb_1(1, i) + cos(theta_1(i))*Velb_1(2, i);
end
Vel(3, :) = Velb(3, :);
Vel_1(3, :) = Velb_1(3, :);
Pos = zeros(3, N);
Pos_1 = zeros(3, N);
Pos(:, 1) = Xi;
Pos_1(:, 1) = Xi;
for i = 2:N
    Pos(:, i) = Vel(:, i - 1)*dt + Pos(:, i - 1);
    Pos_1(:, i) = Vel_1(:, i - 1)*dt + Pos_1(:, i - 1);
end
figure;
plot(t, Pos(3, :))
hold on;
plot(t, Pos_1(3, :))
hold on;
plot(t, X(3, :))
grid on;
legend("\theta,Dynamic with Low Friction", "\theta,Dynamic with High Friction", "\theta,Kinematic/Dynamic with no Friction");
figure;
subplot(2, 1, 1);
plot(t, Pos(1, :));
hold on;
plot(t, Pos_1(1, :));
hold on;
plot(t, X(1, :));
grid on;
legend("x,Dynamic with Low Friction", "x,Dynamic with High Friction", "x,Kinematic/Dynamic with no Friction");
subplot(2, 1, 2);
plot(t, Pos(2, :));
hold on;
plot(t, Pos_1(2, :));
hold on;
plot(t, X(2, :));
grid on;
legend("y,Dynamic with Low Friction", "y,Dynamic with High Friction", "y,Kinematic/Dynamic with no Friction");
figure;
plot(X(1, :), X(2, :));
hold on;
plot(Pos(1, :), Pos(2, :));
hold on;
plot(Pos_1(1, :), Pos_1(2, :));
grid on;
legend("Kinematic/Dynamic with no Friction", "Dynamic with Low Friction", "Dynamic with High Friction");
%% Circle
M = 6;
g = 9.81;
L = 0.1;
r = 0.05;
J = 0.015; % 0.0185
Bv = 0.55;
Bw = 0.015;
Cv = 2;
Cw = 0.14;
Xi = [-1; 0; 0];
Xf = [1; 0; 0];
O = [0, 0];
Rad = 1;
T = 2;
dt = 0.001;
N = T/dt;
t = 0:dt:T - dt;
tv = t(2:N);
% s = 3*t.^2/T^2 - 2*t.^3/T^3;
s = t/T;
X = Xi + s.*(Xf - Xi);
X(2, :) = sqrt(Rad^2 - (X(1, :) - O(1)).^2) + O(2);
Q = zeros(4, N - 1);
V = zeros(3, N - 1);
for i = 1:N - 1
    V(:, i) = (X(:, i + 1) - X(:, i))/dt;
    Q(:, i) = PseudoInvJacobian(X(3, i), L)*V(:, i);
end
Acc = zeros(3, N - 2);
Velb = zeros(3, N - 1);
Acc_1 = zeros(3, N - 2);
Velb_1 = zeros(3, N - 1);
u = zeros(4, N - 2);
ptheta = Xi(3);
ptheta_1 = Xi(3);
Velb(1, 1) = cos(Xi(3))*V(1, 1) + sin(Xi(3))*V(2, 1);
Velb(2, 1) = -sin(Xi(3))*V(1, 1) + cos(Xi(3))*V(2, 1);
Velb_1(1, 1) = cos(Xi(3))*V(1, 1) + sin(Xi(3))*V(2, 1);
Velb_1(2, 1) = -sin(Xi(3))*V(1, 1) + cos(Xi(3))*V(2, 1);
for i = 1:N - 2
    u(:, i) = (Q(:, i + 1) - Q(:, i))/(r*dt);
    theta = Velb(3, i)*dt + ptheta;
    theta_1 = Velb_1(3, i)*dt + ptheta_1;
    Acc(:, i) = ForwardDynamicModel(u(:, i), Velb(:, i), theta, L, r, M, J, 0, 0, 0, 0);
    Velb(:, i + 1) = Acc(:, i)*dt + Velb(:, i);
    Acc_1(:, i) = ForwardDynamicModel(u(:, i), Velb_1(:, i), theta_1, L, r, M, J, Bv, Cv, Bw, Cw);
    Velb_1(:, i + 1) = Acc_1(:, i)*dt + Velb_1(:, i);
    ptheta = theta;
    ptheta_1 = theta_1;
end
theta = zeros(1, N);
theta_1 = zeros(1, N);
theta(1) = Xi(3);
theta_1(1) = Xi(3);
Vel = zeros(3, N - 1);
Vel_1 = zeros(3, N - 1);
for i = 1:N - 1
    theta(i + 1) = Vel(3, i)*dt + theta(i);
    Vel(1, i) = cos(theta(i))*Velb(1, i) - sin(theta(i))*Velb(2, i);
    Vel(2, i) = sin(theta(i))*Velb(1, i) + cos(theta(i))*Velb(2, i);
    theta_1(i + 1) = Velb_1(3, i)*dt + theta_1(i);
    Vel_1(1, i) = cos(theta_1(i))*Velb_1(1, i) - sin(theta_1(i))*Velb_1(2, i);
    Vel_1(2, i) = sin(theta_1(i))*Velb_1(1, i) + cos(theta_1(i))*Velb_1(2, i);
end
Vel(3, :) = Velb(3, :);
Vel_1(3, :) = Velb_1(3, :);
Pos = zeros(3, N);
Pos_1 = zeros(3, N);
Pos(:, 1) = Xi;
Pos_1(:, 1) = Xi;
for i = 2:N
    Pos(:, i) = Vel(:, i - 1)*dt + Pos(:, i - 1);
    Pos_1(:, i) = Vel_1(:, i - 1)*dt + Pos_1(:, i - 1);
end
Pos1 = Pos;
Pos1_1 = Pos_1;
X1 = X;
Vel1 = Vel;
Vel1_1 = Vel_1;
V1 = V;
XiK = Xf;
XiD = Pos(:, N);
XiDF = Pos_1(:, N);
Xf = [-1; 0; 0];
XK = XiK + s.*(Xf - XiK);
XK(2, :) = -sqrt(Rad^2 - (XK(1, :) - O(1)).^2) + O(2);
XD = XiD + s.*(Xf - XiD);
XD(2, :) = -sqrt(Rad^2 - (XD(1, :) - O(1)).^2) + O(2);
XDF = XiDF + s.*(Xf - XiDF);
XDF(2, :) = -sqrt(Rad^2 - (XDF(1, :) - O(1)).^2) + O(2);
for test = 1:3
    if(test == 1)
        Xi = XiK;
        X = XK;
    elseif(test == 2)
        Xi = XiD;
        X = XD;
    elseif(test == 3)
        Xi = XiDF;
        X = XDF;
    end
    Q = zeros(4, N - 1);
    V = zeros(3, N - 1);
    for i = 1:N - 1
        V(:, i) = (X(:, i + 1) - X(:, i))/dt;
        Q(:, i) = PseudoInvJacobian(X(3, i), L)*V(:, i);
    end
    Acc = zeros(3, N - 2);
    Velb = zeros(3, N - 1);
    Acc_1 = zeros(3, N - 2);
    Velb_1 = zeros(3, N - 1);
    u = zeros(4, N - 2);
    ptheta = Xi(3);
    ptheta_1 = Xi(3);
    Velb(1, 1) = cos(Xi(3))*V(1, 1) + sin(Xi(3))*V(2, 1);
    Velb(2, 1) = -sin(Xi(3))*V(1, 1) + cos(Xi(3))*V(2, 1);
    Velb_1(1, 1) = cos(Xi(3))*V(1, 1) + sin(Xi(3))*V(2, 1);
    Velb_1(2, 1) = -sin(Xi(3))*V(1, 1) + cos(Xi(3))*V(2, 1);
    for i = 1:N - 2
        u(:, i) = (Q(:, i + 1) - Q(:, i))/(r*dt);
        theta = Velb(3, i)*dt + ptheta;
        theta_1 = Velb_1(3, i)*dt + ptheta_1;
        Acc(:, i) = ForwardDynamicModel(u(:, i), Velb(:, i), theta, L, r, M, J, 0, 0, 0, 0);
        Velb(:, i + 1) = Acc(:, i)*dt + Velb(:, i);
        Acc_1(:, i) = ForwardDynamicModel(u(:, i), Velb_1(:, i), theta_1, L, r, M, J, Bv, Cv, Bw, Cw);
        Velb_1(:, i + 1) = Acc_1(:, i)*dt + Velb_1(:, i);
        ptheta = theta;
        ptheta_1 = theta_1;
    end
    for i = 1:N - 1
        theta(i + 1) = Vel(3, i)*dt + theta(i);
        Vel(1, i) = cos(theta(i))*Velb(1, i) - sin(theta(i))*Velb(2, i);
        Vel(2, i) = sin(theta(i))*Velb(1, i) + cos(theta(i))*Velb(2, i);
        theta_1(i + 1) = Velb_1(3, i)*dt + theta_1(i);
        Vel_1(1, i) = cos(theta_1(i))*Velb_1(1, i) - sin(theta_1(i))*Velb_1(2, i);
        Vel_1(2, i) = sin(theta_1(i))*Velb_1(1, i) + cos(theta_1(i))*Velb_1(2, i);
    end
    Vel(3, :) = Velb(3, :);
    Vel_1(3, :) = Velb_1(3, :);
    Pos = zeros(3, N);
    Pos_1 = zeros(3, N);
    Pos(:, 1) = Xi;
    Pos_1(:, 1) = Xi;
    for i = 2:N
        Pos(:, i) = Vel(:, i - 1)*dt + Pos(:, i - 1);
        Pos_1(:, i) = Vel_1(:, i - 1)*dt + Pos_1(:, i - 1);
    end
    if(test == 1)
        VK = V;
        XK = X;
    elseif(test == 2)
        VelD = Vel;
        PosD = Pos;
    elseif(test == 3)
        VelDF_1 = Vel_1;
        PosDF_1 = Pos_1;
    end
end
tc = zeros(1, 2*length(t));
tc(1:length(t)) = t;
tc(length(t) + 1:length(tc)) = t + T*ones(1, length(t));
tvc = zeros(1, 2*length(tv));
tvc(1:length(tv)) = tv;
tvc(length(tv) + 1:length(tvc)) = tv + (T - dt)*ones(1, length(tv));
figure;
subplot(2, 3, 1);
plot(tvc, [Vel1(1, :), VelD(1, :)]);
hold on;
plot(tvc, [Vel1_1(1, :), VelDF_1(1, :)]);
hold on;
plot(tvc, [V1(1, :), VK(1, :)]);
grid on;
legend("\nu_x,Dynamic", "\nu_x,Dynamic with Friction", "\nu_x,Kinematic");
subplot(2, 3, 2);
plot(tvc, [Vel1(2, :), VelD(2, :)]);
hold on;
plot(tvc, [Vel1_1(2, :), VelDF_1(2, :)]);
hold on;
plot(tvc, [V1(2, :), VK(2, :)]);
grid on;
legend("\nu_y,Dynamic", "\nu_y,Dynamic with Friction", "\nu_y,Kinematic");
subplot(2, 3, 3);
plot(tvc, [Vel1(3, :), VelD(3, :)]);
hold on;
plot(tvc, [Vel1_1(3, :), VelDF_1(3, :)]);
hold on;
plot(tvc, [V1(3, :), VK(3, :)]);
grid on;
legend("\omega,Dynamic", "\omega,Dynamic with Friction", "\omega,Kinematic");
subplot(2, 3, 4);
plot(tc, [Pos1(1, :), PosD(1, :)]);
hold on;
plot(tc, [Pos1_1(1, :), PosDF_1(1, :)]);
hold on;
plot(tc, [X1(1, :), XK(1, :)]);
grid on;
legend("x,Dynamic", "x,Dynamic with Friction", "x,Kinematic");
subplot(2, 3, 5);
plot(tc, [Pos1(2, :), PosD(2, :)]);
hold on;
plot(tc, [Pos1_1(2, :), PosDF_1(2, :)]);
hold on;
plot(tc, [X1(2, :), XK(2, :)]);
grid on;
legend("y,Dynamic", "y,Dynamic with Friction", "y,Kinematic");
subplot(2, 3, 6);
plot(tc, [Pos1(3, :), PosD(3, :)]);
hold on;
plot(tc, [Pos1_1(3, :), PosDF_1(3, :)]);
hold on;
plot(tc, [X1(3, :), XK(3, :)]);
grid on;
legend("\theta,Dynamic", "\theta,Dynamic with Friction", "\theta,Kinematic");
figure;
plot([X1(1, :), XK(1, :)], [X1(2, :), XK(2, :)]);
hold on;
plot([Pos1(1, :), PosD(1, :)], [Pos1(2, :), PosD(2, :)]);
hold on;
plot([Pos1_1(1, :), PosDF_1(1, :)], [Pos1_1(2, :), PosDF_1(2, :)]);
grid on;
axis([-2, 2, -2, 2]);
%% Half Circle 1
M = 6;
g = 9.81;
L = 0.1;
r = 0.05;
J = 0.015; % 0.0185
Bv = 0.55;
Bw = 0.015;
Cv = 2;
Cw = 0.14;
Xi = [-1; 0; 0];
Xf = [1; 0; pi];
O = [0, 0];
Rad = 1;
T = 2;
dt = 0.001;
N = T/dt;
t = 0:dt:T - dt;
tv = t(2:N);
% s = 3*t.^2/T^2 - 2*t.^3/T^3;
s = t/T;
X = Xi + s.*(Xf - Xi);
X(2, :) = sqrt(Rad^2 - (X(1, :) - O(1)).^2) + O(2);
Q = zeros(4, N - 1);
V = zeros(3, N - 1);
for i = 1:N - 1
    V(:, i) = (X(:, i + 1) - X(:, i))/dt;
    Q(:, i) = PseudoInvJacobian(X(3, i), L)*V(:, i);
end
Acc = zeros(3, N - 2);
Velb = zeros(3, N - 1);
Acc_1 = zeros(3, N - 2);
Velb_1 = zeros(3, N - 1);
u = zeros(4, N - 2);
ptheta = Xi(3);
ptheta_1 = Xi(3);
Velb(1, 1) = cos(Xi(3))*V(1, 1) + sin(Xi(3))*V(2, 1);
Velb(2, 1) = -sin(Xi(3))*V(1, 1) + cos(Xi(3))*V(2, 1);
Velb_1(1, 1) = cos(Xi(3))*V(1, 1) + sin(Xi(3))*V(2, 1);
Velb_1(2, 1) = -sin(Xi(3))*V(1, 1) + cos(Xi(3))*V(2, 1);
for i = 1:N - 2
    u(:, i) = (Q(:, i + 1) - Q(:, i))/(r*dt);
    theta = Velb(3, i)*dt + ptheta;
    theta_1 = Velb_1(3, i)*dt + ptheta_1;
    Acc(:, i) = ForwardDynamicModel(u(:, i), Velb(:, i), theta, L, r, M, J, Bv/5, Cv/5, Bw/5, Cw/5);
    Velb(:, i + 1) = Acc(:, i)*dt + Velb(:, i);
    Acc_1(:, i) = ForwardDynamicModel(u(:, i), Velb_1(:, i), theta_1, L, r, M, J, Bv, Cv, Bw, Cw);
    Velb_1(:, i + 1) = Acc_1(:, i)*dt + Velb_1(:, i);
    ptheta = theta;
    ptheta_1 = theta_1;
end
theta = zeros(1, N);
theta_1 = zeros(1, N);
theta(1) = Xi(3);
theta_1(1) = Xi(3);
Vel = zeros(3, N - 1);
Vel_1 = zeros(3, N - 1);
for i = 1:N - 1
    theta(i + 1) = Vel(3, i)*dt + theta(i);
    Vel(1, i) = cos(theta(i))*Velb(1, i) - sin(theta(i))*Velb(2, i);
    Vel(2, i) = sin(theta(i))*Velb(1, i) + cos(theta(i))*Velb(2, i);
    theta_1(i + 1) = Velb_1(3, i)*dt + theta_1(i);
    Vel_1(1, i) = cos(theta_1(i))*Velb_1(1, i) - sin(theta_1(i))*Velb_1(2, i);
    Vel_1(2, i) = sin(theta_1(i))*Velb_1(1, i) + cos(theta_1(i))*Velb_1(2, i);
end
Vel(3, :) = Velb(3, :);
Vel_1(3, :) = Velb_1(3, :);
Pos = zeros(3, N);
Pos_1 = zeros(3, N);
Pos(:, 1) = Xi;
Pos_1(:, 1) = Xi;
for i = 2:N
    Pos(:, i) = Vel(:, i - 1)*dt + Pos(:, i - 1);
    Pos_1(:, i) = Vel_1(:, i - 1)*dt + Pos_1(:, i - 1);
end
figure;
subplot(2, 1, 1);
plot(t(1:floor(N/4.5)), Pos(1, 1:floor(N/4.5)));
hold on;
plot(t(1:floor(N/4.5)), Pos_1(1, 1:floor(N/4.5)));
hold on;
plot(t(1:floor(N/4.5)), X(1, 1:floor(N/4.5)));
grid on;
legend("x,Dynamic with Low Friction", "x,Dynamic with High Friction", "x,Kinematic/Dynamic with no Friction");
subplot(2, 1, 2);
plot(t(1:floor(N/4.5)), Pos(2, 1:floor(N/4.5)));
hold on;
plot(t(1:floor(N/4.5)), Pos_1(2, 1:floor(N/4.5)));
hold on;
plot(t(1:floor(N/4.5)), X(2, 1:floor(N/4.5)));
grid on;
legend("y,Dynamic with Low Friction", "y,Dynamic with High Friction", "y,Kinematic/Dynamic with no Friction");
figure;
plot(X(1, 1:floor(N/4.5)), X(2, 1:floor(N/4.5)));
hold on;
plot(Pos(1, 1:floor(N/4.5)), Pos(2, 1:floor(N/4.5)));
hold on;
plot(Pos_1(1, 1:floor(N/4.5)), Pos_1(2, 1:floor(N/4.5)));
grid on;
legend("Kinematic/Dynamic with no Friction", "Dynamic with Low Friction", "Dynamic with High Friction");
%% Half Circle 2
M = 6;
g = 9.81;
L = 0.1;
r = 0.05;
J = 0.015; % 0.0185
Bv = 0.55;
Bw = 0.015;
Cv = 2;
Cw = 0.14;
Xi = [1; 0; 0];
Xf = [-1; 0; 0];
O = [0, 0];
Rad = 1;
T = 2;
dt = 0.001;
N = T/dt;
t = 0:dt:T - dt;
tv = t(2:N);
% s = 3*t.^2/T^2 - 2*t.^3/T^3;
s = t/T;
X = Xi + s.*(Xf - Xi);
X(2, :) = -sqrt(Rad^2 - (X(1, :) - O(1)).^2) + O(2);
Q = zeros(4, N - 1);
V = zeros(3, N - 1);
for i = 1:N - 1
    V(:, i) = (X(:, i + 1) - X(:, i))/dt;
    Q(:, i) = PseudoInvJacobian(X(3, i), L)*V(:, i);
end
Acc = zeros(3, N - 2);
Velb = zeros(3, N - 1);
Acc_1 = zeros(3, N - 2);
Velb_1 = zeros(3, N - 1);
u = zeros(4, N - 2);
ptheta = Xi(3);
ptheta_1 = Xi(3);
Velb(1, 1) = cos(Xi(3))*V(1, 1) + sin(Xi(3))*V(2, 1);
Velb(2, 1) = -sin(Xi(3))*V(1, 1) + cos(Xi(3))*V(2, 1);
Velb_1(1, 1) = cos(Xi(3))*V(1, 1) + sin(Xi(3))*V(2, 1);
Velb_1(2, 1) = -sin(Xi(3))*V(1, 1) + cos(Xi(3))*V(2, 1);
for i = 1:N - 2
    u(:, i) = (Q(:, i + 1) - Q(:, i))/(r*dt);
    theta = Velb(3, i)*dt + ptheta;
    theta_1 = Velb_1(3, i)*dt + ptheta_1;
    Acc(:, i) = ForwardDynamicModel(u(:, i), Velb(:, i), theta, L, r, M, J, 0, 0, 0, 0);
    Velb(:, i + 1) = Acc(:, i)*dt + Velb(:, i);
    Acc_1(:, i) = ForwardDynamicModel(u(:, i), Velb_1(:, i), theta_1, L, r, M, J, Bv, Cv, Bw, Cw);
    Velb_1(:, i + 1) = Acc_1(:, i)*dt + Velb_1(:, i);
    ptheta = theta;
    ptheta_1 = theta_1;
end
for i = 1:N - 1
    theta(i + 1) = Vel(3, i)*dt + theta(i);
    Vel(1, i) = cos(theta(i))*Velb(1, i) - sin(theta(i))*Velb(2, i);
    Vel(2, i) = sin(theta(i))*Velb(1, i) + cos(theta(i))*Velb(2, i);
    theta_1(i + 1) = Velb_1(3, i)*dt + theta_1(i);
    Vel_1(1, i) = cos(theta_1(i))*Velb_1(1, i) - sin(theta_1(i))*Velb_1(2, i);
    Vel_1(2, i) = sin(theta_1(i))*Velb_1(1, i) + cos(theta_1(i))*Velb_1(2, i);
end
Vel(3, :) = Velb(3, :);
Vel_1(3, :) = Velb_1(3, :);
Pos = zeros(3, N);
Pos_1 = zeros(3, N);
Pos(:, 1) = Xi;
Pos_1(:, 1) = Xi;
for i = 2:N
    Pos(:, i) = Vel(:, i - 1)*dt + Pos(:, i - 1);
    Pos_1(:, i) = Vel_1(:, i - 1)*dt + Pos_1(:, i - 1);
end
figure;
subplot(2, 3, 1);
plot(tv, Vel(1, :));
hold on;
plot(tv, Vel_1(1, :));
hold on;
plot(tv, V(1, :));
grid on;
legend("\nu_x,Dynamic", "\nu_x,Dynamic with Friction", "\nu_x,Kinematic");
subplot(2, 3, 2);
plot(tv, Vel(2, :));
hold on;
plot(tv, Vel_1(2, :));
hold on;
plot(tv, V(2, :));
grid on;
legend("\nu_y,Dynamic", "\nu_y,Dynamic with Friction", "\nu_y,Kinematic");
subplot(2, 3, 3);
plot(tv, Vel(3, :));
hold on;
plot(tv, Vel_1(3, :));
hold on;
plot(tv, V(3, :));
grid on;
legend("\omega,Dynamic", "\omega,Dynamic with Friction", "\omega,Kinematic");
subplot(2, 3, 4);
plot(t, Pos(1, :));
hold on;
plot(t, Pos_1(1, :));
hold on;
plot(t, X(1, :));
grid on;
legend("x,Dynamic", "x,Dynamic with Friction", "x,Kinematic");
subplot(2, 3, 5);
plot(t, Pos(2, :));
hold on;
plot(t, Pos_1(2, :));
hold on;
plot(t, X(2, :));
grid on;
legend("y,Dynamic", "y,Dynamic with Friction", "y,Kinematic");
subplot(2, 3, 6);
plot(t, Pos(3, :));
hold on;
plot(t, Pos_1(3, :));
hold on;
plot(t, X(3, :));
grid on;
legend("\theta,Dynamic", "\theta,Dynamic with Friction", "\theta,Kinematic");
figure;
plot(X(1, :), X(2, :));
hold on;
plot(Pos(1, :), Pos(2, :));
hold on;
plot(Pos_1(1, :), Pos_1(2, :));
grid on;
legend("Kinematic/Dynamic with no Friction", "Dynamic with Low Friction", "Dynamic with High Friction");
%% Dynamic with Noise
M = 6;
g = 9.81;
L = 0.1;
r = 0.05;
J = 0.015; % 0.0185
Bv = 0.55;
Bw = 0.015;
Cv = 2;
Cw = 0.14;
mu = 0.27*0;
s2 = 0.01*0.1;
Xi = [0; 0; 0];
Xf = [1; 0.5; 0];
T = 1;
dt = 0.001;
N = T/dt;
t = 0:dt:T - dt;
tv = t(2:N);
% s = 3*t.^2/T^2 - 2*t.^3/T^3;
s = t/T;
X = Xi + s.*(Xf - Xi);
Q = zeros(4, N - 1);
V = zeros(3, N - 1);
for i = 1:N - 1
    V(:, i) = (X(:, i + 1) - X(:, i))/dt;
    Q(:, i) = PseudoInvJacobian(X(3, i), L)*V(:, i);
end
Qn = Q + mu + sqrt(s2).*randn(4, N - 1);
Xn = zeros(3, N);
Vn = zeros(3, N - 1);
for i = 2:N - 1
    Vn(:, i) = Jacobian(Xn(3, i - 1), L)*Qn(:, i);
    Xn(:, i) = Vn(:, i - 1)*dt + Xn(:, i - 1);
end
Xn(:, N) = Vn(:, N - 1)*dt + Xn(:, N - 1);
Acc = zeros(3, N - 2);
Velb = zeros(3, N - 1);
Acc_1 = zeros(3, N - 2);
Velb_1 = zeros(3, N - 1);
u = zeros(4, N - 2);
ptheta = Xi(3);
ptheta_1 = Xi(3);
Velb(1, 1) = cos(Xi(3))*V(1, 1) + sin(Xi(3))*V(2, 1);
Velb(2, 1) = -sin(Xi(3))*V(1, 1) + cos(Xi(3))*V(2, 1);
Velb_1(1, 1) = cos(Xi(3))*V(1, 1) + sin(Xi(3))*V(2, 1);
Velb_1(2, 1) = -sin(Xi(3))*V(1, 1) + cos(Xi(3))*V(2, 1);
Accn = zeros(3, N - 2);
Velbn = zeros(3, N - 1);
Accn_1 = zeros(3, N - 2);
Velbn_1 = zeros(3, N - 1);
un = zeros(4, N - 2);
pthetan = Xi(3);
pthetan_1 = Xi(3);
Velbn(1, 1) = cos(Xi(3))*V(1, 1) + sin(Xi(3))*V(2, 1);
Velbn(2, 1) = -sin(Xi(3))*V(1, 1) + cos(Xi(3))*V(2, 1);
Velbn_1(1, 1) = cos(Xi(3))*V(1, 1) + sin(Xi(3))*V(2, 1);
Velbn_1(2, 1) = -sin(Xi(3))*V(1, 1) + cos(Xi(3))*V(2, 1);
for i = 1:N - 2
    u(:, i) = (Q(:, i + 1) - Q(:, i))/(r*dt);
    theta = Velb(3, i)*dt + ptheta;
    theta_1 = Velb_1(3, i)*dt + ptheta_1;
    Acc(:, i) = ForwardDynamicModel(u(:, i), Velb(:, i), theta, L, r, M, J, Bv/5, Cv/5, Bw/5, Cw/5);
    Velb(:, i + 1) = Acc(:, i)*dt + Velb(:, i);
    Acc_1(:, i) = ForwardDynamicModel(u(:, i), Velb_1(:, i), theta_1, L, r, M, J, Bv, Cv, Bw, Cw);
    Velb_1(:, i + 1) = Acc_1(:, i)*dt + Velb_1(:, i);
    ptheta = theta;
    ptheta_1 = theta_1;
    un(:, i) = (Qn(:, i + 1) - Qn(:, i))/(r*dt);
    thetan = Velbn(3, i)*dt + pthetan;
    thetan_1 = Velbn_1(3, i)*dt + pthetan_1;
    Accn(:, i) = ForwardDynamicModel(un(:, i), Velbn(:, i), thetan, L, r, M, J, Bv/5, Cv/5, Bw/5, Cw/5);
    Velbn(:, i + 1) = Accn(:, i)*dt + Velbn(:, i);
    Accn_1(:, i) = ForwardDynamicModel(un(:, i), Velbn_1(:, i), thetan_1, L, r, M, J, Bv, Cv, Bw, Cw);
    Velbn_1(:, i + 1) = Accn_1(:, i)*dt + Velbn_1(:, i);
    pthetan = thetan;
    pthetan_1 = thetan_1;
end
figure;
plot(t(3:length(t)), u(1, :));
hold on;
plot(t(3:length(t)), u(2, :));
hold on;
plot(t(3:length(t)), u(3, :));
hold on;
plot(t(3:length(t)), u(4, :));
hold on;
plot(t(3:length(t)), un(1, :));
hold on;
plot(t(3:length(t)), un(2, :));
hold on;
plot(t(3:length(t)), un(3, :));
hold on;
plot(t(3:length(t)), un(4, :));
grid on;
legend("\alpha_1", "\alpha_2", "\alpha_3", "\alpha_4", "\alphan_1", "\alphan_2", "\alphan_3", "\alphan_4");
theta = zeros(1, N);
theta_1 = zeros(1, N);
theta(1) = Xi(3);
theta_1(1) = Xi(3);
Vel = zeros(3, N - 1);
Vel_1 = zeros(3, N - 1);
thetan = zeros(1, N);
thetan_1 = zeros(1, N);
thetan(1) = Xi(3);
thetan_1(1) = Xi(3);
Veln = zeros(3, N - 1);
Veln_1 = zeros(3, N - 1);
for i = 1:N - 1
    theta(i + 1) = Vel(3, i)*dt + theta(i);
    Vel(1, i) = cos(theta(i))*Velb(1, i) - sin(theta(i))*Velb(2, i);
    Vel(2, i) = sin(theta(i))*Velb(1, i) + cos(theta(i))*Velb(2, i);
    theta_1(i + 1) = Velb_1(3, i)*dt + theta_1(i);
    Vel_1(1, i) = cos(theta_1(i))*Velb_1(1, i) - sin(theta_1(i))*Velb_1(2, i);
    Vel_1(2, i) = sin(theta_1(i))*Velb_1(1, i) + cos(theta_1(i))*Velb_1(2, i);
    thetan(i + 1) = Veln(3, i)*dt + thetan(i);
    Veln(1, i) = cos(thetan(i))*Velbn(1, i) - sin(thetan(i))*Velbn(2, i);
    Veln(2, i) = sin(thetan(i))*Velbn(1, i) + cos(thetan(i))*Velbn(2, i);
    thetan_1(i + 1) = Velbn_1(3, i)*dt + thetan_1(i);
    Veln_1(1, i) = cos(thetan_1(i))*Velbn_1(1, i) - sin(thetan_1(i))*Velbn_1(2, i);
    Veln_1(2, i) = sin(thetan_1(i))*Velbn_1(1, i) + cos(thetan_1(i))*Velbn_1(2, i);
end
Vel(3, :) = Velb(3, :);
Vel_1(3, :) = Velb_1(3, :);
Pos = zeros(3, N);
Pos_1 = zeros(3, N);
Pos(:, 1) = Xi;
Pos_1(:, 1) = Xi;
Veln(3, :) = Velbn(3, :);
Veln_1(3, :) = Velbn_1(3, :);
Posn = zeros(3, N);
Posn_1 = zeros(3, N);
Posn(:, 1) = Xi;
Posn_1(:, 1) = Xi;
for i = 2:N
    Pos(:, i) = Vel(:, i - 1)*dt + Pos(:, i - 1);
    Pos_1(:, i) = Vel_1(:, i - 1)*dt + Pos_1(:, i - 1);
    Posn(:, i) = Veln(:, i - 1)*dt + Posn(:, i - 1);
    Posn_1(:, i) = Veln_1(:, i - 1)*dt + Posn_1(:, i - 1);
end
figure;
subplot(2, 3, 1);
plot(tv, Vel(1, :));
hold on;
plot(tv, Vel_1(1, :));
hold on;
plot(tv, V(1, :));
hold on;
plot(tv, Veln(1, :));
hold on;
plot(tv, Veln_1(1, :));
hold on;
plot(tv, Vn(1, :));
grid on;
legend("\nu_x,Dynamic", "\nu_x,Dynamic with Friction", "\nu_x,Kinematic", "\nu_x,Dynamic/with Noise", "\nu_x,Dynamic with Friction/with Noise", "\nu_x,Kinematic/with Noise");
subplot(2, 3, 2);
plot(tv, Vel(2, :));
hold on;
plot(tv, Vel_1(2, :));
hold on;
plot(tv, V(2, :));
hold on;
plot(tv, Veln(2, :));
hold on;
plot(tv, Veln_1(2, :));
hold on;
plot(tv, Vn(2, :));
grid on;
legend("\nu_y,Dynamic", "\nu_y,Dynamic with Friction", "\nu_y,Kinematic", "\nu_y,Dynamic/with Noise", "\nu_y,Dynamic with Friction/with Noise", "\nu_y,Kinematic/with Noise");
subplot(2, 3, 3);
plot(tv, Vel(3, :));
hold on;
plot(tv, Vel_1(3, :));
hold on;
plot(tv, V(3, :));
hold on;
plot(tv, Veln(3, :));
hold on;
plot(tv, Veln_1(3, :));
hold on;
plot(tv, Vn(3, :));
grid on;
legend("\omega,Dynamic", "\omega,Dynamic with Friction", "\omega,Kinematic", "\omega,Dynamic/with Noise", "\omega,Dynamic with Friction/with Noise", "\omega,Kinematic/with Noise");
subplot(2, 3, 4);
plot(t, Pos(1, :));
hold on;
plot(t, Pos_1(1, :));
hold on;
plot(t, X(1, :));
hold on;
plot(t, Posn(1, :));
hold on;
plot(t, Posn_1(1, :));
hold on;
plot(t, Xn(1, :));
grid on;
legend("x,Dynamic", "x,Dynamic with Friction", "x,Kinematic", "x,Dynamic/with Noise", "x,Dynamic with Friction/with Noise", "x,Kinematic/with Noise");
subplot(2, 3, 5);
plot(t, Pos(2, :));
hold on;
plot(t, Pos_1(2, :));
hold on;
plot(t, X(2, :));
hold on;
plot(t, Posn(2, :));
hold on;
plot(t, Posn_1(2, :));
hold on;
plot(t, Xn(2, :));
grid on;
legend("y,Dynamic", "y,Dynamic with Friction", "y,Kinematic", "y,Dynamic/with Noise", "y,Dynamic with Friction/with Noise", "y,Kinematic/with Noise");
subplot(2, 3, 6);
plot(t, Pos(3, :));
hold on;
plot(t, Pos_1(3, :));
hold on;
plot(t, X(3, :));
hold on;
plot(t, Posn(3, :));
hold on;
plot(t, Posn_1(3, :));
hold on;
plot(t, Xn(3, :));
grid on;
legend("\theta,Dynamic", "\theta,Dynamic with Friction", "\theta,Kinematic", "\theta,Dynamic/with Noise", "\theta,Dynamic with Friction/with Noise", "\theta,Kinematic/with Noise");
figure;
plot(X(1, :), X(2, :));
hold on;
plot(Pos(1, :), Pos(2, :));
hold on;
plot(Pos_1(1, :), Pos_1(2, :));
hold on;
plot(Xn(1, :), Xn(2, :));
hold on;
plot(Posn(1, :), Posn(2, :));
hold on;
plot(Posn_1(1, :), Posn_1(2, :));
grid on;
legend("Kinematic/Dynamic with no Friction", "Dynamic with Low Friction", "Dynamic with High Friction", "Kinematic/Dynamic with no Friction/with Noise", "Dynamic with Low Friction/with Noise", "Dynamic with High Friction/with Noise");