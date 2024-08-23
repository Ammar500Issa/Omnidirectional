function Acc = ForwardDynamicModel(u, Vel, theta, L, r, M, J, Bv, Cv, Bw, Cw)
    % alpha = angle(Vel(1) + 1j*Vel(2)) + theta;
    alpha = angle(cos(theta)*Vel(1) - sin(theta)*Vel(2) + 1j*(sin(theta)*Vel(1) + cos(theta)*Vel(2)));
    % alpha = angle(Vdes(1) + 1j*Vdes(2));
    S = abs(sin(alpha - theta));
    C = abs(cos(alpha - theta));
%     Load13 = 0.5*S;
%     Load24 = 0.5*C;
    Load13 = 0.5;
    Load24 = 0.5;
    g = 9.81;
    mu = 0;
    tau = zeros(4, 1);
    tau(1) = Load13*r*M*(mu*g + u(1)*r);
    tau(2) = Load24*r*M*(mu*g + u(2)*r);
    tau(3) = Load13*r*M*(mu*g + u(3)*r);
    tau(4) = Load24*r*M*(mu*g + u(4)*r);
    F1 = tau(1)/r; % J*Load13/r*u(1);
    F2 = tau(2)/r; % J*Load24/r*u(2);
    F3 = tau(3)/r; % J*Load13/r*u(3);
    F4 = tau(4)/r; % J*Load24/r*u(4);
    V_sat = 0.2;
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
    if(abs(Vel(3)) < w_sat)
        fw = Cw/w_sat*Vel(3);
    else
        fw = Cw*sign(Vel(3));
    end
    Acc(1) = 1/M*(F4 - F2 - Bv*Vel(1) - fv(1));
    Acc(2) = 1/M*(F1 - F3 - Bv*Vel(2) - fv(2));
    Acc(3) = 1/J*(L*(F1 + F2 + F3 + F4) - Bw*Vel(3) - fw);
    % Acc(3) = 1/J*(0.25*L*r*M*(u(1) + u(2) + u(3) + u(4)) - Bw*Vel(3) - fw);
end