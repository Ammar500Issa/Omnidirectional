#include <AccelStepper.h>
#include <MultiStepper.h>
#include <TimerOne.h>

AccelStepper S1(1, 8, 7);
AccelStepper S2(1, 10, 4);
AccelStepper S3(1, 9, 5);
AccelStepper S4(1, 11, 6);
MultiStepper S;

#define encPin1 19
#define encPin2 2
#define encPin3 3
#define encPin4 18

double r = 0.05;
double L = 0.15;
double Bv = 0.038709;
double Bw = 0.0008517;
double Cv = 0.019178;
double Cw = 0.099875;
//double Bv = 0.5;
//double Bw = 0;
//double Cv = 2;
//double Cw = 0;
double J = 0.45923;
double M = 9.1;
double mu_p = 0;
double g = 9.81;
// uncertainities
double dBv = 0.001;
double dCv = 0.001;
double dBw = 0.0001;
double dCw = 0.01;
//double dBv = 0;
//double dCv = 0;
//double dBw = 0;
//double dCw = 0;

//Controller coeff
double lambda1 = 2.75;
double lambda2 = 2.75;
double lambda3 = 5;
double eta1 = 1;
double eta2 = 1;
double eta3 = 1;
double K1 = 2.5;
double K2 = 2.5;
double K3 = 20;

int dir1 = 0;
int dir2 = 0;
int dir3 = 0;
int dir4 = 0;

double T = 0.01;
unsigned long previousMicros = 0;

// encoders
volatile double pos1 = 0;
volatile double pos2 = 0;
volatile double pos3 = 0;
volatile double pos4 = 0;

double lastPos1 = 0;
double lastPos2 = 0;
double lastPos3 = 0;
double lastPos4 = 0;
double lastTheta = 0;
double lastX = 0;
double lastY = 0;
double Xd = 0.7;
double Yd = 0;
double lastFreq1 = 0;
double lastFreq2 = 0;
double lastFreq3 = 0;
double lastFreq4 = 0;

// from camera
float XC = 0;
float YC = 0;
float ThetaC = 0;

void setup()
{  
  Serial.begin(115200);
  S1.setMaxSpeed(5000);
  S2.setMaxSpeed(5000);
  S3.setMaxSpeed(5000);
  S4.setMaxSpeed(5000);
  S1.setAcceleration(5000);
  S2.setAcceleration(5000);
  S3.setAcceleration(5000);
  S4.setAcceleration(5000);
//  S.addStepper(S1);
//  S.addStepper(S2);
//  S.addStepper(S3);
//  S.addStepper(S4);
  pinMode(encPin1, INPUT_PULLUP);
  pinMode(encPin2, INPUT_PULLUP);
  pinMode(encPin3, INPUT_PULLUP);
  pinMode(encPin4, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(encPin1), encoder1Interrupt, CHANGE);
  attachInterrupt(digitalPinToInterrupt(encPin2), encoder2Interrupt, CHANGE);
  attachInterrupt(digitalPinToInterrupt(encPin3), encoder3Interrupt, CHANGE);
  attachInterrupt(digitalPinToInterrupt(encPin4), encoder4Interrupt, CHANGE);
//  delay(10000);
  Timer1.initialize(1000000*T); // set timer to T seconds
  Timer1.attachInterrupt(timerISR);
  sei();
}

void encoder1Interrupt() {
  if(dir1 > 0)
    pos1 += TWO_PI/2048.0;
  else if(dir1 < 0)
    pos1 -= TWO_PI/2048.0;
}

void encoder2Interrupt() {
  if(dir2 > 0)
    pos2 += TWO_PI/2048.0;
  else if(dir2 < 0)
    pos2 -= TWO_PI/2048.0;
}

void encoder3Interrupt() {
  if(dir3 > 0)
    pos3 += TWO_PI/2048.0;
  else if(dir3 < 0)
    pos3 -= TWO_PI/2048.0;
}

void encoder4Interrupt() {
  if(dir4 > 0)
    pos4 += TWO_PI/2048.0;
  else if(dir4 < 0)
    pos4 -= TWO_PI/2048.0;
}

void InvKinematic(double w[], double V[]) { //w: rad/sec. V[0], V[1]: m/sec. V[2]: rad/sec.
  w[0] = 1/r*(V[1] + L*V[2]);
  w[1] = 1/r*(-V[0] + L*V[2]);
  w[2] = 1/r*(-V[1] + L*V[2]);
  w[3] = 1/r*(V[0] + L*V[2]);
}

int sign(double X) {
  if(X > 0) {
    return 1;
  }
  else if(X < 0) {
    return -1;
  }
  else
    return 0;
}

double sat(double X) {
  double Y_sat = 1;
  double X_sat = 0.1;
  if(X > X_sat) {
    return 1;
  }
  else if(X < -X_sat) {
    return -1;
  }
  else
    return X*Y_sat/X_sat;
}

