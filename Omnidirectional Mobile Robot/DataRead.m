Data5000 = xlsread("Data1-2-4-5-6-7-10-11.xlsx");
Data1000 = xlsread("Data8-9-12-13-14-15.xlsx");
Angle5000 = zeros(5000, 4, 8);
Angle1000 = zeros(1000, 4, 6);
t5000 = zeros(5000, 8);
t1000 = zeros(1000, 6);
Angle5000(:, :, 1) = Data5000(:, 1:4);
Angle5000(:, :, 2) = Data5000(:, 6:9);
Angle5000(:, :, 3) = Data5000(:, 11:14);
Angle5000(:, :, 4) = Data5000(:, 16:19);
Angle5000(:, :, 5) = Data5000(:, 21:24);
Angle5000(:, :, 6) = Data5000(:, 26:29);
Angle5000(:, :, 7) = Data5000(:, 31:34);
Angle5000(:, :, 8) = Data5000(:, 36:39);
Angle1000(:, :, 1) = Data1000(:, 1:4);
Angle1000(:, :, 2) = Data1000(:, 6:9);
Angle1000(:, :, 3) = Data1000(:, 11:14);
Angle1000(:, :, 4) = Data1000(:, 16:19);
Angle1000(:, :, 5) = Data1000(:, 21:24);
Angle1000(:, :, 6) = Data1000(:, 26:29);
for i = 1:8
    for j = 2:5000
        t5000(j, i) = Data5000(j - 1, i*5)/1000000;
    end
end
for i = 1:6
    for j = 2:1000
        t1000(j, i) = Data1000(j - 1, i*5)/1000000;
    end
end
for i = 2:5000
    t5000(i, :) = t5000(i - 1) + t5000(i, :);
end
for i = 2:1000
    t1000(i, :) = t1000(i - 1) + t1000(i, :);
end
% Encoder
figure;
for i = 1:8
    subplot(2, 4, i);
    plot(t5000(:, i), Angle5000(:, 1, i));
    hold on;
    plot(t5000(:, i), Angle5000(:, 2, i));
    hold on;
    plot(t5000(:, i), Angle5000(:, 3, i));
    hold on;
    plot(t5000(:, i), Angle5000(:, 4, i));
    grid on;
    title(i);
end
figure;
for i = 1:6
    subplot(2, 3, i);
    plot(t1000(:, i), Angle1000(:, 1, i));
    hold on;
    plot(t1000(:, i), Angle1000(:, 2, i));
    hold on;
    plot(t1000(:, i), Angle1000(:, 3, i));
    hold on;
    plot(t1000(:, i), Angle1000(:, 4, i));
    grid on;
    title(i);
