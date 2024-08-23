function J = Jacobian(theta, L)
    S = sin(theta);
    C = cos(theta);
    J = 0.5*[-S, -C, S, C;
             C, -S, -C, S;
             1/(2*L), 1/(2*L), 1/(2*L), 1/(2*L)];
end