function InvJb = PseudoInvJacobianb()
    InvJb = [0, 1, L;
             -1, 0, L;
             0, -1, L;
             1, 0, L];
end