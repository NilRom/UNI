%%% Mini Project 2
clear; clc;
close all;
addpath('Code/functions', 'Code/data')  

%% Task 1
extraN = 100;
N  = 1e2;
A  = [ 1 -1.79 0.84 ];
C  = [ 1 -0.81 -0.11 ];
e  = randn( N+extraN, 1 );
y1 = filter( C, 1, e );     y1 = y1(extraN:end); %ma
y2 = filter( 1, A, e );     y2 = y2(extraN:end); %ar 
y3 = filter( C, A, e );     y3 = y3(extraN:end); %arma

figure
subplot(311)
plot(y1)
title('Time-domain')
ylabel('MA process')
subplot(312)
plot(y2)
ylabel('AR process')
subplot(313)
plot(y3)
ylabel('ARMA process')
xlabel('Time')

%zero pole diagram
figure
zplane(A)
title('AR')
figure
zplane(C)
title('MA')

figure
subplot(321)
acf(y1,50,0.05,1);
title('ACF MA')
subplot(322)
pacf(y1,50,0.05,1);
title('PACF MA')

subplot(323)
acf(y2,50,0.05,1);
title('ACF AR')
subplot(324)
pacf(y2,50,0.05,1);
title('PACF AR')

subplot(325)
acf(y3,50,0.05,1);
title('ACF ARMA')
subplot(326)
pacf(y3,50,0.05,1);
title('PACF ARMA')


%% Task 2
A  = [ 1 1.89 1.02 ];
C  = [ 1 1.21 1.59 ];
roots(A)
subplot(211)
zplane(A)
title('A')
roots(C)
subplot(212)
zplane(C)
title('C')

extraN = 1e2;
N  = 5e3;
e  = randn( N+extraN, 1 );
y1 = filter( C, 1, e );     y1 = y1(extraN:end); %ma
y2 = filter( 1, A, e );     y2 = y2(extraN:end); %ar 
y3 = filter( C, A, e );     y3 = y3(extraN:end); %arma

figure
subplot(311)
plot(y1)
title('Time-domain')
ylabel('MA process')
subplot(312)
plot(y2)
ylabel('AR process')
subplot(313)
plot(y3)
ylabel('ARMA process')
xlabel('Time')
%% Task3 


load week2data
plot(y)
subplot(211)
acf(y,length(y)/5,0.05,1);
title('ACF')
subplot(212)
pacf(y,length(y)/5,0.05,1);
title('PACF')



