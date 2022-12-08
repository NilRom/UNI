%Mini project 3
clear; clc;
close all;
addpath('Code/functions', 'Code/data')  

extraN = 100;
N  = 1e4;
e  = randn( N+extraN, 1 );
A  = [ 1 -0.5 0.7 ];
C  = [ 1 zeros(1,10) -0.7 ];
C2  = [ 1 -0.7 ];
y = filter( C, A, e );     y = y(extraN:end); %sarima
y2 = filter( C2, A, e );     y = y(extraN:end); %sarima
figure
plot(y)
title('Time-domain')
ylabel('SARIMA process')


figure
subplot(211)
acf(y,50,0.05,1);
title('ACF SARIMA')
subplot(212)
pacf(y,50,0.05,1);
title('PACF SARIMA')
noLags = 50;
plotACFnPACF( y, noLags, 'SARIMA ACFnPACF' );
plotACFnPACF( y2, noLags, 'SARIMA ACFnPACF season 1' );


%% task 2
load svedala.mat
plot(svedala)
figure
plotACFnPACF( svedala, noLags, 'Svedala acf and pacf' );






