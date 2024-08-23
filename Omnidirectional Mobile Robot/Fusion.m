% f = fopen('CameraXYTheta.txt', 'r');
clear;
clc;
format = '%f';
T = 0.01;
lastX = [0; 0; 0];
lastV = [0; 0; 0];
newobj = instrfind;
if(isempty(newobj))
else
    fclose(newobj);
end
ser = serial('COM17', 'BaudRate', 115200);
set(ser, 'FlowControl', 'hardware');
set(ser, 'BaudRate', 115200);
set(ser, 'InputBufferSize', 65);
set(ser, 'DataBits', 8);
set(ser, 'StopBit', 1);
set(ser, 'Timeout', 1000000);
fopen(ser);
while(1 == 1)
    f = fopen('CameraXYTheta.txt', 'r');
    X = fscanf(f, format);
    fclose(f);
    if(length(X) ~= 3)
        X = lastX;
        V = lastV;
    else
        V = (X - lastX)/T;
    end
    lastV = V;
    lastX = X;
    frame = fread(ser);
    sv = zeros(8, 7);
    if(char(frame(1)) == '%')
        j = 1;
        k = 1;
        for i = 1:length(frame)
            if(char(frame(i)) == '#')
                frame(j:i - 1)
                sv(k, j:i - 1) = char(frame(j:i - 1));
                k = k + 1;
                j = i + 1;
            end
            if(char(frame(i)) == '%')
                sv = char(frame(j:i - 1));
                break;
            end
        end
        u = zeros(4, 1);
        w = zeros(4, 1);
        for i = 1:4
            u(i) = str2double(sv(i, :));
            w(i) = str2double(sv(i + 4, :));
        end
    end
end
fclose(ser);
newobj = instrfind;
fclose(newobj);