end
u5000 = zeros(5000, 4, 8);
u1000 = zeros(1000, 4, 6);
u5000(:, :, 1) = [-pi*sin(2*pi*t5000(:, 1)/t5000(5000, 1)), -pi*sin(2*pi*t5000(:, 1)/t5000(5000, 1)), pi*sin(2*pi*t5000(:, 1)/t5000(5000, 1)), pi*sin(2*pi*t5000(:, 1)/t5000(5000, 1))];
u5000(:, :, 2) = [zeros(5000, 1), -pi*sin(2*pi*t5000(:, 2)/t5000(5000, 2)), zeros(5000, 1), pi*sin(2*pi*t5000(:, 2)/t5000(5000, 2))];
u5000(:, :, 3) = [-pi/2*sin(2*pi*t5000(:, 3)/t5000(5000, 3)), -pi/2*sin(2*pi*t5000(:, 3)/t5000(5000, 3)), -pi/2*sin(2*pi*t5000(:, 3)/t5000(5000, 3)), -pi/2*sin(2*pi*t5000(:, 3)/t5000(5000, 3))];
u5000(:, :, 4) = [-pi*sin(2*pi*t5000(:, 4)/t5000(5000, 4)), -pi*sin(2*pi*t5000(:, 4)/t5000(5000, 4))/2, pi*sin(2*pi*t5000(:, 4)/t5000(5000, 4)), pi*sin(2*pi*t5000(:, 4)/t5000(5000, 4))/2];
u5000(:, :, 5) = [-pi*sin(2*pi*t5000(:, 5)/t5000(5000, 5)), -pi*sin(2*pi*t5000(:, 5)/t5000(5000, 5))/2, pi*sin(2*pi*t5000(:, 5)/t5000(5000, 5)), pi*sin(2*pi*t5000(:, 5)/t5000(5000, 5))/2];
u5000(:, :, 6) = [-pi*sin(2*pi*t5000(:, 6)/t5000(5000, 6)), -pi*sin(2*pi*t5000(:, 6)/t5000(5000, 6))/2, pi*sin(2*pi*t5000(:, 6)/t5000(5000, 6)), pi*sin(2*pi*t5000(:, 6)/t5000(5000, 6))/2];
u1000(:, :, 1) = [-pi*sin(2*pi*t1000(:, 1)/t1000(1000, 1)), -pi*sin(2*pi*t1000(:, 1)/t1000(1000, 1))/2, pi*sin(2*pi*t1000(:, 1)/t1000(1000, 1)), pi*sin(2*pi*t1000(:, 1)/t1000(1000, 1))/2];
u1000(:, :, 2) = [-2*pi*sin(2*pi*t1000(:, 2)/t1000(1000, 2)), -2*pi*sin(2*pi*t1000(:, 2)/t1000(1000, 2)), 2*pi*sin(2*pi*t1000(:, 2)/t1000(1000, 2)), 2*pi*sin(2*pi*t1000(:, 2)/t1000(1000, 2))];
u5000(:, :, 7) = [-pi/5*cos(2*pi*t5000(:, 7)/t5000(5000, 7)), pi/5*sin(2*pi*t5000(:, 7)/t5000(5000, 7)), pi/5*cos(2*pi*t5000(:, 7)/t5000(5000, 7)), -pi/5*sin(2*pi*t5000(:, 7)/t5000(5000, 7))];
u5000(:, :, 8) = [-pi/2*cos(2*pi*t5000(:, 8)/t5000(5000, 8)), pi/2*sin(2*pi*t5000(:, 8)/t5000(5000, 8)), pi/2*cos(2*pi*t5000(:, 8)/t5000(5000, 8)), -pi/2*sin(2*pi*t5000(:, 8)/t5000(5000, 8))];
u1000(:, :, 3) = [-pi*cos(2*pi*t1000(:, 3)/t1000(1000, 3)), pi*sin(2*pi*t1000(:, 3)/t1000(1000, 3)), pi*cos(2*pi*t1000(:, 3)/t1000(1000, 3)), -pi*sin(2*pi*t1000(:, 3)/t1000(1000, 3))];
u1000(:, :, 4) = [-2*pi*cos(2*pi*t1000(:, 4)/t1000(1000, 4)), 2*pi*sin(2*pi*t1000(:, 4)/t1000(1000, 4)), 2*pi*cos(2*pi*t1000(:, 4)/t1000(1000, 4)), -2*pi*sin(2*pi*t1000(:, 4)/t1000(1000, 4))];
u1000(:, :, 5) = [-4*pi*cos(2*pi*t1000(:, 5)/t1000(1000, 5)), 4*pi*sin(2*pi*t1000(:, 5)/t1000(1000, 5)), 4*pi*cos(2*pi*t1000(:, 5)/t1000(1000, 5)), -4*pi*sin(2*pi*t1000(:, 5)/t1000(1000, 5))];
u1000(:, :, 6) = [-pi*sin(pi*t1000(:, 6)/t1000(1000, 6)).*cos(2*pi*t1000(:, 6)/t1000(1000, 6)), pi*sin(pi*t1000(:, 6)/t1000(1000, 6)).*sin(2*pi*t1000(:, 6)/t1000(1000, 6)), pi*sin(pi*t1000(:, 6)/t1000(1000, 6)).*cos(2*pi*t1000(:, 6)/t1000(1000, 6)), -pi*sin(pi*t1000(:, 6)/t1000(1000, 6)).*sin(2*pi*t1000(:, 6)/t1000(1000, 6))];



