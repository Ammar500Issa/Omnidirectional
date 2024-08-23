function Jb = Jacobianb(L)
    Jb = 0.5*[0, -1, 0, 1;
              1, 0, -1, 0;
              1/(2*L), 1/(2*L), 1/(2*L), 1/(2*L)];
end