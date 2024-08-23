function y = H(x)
    L = 0.15;
    r = 0.05;
    y = zeros(4, 1);
    S = sin(x(3));
    C = cos(x(3));
    y(1) = 1/r*(L*x(6) - S*x(4) + C*x(5));
    y(2) = 1/r*(L*x(6) - C*x(4) - S*x(5));
    y(3) = 1/r*(L*x(6) + S*x(4) - C*x(5));
    y(4) = 1/r*(L*x(6) + C*x(4) + S*x(5));
end