w5000 = zeros(5000, 4, 8);
w1000 = zeros(1000, 4, 6);
for i = 2:5000
    for j = 1:8
        w5000(i, :, j) = (u5000(i, :, j) - u5000(i - 1, :, j))/(t5000(i, j) - t5000(i - 1, j));
    end
end
for i = 2:1000
    for j = 1:6
        w1000(i, :, j) = (u1000(i, :, j) - u1000(i - 1, :, j))/(t1000(i, j) - t1000(i - 1, j));
    end
end
figure;
for i = 1:8
    subplot(3, 5, i);
    plot(t5000(:, i), u5000(:, 1, i));
    hold on;
    plot(t5000(:, i), u5000(:, 2, i));
    hold on;
    plot(t5000(:, i), u5000(:, 3, i));
    hold on;
    plot(t5000(:, i), u5000(:, 4, i));
    grid on;
    title(i);
end
for i = 1:6
    subplot(3, 5, i + 8);
    plot(t1000(:, i), u1000(:, 1, i));
    hold on;
    plot(t1000(:, i), u1000(:, 2, i));
    hold on;
    plot(t1000(:, i), u1000(:, 3, i));
    hold on;
    plot(t1000(:, i), u1000(:, 4, i));
    grid on;
    title(i + 8);
end





Ref5000 = zeros(5000, 4, 8);
Ref1000 = zeros(1000, 4, 6);
for i = 2:5000
    for j = 1:8
        Ref5000(i, :, j) = u5000(i - 1, :, j)*(t5000(i, j) - t5000(i - 1, j)) + Ref5000(i - 1, :, j);
    end
end
for i = 2:1000
    for j = 1:6
        Ref1000(i, :, j) = u1000(i - 1, :, j)*(t1000(i, j) - t1000(i - 1, j)) + Ref1000(i - 1, :, j);
    end
end
% Ref
figure;
for i = 1:8
    subplot(2, 4, i);
    plot(t5000(:, i), Ref5000(:, 1, i));
    hold on;
    plot(t5000(:, i), Ref5000(:, 2, i));
    hold on;
    plot(t5000(:, i), Ref5000(:, 3, i));
    hold on;
    plot(t5000(:, i), Ref5000(:, 4, i));
    grid on;
    title(i);
end
figure;
for i = 1:6
    subplot(2, 3, i);
    plot(t1000(:, i), Ref1000(:, 1, i));
    hold on;
    plot(t1000(:, i), Ref1000(:, 2, i));
    hold on;
    plot(t1000(:, i), Ref1000(:, 3, i));
    hold on;
    plot(t1000(:, i), Ref1000(:, 4, i));
    grid on;
    title(i + 8);
end
% Error
figure;
for i = 1:8
    subplot(2, 4, i);
    plot(t5000(:, i), Ref5000(:, 1, i) - Angle5000(:, 1, i));
    hold on;
    plot(t5000(:, i), Ref5000(:, 2, i) - Angle5000(:, 2, i));
    hold on;
    plot(t5000(:, i), Ref5000(:, 3, i) - Angle5000(:, 3, i));
    hold on;
    plot(t5000(:, i), Ref5000(:, 4, i) - Angle5000(:, 4, i));
    grid on;
    title(i);
end
figure;
for i = 1:6
    subplot(2, 3, i);
    plot(t1000(:, i), Ref1000(:, 1, i) - Angle1000(:, 1, i));
    hold on;
    plot(t1000(:, i), Ref1000(:, 2, i) - Angle1000(:, 2, i));
    hold on;
    plot(t1000(:, i), Ref1000(:, 3, i) - Angle1000(:, 3, i));
    hold on;
    plot(t1000(:, i), Ref1000(:, 4, i) - Angle1000(:, 4, i));
    grid on;
    title(i);
