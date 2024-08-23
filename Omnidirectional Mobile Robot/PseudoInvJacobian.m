function InvJ = PseudoInvJacobian(theta, L)
    S = sin(theta);
    C = cos(theta);
    InvJ = [-S, C, L;
            -C, -S, L;
            S, -C, L;
            C, S, L];
end