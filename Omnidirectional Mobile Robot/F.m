function y = F(x, u)
    T = u(5);
    y = zeros(6, 1);
    M = 6;
    g = 9.81;
    L = 0.1;
    r = 0.05;
    J = 0.015;
    Bv = 0.055;
    Bw = 0.015;
    Cv = 0.2;
    Cw = 0.14;
    if(x(4) == 0 && x(5) == 0)
        alpha = -pi/4;
    else
        alpha = angle(x(4) + 1j*x(5));
    end
    S = abs(sin(alpha - x(3)));
    C = abs(cos(alpha - x(3)));
    Load13 = 0.5*S;
    Load24 = 0.5*C;
    mu = 0;
    tau = zeros(4, 1);
    tau(1) = Load13*r*M*(mu*g + u(1)*r);
    tau(2) = Load24*r*M*(mu*g + u(2)*r);
    tau(3) = Load13*r*M*(mu*g + u(3)*r);
    tau(4) = Load24*r*M*(mu*g + u(4)*r);
    F1 = tau(1)/r;
    F2 = tau(2)/r;
    F3 = tau(3)/r;
    F4 = tau(4)/r;
    V_sat = 0.2;
    Vel = zeros(2, 1);
    Vel(1) = cos(x(3))*x(4) + sin(x(3))*x(5);
    Vel(2) = -sin(x(3))*x(4) + cos(x(3))*x(5);
    fv = zeros(2, 1);
    if(abs(Vel(1)) < V_sat)
        fv(1) = Cv/V_sat*Vel(1);
    else
        fv(1) = Cv*sign(Vel(1));
    end
    if(abs(Vel(2)) < V_sat)
        fv(2) = Cv/V_sat*Vel(2);
    else
        fv(2) = Cv*sign(Vel(2));
    end
    w_sat = 0.4;
    if(abs(x(6)) < w_sat)
        fw = Cw/w_sat*x(6);
    else
        fw = Cw*sign(x(6));
    end
    Acc = zeros(3, 1);
    Acc(1) = 1/M*(F4 - F2 - Bv*Vel(1) - fv(1));
    Acc(2) = 1/M*(F1 - F3 - Bv*Vel(2) - fv(2));
    Acc(3) = 1/J*(L*(F1 + F2 + F3 + F4) - Bw*x(6) - fw);
    Vel(1) = Acc(1)*T + Vel(1);
    Vel(2) = Acc(2)*T + Vel(2);
    y(6) = Acc(3)*T + x(6);
    y(3) = y(6)*T + x(3);
    y(4) = cos(y(3))*Vel(1) - sin(y(3))*Vel(2);
    y(5) = sin(y(3))*Vel(1) + cos(y(3))*Vel(2);
    y(1) = y(4)*T + x(1);
    y(2) = y(5)*T + x(2);
end