end
% u1 = zeros(5000, 8);
% y1 = zeros(5000, 8);
% u2 = zeros(1000, 6);
% y2 = zeros(1000, 6);
% for i = 1:5000
%     for j = 1:8
%         u1(i, j) = Ref5000(i, 1, j);
%         y1(i, j) = Angle5000(i, 1, j);
%     end
% end
% for i = 1:1000
%     for j = 1:6
%         u2(i, j) = Ref1000(i, 1, j);
%         y2(i, j) = Angle1000(i, 1, j);
%     end
% end
%%
Data1 = xlsread("1.xlsx");
Data2 = xlsread("2.xlsx");
Data4 = xlsread("4.xlsx");
Data5 = xlsread("5.xlsx");
Data6 = xlsread("6.xlsx");
Data7 = xlsread("7.xlsx");
Data8 = xlsread("8.xlsx");
Data9 = xlsread("9.xlsx");
Data10 = xlsread("10.xlsx");
Data11 = xlsread("11.xlsx");
Data12 = xlsread("12.xlsx");
Data13 = xlsread("13.xlsx");
Data14 = xlsread("14.xlsx");
Data15 = xlsread("15.xlsx");
pix2mtr = 0.1/74;
X1 = Data1(:, 1)*pix2mtr;
Y1 = Data1(:, 2)*pix2mtr;
Theta1 = Data1(:, 3);
X2 = Data2(:, 1)*pix2mtr;
Y2 = Data2(:, 2)*pix2mtr;
Theta2 = Data2(:, 3);
X4 = Data4(:, 1)*pix2mtr;
Y4 = Data4(:, 2)*pix2mtr;
Theta4 = Data4(:, 3);
X5 = Data5(:, 1)*pix2mtr;
Y5 = Data5(:, 2)*pix2mtr;
Theta5 = Data5(:, 3);
X6 = Data6(:, 1)*pix2mtr;
Y6 = Data6(:, 2)*pix2mtr;
Theta6 = Data6(:, 3);
X7 = Data7(:, 1)*pix2mtr;
Y7 = Data7(:, 2)*pix2mtr;
Theta7 = Data7(:, 3);
X8 = Data8(:, 1)*pix2mtr;
Y8 = Data8(:, 2)*pix2mtr;
Theta8 = Data8(:, 3);
X9 = Data9(:, 1)*pix2mtr;
Y9 = Data9(:, 2)*pix2mtr;
Theta9 = Data9(:, 3);
X10 = Data10(:, 1)*pix2mtr;
Y10 = Data10(:, 2)*pix2mtr;
Theta10 = Data10(:, 3);
X11 = Data11(:, 1)*pix2mtr;
Y11 = Data11(:, 2)*pix2mtr;
Theta11 = Data11(:, 3);
X12 = Data12(:, 1)*pix2mtr;
Y12 = Data12(:, 2)*pix2mtr;
Theta12 = Data12(:, 3);
X13 = Data13(:, 1)*pix2mtr;
Y13 = Data13(:, 2)*pix2mtr;
Theta13 = Data13(:, 3);
X14 = Data14(:, 1)*pix2mtr;
Y14 = Data14(:, 2)*pix2mtr;
Theta14 = Data14(:, 3);
X15 = Data15(:, 1)*pix2mtr;
Y15 = Data15(:, 2)*pix2mtr;
Theta15 = Data15(:, 3);
X1 = X1 - X1(1)*ones(1, length(X1))';
Y1 = Y1 - Y1(1)*ones(1, length(Y1))';
X2 = X2 - X2(1)*ones(1, length(X2))';
Y2 = Y2 - Y2(1)*ones(1, length(Y2))';
X4 = X4 - X4(1)*ones(1, length(X4))';
Y4 = Y4 - Y4(1)*ones(1, length(Y4))';
X5 = X5 - X5(1)*ones(1, length(X5))';
Y5 = Y5 - Y5(1)*ones(1, length(Y5))';
X6 = X6 - X6(1)*ones(1, length(X6))';
Y6 = Y6 - Y6(1)*ones(1, length(Y6))';
X7 = X7 - X7(1)*ones(1, length(X7))';
Y7 = Y7 - Y7(1)*ones(1, length(Y7))';
X8 = X8 - X8(1)*ones(1, length(X8))';
Y8 = Y8 - Y8(1)*ones(1, length(Y8))';
X9 = X9 - X9(1)*ones(1, length(X9))';
Y9 = Y9 - Y9(1)*ones(1, length(Y9))';
X10 = X10 - X10(1)*ones(1, length(X10))';
Y10 = Y10 - Y10(1)*ones(1, length(Y10))';
X11 = X11 - X11(1)*ones(1, length(X11))';
Y11 = Y11 - Y11(1)*ones(1, length(Y11))';
X12 = X12 - X12(1)*ones(1, length(X12))';
Y12 = Y12 - Y12(1)*ones(1, length(Y12))';
X13 = X13 - X13(1)*ones(1, length(X13))';
Y13 = Y13 - Y13(1)*ones(1, length(Y13))';
X14 = X14 - X14(1)*ones(1, length(X14))';
Y14 = Y14 - Y14(1)*ones(1, length(Y14))';
X15 = X15 - X15(1)*ones(1, length(X15))';
Y15 = Y15 - Y15(1)*ones(1, length(Y15))';
T = [1/29.56, 1/29.43, 1/30, 1/29.43, 1/29.78, 1/29.75, 1/29.8, 1/29.3, 1/29.18, 1/29.74, 1/29.29, 1/29.3, 1/29.73, 1/29.14, 1/29.75];
t1 = 0:T(1):535*T(1) - T(1);
X1 = X1(227:761);
Y1 = -Y1(227:761);
Theta1 = Theta1(227:761);
t2 = 0:T(2):410*T(2) - T(2);
X2 = X2(262:671);
Y2 = -Y2(262:671);
Theta2 = Theta2(262:671);
t4 = 0:T(4):473*T(4) - T(4);
X4 = X4(241:713);
Y4 = -Y4(241:713);
Theta4 = Theta4(241:713);
t5 = 0:T(5):519*T(5) - T(5);
X5 = X5(242:760);
Y5 = -Y5(242:760);
Theta5 = Theta5(242:760);
t6 = 0:T(6):515*T(6) - T(6);
X6 = X6(156:670);
Y6 = -Y6(156:670);
Theta6 = Theta6(156:670);
t7 = 0:T(7):491*T(7) - T(7);
X7 = X7(226:716);
Y7 = -Y7(226:716);
Theta7 = Theta7(226:716);
t8 = 0:T(8):107*T(8) - T(8);
X8 = X8(190:296);
Y8 = -Y8(190:296);
Theta8 = Theta8(190:296);
t9 = 0:T(9):109*T(9) - T(9);
X9 = X9(241:349);
Y9 = -Y9(241:349);
Theta9 = Theta9(241:349);
t10 = 0:T(10):531*T(10) - T(10);
X10 = X10(226:756);
Y10 = -Y10(226:756);
Theta10 = Theta10(226:756);
t11 = 0:T(11):538*T(11) - T(11);
X11 = X11(48:585);
Y11 = -Y11(48:585);
Theta11 = Theta11(48:585);
t12 = 0:T(12):116*T(12) - T(12);
X12 = X12(237:352);
Y12 = -Y12(237:352);
Theta12 = Theta12(237:352);
t13 = 0:T(13):122*T(13) - T(13);
X13 = X13(228:349);
Y13 = -Y13(228:349);
Theta13 = Theta13(228:349);
t14 = 0:T(14):141*T(14) - T(14);
X14 = X14(223:363);
Y14 = -Y14(223:363);
Theta14 = Theta14(223:363);
t15 = 0:T(15):105*T(15) - T(15);
X15 = X15(251:355);
Y15 = -Y15(251:355);
Theta15 = Theta15(251:355);
t1 = t1';
t2 = t2';
t4 = t4';
t5 = t5';
t6 = t6';
t7 = t7';
t8 = t8';
t9 = t9';
t10 = t10';
t11 = t11';
t12 = t12';
t13 = t13';
t14 = t14';
t15 = t15';

