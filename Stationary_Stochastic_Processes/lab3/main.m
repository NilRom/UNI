clear all
close all
clc
C = 1;
a1 = 0.5;
A = [1 a1];
[H,w]=freqz(C,A);
R=abs(H).^2;
plot(w/2/pi,R)
H=freqz(C,A,512,'whole');
Rd=abs(H).^2;
r=ifft(Rd);
figure
stem([0:49],r(1:50))

%Q. Draw rough sketches of the covariance functions for a1 < 0 and a1 > 0. How do they differ?
% One is oscilating and one is not. This is to be expected since if we have
% a positive a1 we have that the current X_t is negatively dependant on the
% previous one therefore a large X_t-1 yields small X_t. If negative a1 a
% large X_t-1 yields large X_t. Therefore no osciliation. 

%Q.Sketch the spectral densities. At what frequency does the spectral den- 
%sity reaches the maximum value for a1 < 0 and a1 > 0, respectively?
%A. For negative a1 it reaches maximum at 0. Pole at 1/2 i.e on the real
%axis corresponding to an argument (frequency) of 0
%For a positive it reaches maximum at 0.5 since we have a pole on -1/2
%corresponding to a frequency of 2*pi*1/2 = pi i.e f = 1/2

%%
clear all
close all
clc
C = 1;
a1 = 0.5;
A = [1 a1];
m = 0;
sigma = 1;
n = 400
e = normrnd(m, sigma, 1, n);
x = filter(C,A,e);
figure
plot(x)
C = 1;
a1 = -0.5;
A = [1 a1];
m = 0;
sigma = 1;
n = 400
e = normrnd(m, sigma, 1, n);
x = filter(C,A,e);
figure
plot(x)



%% 3.2 ARMA(2,2)
A = [1 -1 0.5];
C = [1 1 0.5];
P = roots(A);
Z = roots(C);
zplane(Z,P)
A = poly(P);
C = poly(Z);
[H,w]=freqz(C,A);
R=abs(H).^2;
figure
plot(w/2/pi,R)
% Q sketch and explain.
%As expected we see high at 1/8 and low at 3/8 since we have pole zeros at
%these arguments
%% 4
armagui
% Angle increase leads to a higher frequency of covariance functiona dn
% realisation signal. Peak of spectral density translated right
% When we move pole close to origin we get something that approaches a
% white noise process
% Process realisation becomes an unbound signal resonating. We dont get a
% covariance function nor spectral density since the covariance function is
% non integrable

%% 4.2
armagui

%tau greater than q yields zero since we have no dependance
%Closer to zero close to white noise. further away more dampening since we
%have some dependant e_t-1 stuff


%% 5







