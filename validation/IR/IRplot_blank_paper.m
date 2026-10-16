clear all
close all
clc

%% plotting IR Data 

%% import data

A1 = load('shot50.txt');
t1 = A1(:,1);
T1 = A1(:,2);
%compression
R = 100;
i = 1*R;
while i < length(T1)
    T1c(i/R) = T1(i);
    t1c(i/R) = t1(i);
    i = i+R;
end
T1 = T1c;
t1 = t1c;

A2 = load('shot46.txt');
% A2 = load('IRtempDRYlong8MW.txt');
t2 = A2(:,1);
T2 = A2(:,2);
% T2 = T2-273; % from K to C


A3 = load('IRtempDRY89MW.txt'); % RED
t3 = A3(:,1);
T3 = A3(:,2);
T3 = T3-273; 
%compression
% R = 1;
% i = 1*R;
% while i < length(T3)
%     T3c(i/R) = T3(i);
%     t3c(i/R) = t3(i);
%     i = i+R;
% end
% T3 = T3c;
% t3 = t3c;

A4 = load('IRtempDRYlong8MW.txt'); % BLACK
t4 = A4(:,1);
T4 = A4(:,2);
T4 = T4-273; % from K to C

%% zero line

xzero = [0 0];
yzero = [0 5000];



%% correct timing
shift = 9;
% io1 = find(T1>300); % index of t=0
% to1 = t1(io1(1));
t1 = t1-shift;
% 
% io2 = find(T2>300); % index of t=0
% to2 = t2(io2(1));
t2 = t2-shift-0.3;
% 
% io3 = find(T3>300); % index of t=0
% to3 = t3(io3(1));
t3 = t3+1.5-shift;

t4 = t4+1.5-shift;

%% plot

line(t1,T1,'LineWidth',1.5,'Color','black')
hold on
line(t2,T2,'LineWidth',1.5,'Color','red','LineStyle','-') %200ev no conduction
line(t4,T4,'LineWidth',0.5,'Color','black','LineStyle','--') %5ev no conduction
line(t3,T3,'LineWidth',0.5,'Color','red','LineStyle','--')
line(xzero,yzero,'LineWidth',0.5,'Color','black','LineStyle','-.')
grid on
axis([-7 20 0 2000])
legend('IR-cam shot 50','IR-cam shot 46','FEM 8 MW/m^2','FEM 9 MW/m^2','Location','nw')
xlabel('Time [s]')
ylabel('Temperature [^oC]')