figure;
subplot(3, 5, 1);
plot(t1, X1);
hold on;
plot(t1, Y1);
hold on;
plot(t1, Theta1);
grid on;
title(1);
subplot(3, 5, 2);
plot(t2, X2);
hold on;
plot(t2, Y2);
hold on;
plot(t2, Theta2);
grid on;
title(2);
subplot(3, 5, 3);
plot(t4, X4);
hold on;
plot(t4, Y4);
hold on;
plot(t4, Theta4);
grid on;
title(3);
subplot(3, 5, 4);
plot(t5, X5);
hold on;
plot(t5, Y5);
hold on;
plot(t5, Theta5);
grid on;
title(4);
subplot(3, 5, 5);
plot(t6, X6);
hold on;
plot(t6, Y6);
hold on;
plot(t6, Theta6);
grid on;
title(5);
subplot(3, 5, 6);
plot(t7, X7);
hold on;
plot(t7, Y7);
hold on;
plot(t7, Theta7);
grid on;
title(6);
subplot(3, 5, 7);
plot(t10, X10);
hold on;
plot(t10, Y10);
hold on;
plot(t10, Theta10);
grid on;
title(7);
subplot(3, 5, 8);
plot(t11, X11);
hold on;
plot(t11, Y11);
hold on;
plot(t11, Theta11);
grid on;
title(8);
subplot(3, 5, 9);
plot(t8, X8);
hold on;
plot(t8, Y8);
hold on;
plot(t8, Theta8);
grid on;
title(9);
subplot(3, 5, 10);
plot(t9, X9);
hold on;
plot(t9, Y9);
hold on;
plot(t9, Theta9);
grid on;
title(10);
subplot(3, 5, 11);
plot(t12, X12);
hold on;
plot(t12, Y12);
hold on;
plot(t12, Theta12);
grid on;
title(11);
subplot(3, 5, 12);
plot(t13, X13);
hold on;
plot(t13, Y13);
hold on;
plot(t13, Theta13);
grid on;
title(12);
subplot(3, 5, 13);
plot(t14, X14);
hold on;
plot(t14, Y14);
hold on;
plot(t14, Theta14);
grid on;
title(13);
subplot(3, 5, 14);
plot(t15, X15);
hold on;
plot(t15, Y15);
hold on;
plot(t15, Theta15);
grid on;
title(14);









