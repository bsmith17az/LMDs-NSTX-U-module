clear all
close all
clc

%% plotting IR Data 

%% import data

A1 = load('shot49meansmall.txt');
t1 = A1(:,1);
T1 = A1(:,2);
%compression
R = 1;
i = 1*R;
while i < length(T1)
    T1c(i/R) = T1(i);
    t1c(i/R) = t1(i);
    i = i+R;
end
T1 = T1c;
t1 = t1c;

A2 = load('shot46.txt'); % should be 46
t2 = A2(:,1);
T2 = A2(:,2);
% T2 = T2-273; % from K to C


A3 = load('shot52new.txt');
t3 = A3(:,1);
T3 = A3(:,2);
%compression
R = 100;
i = 1*R;
while i < length(T3)
    T3c(i/R) = T3(i);
    t3c(i/R) = t3(i);
    i = i+R;
end
T3 = T3c;
t3 = t3c;

A4 = load('IRtempWet5EV8MW_2c.txt'); % blue
t4 = A4(:,1);
T4 = A4(:,2);
T4 = T4-273; % from K to C

A4b = load('IRtempWet5EV8MW_2c_novapor.txt'); % blue
t4b = A4b(:,1);
T4b = A4b(:,2);
T4b = T4b-273; % from K to C

A5 = load('IRtempWet5EV89MWbubble3mm09R.txt'); % red
% A5 = load('IRtempWet5EV8MW_2d.txt');
t5 = A5(:,1);
T5 = A5(:,2);
T5 = T5-273; % from K to C 

A6 = load('PowerFracWet5EV8MW_2c.txt');
t6 = A6(:,1);
T6 = A6(:,2);
% T6 = T6-273; % from K to C

A7 = load('PowerFracWet5EV89MWbubble3mm09R.txt');
t7 = A7(:,1);
T7 = A7(:,2);
% T7 = T7-273; % from K to C
% or use the theoretical prediction of ~1170C 



%% correct timing
shift = 9;
% io1 = find(T1>300); % index of t=0
% to1 = t1(io1(1));
t1 = t1-shift; %% IR 49
% 
% io2 = find(T2>300); % index of t=0
% to2 = t2(io2(1));
t2 = t2-shift; % IR 50 or 46
% 
% io3 = find(T3>300); % index of t=0
% to3 = t3(io3(1));
t3 = t3+0.2-shift; % IR 52

t4 = t4+1.5-shift; % FEM 49 wet 
t4b = t4b+1.5-shift; % FEM 49 wet 

t5 = t5+1.5-shift; % FEM 52 wet mesh

t6 = t6+1.5-shift; %

t7 = t7+1.7-shift;


%% plot

figure 
subplot(3,1,1:2)
hold on
% line(t2,T2,'LineWidth',1.5,'Color','black','LineStyle','-') 
line(t3,T3,'LineWidth',1.5,'Color','red')
line(t5,T5,'LineWidth',0.5,'Color','red','LineStyle','--') 
line(t1,T1,'LineWidth',1.5,'Color','black')
line(t4,T4,'LineWidth',0.5,'Color','black','LineStyle','--') 
line(t4b,T4b,'LineWidth',0.5,'Color','black','LineStyle','-.') 
grid on
axis([-10 20 0 1000])
legend('Li experiment',...
    'Li FEM 8 MW/m^2, Ecost = 5 eV',...
    'Li experiment',...
    'Li FEM 8.5 MW/m^2, Ecost = 5 eV',...
    'Li only 8.5 MW/m^2, Ecost = 5 eV',...
    'Location','SouthWest')
% xlabel('Time [s]')
ylabel('Temperature [^oC]')

subplot(3,1,3)
line(t7,T7,'LineWidth',1,'Color','red','LineStyle','--') 
line(t6,T6,'LineWidth',1,'Color','black','LineStyle','--')
xlim([-5 20])
ylim([0 1])
grid on
xlabel('Time [s]')
ylabel('Qvap/Qplasma [-]')
legend('red','blue','Location','NorthWest')



