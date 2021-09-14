%% 3.1 Estimation of expected value, covariance fucntion and spectral density
clear all
clc
load input_files/data1.mat
plot(data1.x)
m = mean(data1.x);
sigma = std(data1.x);
n = length(data1.x);
ts = tinv([0.025  0.975],n-1); 
interval = m + ts * sigma/sqrt(n)

%% 3.2 Estimation of the covariance function
clear all
clc
load input_files/covProc.mat
k = 1;
plot(covProc(1:end-k),covProc(k+1:end),'.')
[ycov,lags]=xcov(covProc,20,'biased')
plot(lags,ycov)


%% 3.3 Specturm estimate of a sum of harmonics
input_files/spekgui.m