figure;
subplot(3, 5, 1);
plot(X1, Y1);
grid on;
title(1);
subplot(3, 5, 2);
plot(X2, Y2);
grid on;
title(2);
subplot(3, 5, 3);
plot(X4, Y4);
grid on;
title(3);
subplot(3, 5, 4);
plot(X5, Y5);
grid on;
title(4);
subplot(3, 5, 5);
plot(X6, Y6);
grid on;
title(5);
subplot(3, 5, 6);
plot(X7, Y7);
grid on;
title(6);
subplot(3, 5, 7);
plot(X10, Y10);
grid on;
title(7);
subplot(3, 5, 8);
plot(X11, Y11);
grid on;
title(8);
subplot(3, 5, 9);
plot(X8, Y8);
grid on;
title(9);
subplot(3, 5, 10);
plot(X9, Y9);
grid on;
title(10);
subplot(3, 5, 11);
plot(X12, Y12);
grid on;
title(11);
subplot(3, 5, 12);
plot(X13, Y13);
grid on;
title(12);
subplot(3, 5, 13);
plot(X14, Y14);
grid on;
title(13);
subplot(3, 5, 14);
plot(X15, Y15);
grid on;
title(14);









plot(t7, X7);
hold on;
plot(t7, Y7);
grid on;
plot(X4, Y4)