void timerISR() 
{
    double w[4];
    w[0] = (pos1 - lastPos1)/T;
    w[1] = (pos2 - lastPos2)/T;
    w[2] = (pos3 - lastPos3)/T;
    w[3] = (pos4 - lastPos4)/T;
//    w[0] = lastFreq1;
//    w[1] = lastFreq2;
//    w[2] = lastFreq3;
//    w[3] = lastFreq4;
    lastPos1 = pos1;
    lastPos2 = pos2;
    lastPos3 = pos3;
    lastPos4 = pos4;
    double Vxb = 0.5*r*(w[3] - w[1]);
    double Vyb = 0.5*r*(w[0] - w[2]);
    double dTheta = 0.25*r/L*(w[0] + w[1] + w[2] + w[3]);
    double Theta = dTheta*T + lastTheta;
    if(Theta > PI) {
      Theta -= TWO_PI;
    }
    else if(Theta < -PI) {
      Theta += TWO_PI;
    }
//    Theta = ThetaC;
    lastTheta = Theta;
    double Vx = cos(Theta)*Vxb - sin(Theta)*Vyb;
    double Vy = cos(Theta)*Vyb + sin(Theta)*Vxb;
    double X = Vx*T + lastX;
    double Y = Vy*T + lastY;
//    X = XC;
//    Y = YC;
    Vx = (X - lastX)/T;
    Vy = (Y - lastY)/T;
    dTheta = (Theta - lastTheta)/T;
    lastX = X;
    lastY = Y;
    double ex = X - Xd;
    double ey = Y - Yd;
    double u[4];
    u[0] = (1/(r*M))*(Bv*Vy + Cv*sign(Vy)) - (lambda2/r)*Vy;
    u[2] = -u[0];
    u[3] = (1/(r*M))*(Bv*Vx + Cv*sign(Vx)) - (lambda1/r)*Vx;
    u[1] = -u[3];
    double uy = -(K2/r)*(eta2 + (dBv/M)*abs(Vy) + dCv/M + mu_p*g)*sat(Vy + lambda2*ey);
    double ux = -(K1/r)*(eta1 + (dBv/M)*abs(Vx) + dCv/M + mu_p*g)*sat(Vx + lambda1*ex);
    u[0] += uy;
    u[2] -= uy;
    u[1] -= ux;
    u[3] += ux;
    double uTheta = 1/(2*L*M*r)*((Bw - J*lambda3)*dTheta + Cw*sign(dTheta) - K3*(J*eta3 + dBw*abs(dTheta) + dCw + L*M*mu_p*g)*sign(dTheta + lambda3*Theta));
    u[0] += uTheta;
    u[1] += uTheta;
    u[2] += uTheta;
    u[3] += uTheta;
    double f[4];
    f[0] = u[0]*T + lastFreq1;
    f[1] = u[1]*T + lastFreq2;
    f[2] = u[2]*T + lastFreq3;
    f[3] = u[3]*T + lastFreq4;
    lastFreq1 = f[0];
    lastFreq2 = f[1];
    lastFreq3 = f[2];
    lastFreq4 = f[3];
    S1.setSpeed(f[0]*100/PI);
    S2.setSpeed(f[1]*100/PI);
    S3.setSpeed(f[2]*100/PI);
    S4.setSpeed(f[3]*100/PI);
    dir1 = sign(f[0]);
    dir2 = sign(f[1]);
    dir3 = sign(f[2]);
    dir4 = sign(f[3]);
    double s[8];
    s[0] = u[0];
    s[1] = u[1];
    s[2] = u[2];
    s[3] = u[3];
    s[4] = w[0];
    s[5] = w[1];
    s[6] = w[2];
    s[7] = w[3];
    String str1;
    String str2;
    String str3;
    String str4;
    String str5;
    String str6;
    String str7;
    String str8;
    char str[100] = "";
    strcat(str, "%");
    for (int i = 0; i < 8; i++) {
      char temp[10];
      dtostrf(s[i], 5, 2, temp); // convert double to string with sign and 2 decimal points
      strcat(str, temp); // concatenate string
      if (i < 7) { // add "#" between values except for the last one
        strcat(str, "#");
      }
    }
    strcat(str, "%");
}

void loop()
{
  if (Serial.available() >= 12) {
    byte buffer[12];
    Serial.readBytes(buffer, 12);
    memcpy(&XC, &buffer[0], 4);
    memcpy(&YC, &buffer[4], 4);
    memcpy(&ThetaC, &buffer[8], 4);
    Serial.print("X: ");
    Serial.println(XC);
    Serial.print("Y: ");
    Serial.println(YC);
    Serial.print("Theta: ");
    Serial.println(ThetaC);
  }
  unsigned long currentMicros = micros();
  S1.run();
  S2.run();
  S3.run();
  S4.run();
}
