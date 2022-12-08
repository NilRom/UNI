%% 
addpath('Code/functions', 'Code/data')  
clear all
clc
rng(0)
n = 500;
A3=[1 .5];
C3 = [1 -0.3 0.2];
w= sqrt(2)*randn(n+100,1); 
x = filter(C3,A3,w);
% Number of samples
% Create the input
A1 = [1 -.65];
A2 = [1 .90 .78];
C=1;
B=[0 0 0 0 .4];
e = sqrt(1.5) * randn(n + 100,1);
y = filter(C,A1,e) + filter(B,A2,x); % Create the output
x = x(101:end);
y = y(101:end); % Omit initial samples
clear A1  A2  C B e w A3 C3

%%
%Looks like an ar or arma(1). Data looks Gaussian
plotACFnPACF(x, 20, 'x', 0.05)
figure
normplot(x)

%%
ar = estimateARMA(x, [1 1], [1], 'AR(1) Estimate of x', 20);
arma = estimateARMA(x, [1 1], [1 1 ], 'ARMA(1,1) Estimate of x', 20);


%%
%Now we introduce the exogenous variable x and look at the accf(auto cross
%correlation function). The cross correlation is not white. We can use it
%in the alchemy approach to guess order of B polynomial in the BJ model
%I.e the 'delay'
epst = resid(ar, y);
wt = resid(ar, x);

M=40;
stem(-M:M,crosscorr(wt ,epst,M));
title('Cross correlation function');
xlabel('Lag')
hold on
plot(-M:M, 2/sqrt(n)*ones(1,2*M+1)) 
plot(-M:M, -2/sqrt(n)*ones(1,2*M+1))
hold off

%%

% Using the alchemy approach we use d = 4 and we get a cross spectra that
% is white but note that the etilde resid is not white as it should be
d = 4;
A2 = [1 1 1];
B = [zeros(1,d) 1];
Mi = idpoly(1 ,B ,[] ,[] ,A2);
Mi.Structure.b.Free = [zeros(1,d) 1];
z = iddata(y,x);
Mba2 = pem(z,Mi); present(Mba2)
etilde = resid(Mba2, z );
crosscorr(etilde.OutputData, x)
checkIfWhite(etilde.OutputData)


%%

%The etilde residual is obviously an ar 1 process which we can use to
%whiten it
plotACFnPACF(etilde.OutputData, 20, 'etilde', 0.05)

arma11 = estimateARMA(etilde.OutputData, [1 1], [1], 'AR Estimate of x', 20);

%%

%%

%We have now estimated the model orders for all polynomial in the BJ scheme
%Looking at the residual, we may note that it is white
d = 4;
A1 = [1 1];
C1 = [1] ;
B = [zeros(1,d) 1] ;
A2 = [1 1 1] ;

Mi = idpoly (1 ,B,C1,A1,A2);
z = iddata(y,x);

MboxJ = pem(z ,Mi);
present (MboxJ)
ehat = resid(MboxJ,z);
e_d = ehat.OutputData;
e_d = e_d(100:end);
plotACFnPACF(e_d, 20, 'ehat', 0.05);
figure
crosscorr(x, e_d)

%ASK: Causality??? Can we only look at >0 in the cross spectra
%%
%Or using the BJ built in functionality we get the same results with a
%white residual
[ foundModel, ey, acfEst, pacfEst ] = estimateBJ(y,x,C1,A1,B,A2,'Hello', 20)


%% 2.2
clear all
clc
load ('tork.dat')
tork = tork - repmat(mean(tork),length(tork),1);
y = tork(:,1);
x = tork(:,2);
z = iddata(y,x);
plot(z(1:300))

%% EDA
%Lets do some eda on our tork data
plotACFnPACF(x, 20, 'x', 0.05)
figure
normplot(x)
plotACFnPACF(y, 20, 'y', 0.05)
figure
normplot(y)



%% pre whitening
ar = estimateARMA(x, [1 1], 1, 'AR Estimate of x', 20); %guess AR(1) by looking at pacf
A1 = [1 1];
C1 = 1;
%Residual looks perfect. i.e an AR(1)

%% 

%Check crosscorrelation in order to use alchemy approach to determine good
%polynomial orders
epst = resid(ar, y);
wt = resid(ar, x);
n = length(x);
M=40;
stem(-M:M,crosscorr(wt ,epst,M));
title('Cross correlation function');
xlabel('Lag')
hold on
plot(-M:M, 2/sqrt(n)*ones(1,2*M+1)) 
plot(-M:M, -2/sqrt(n)*ones(1,2*M+1))
hold off

%(5,1,2) seems to be a good idea
%% It wasnt trying a (3 2 3)
%Turns out, trial and error seems to over-perform alchemy approach
%We still dont get a perfect cross acf but it is pretty close
d = 3;
A2 = [1 0.1 .1];
B = [zeros(1,d) 1 0.1 .1];
Mi = idpoly(1 ,B ,[] ,[] , A2);
Mi.Structure.b.Free = [zeros(1,d) 1 1 1];
z = iddata(y,x);
Mba2 = pem(z,Mi); present(Mba2)
etilde = resid(Mba2, z );
crosscorr(x, etilde.OutputData)
checkIfWhite(etilde.OutputData)


%%

%etilde is not white as expected. Looks like an AR process
plotACFnPACF(etilde.OutputData, 20, 'etilde', 0.05)


%Using etilde one we can get get a white residual if we use a AR(1)
arma11 = estimateARMA(etilde.OutputData, [1 1], [1], 'AR Estimate of x', 20);




%%
d = 3;
A1 = [1 1];
C1 = 1;
B = [zeros(1,d) 1 1 1];
A2 = [1 1 1];
[model, residual] = estimateBJ(y,x,C1,A1,B,A2, 'BJ RESID', 20);
figure
crosscorr(x, residual)

%% 2.3
clear all
clc
load svedala.mat

y = svedala;
plot(y)

%%
A =  [ 1 -1.79 0.84 ];
C = [ 1 -0.18 -0.11 ];

k = 1;
[Fk, Gk] = polydiv( C, A, k );
yhat_k = filter( Gk, C, y );
yhat_k = yhat_k(length(Gk)+1:end);
error = yhat_k - y((length(Gk)+1:end));
sigma2 =  var(error);
sigma2_one_step =  var(error);
mu = mean(error);
theo_var = sum(Fk.^2) * sigma2_one_step;
confint = [mean(error) - 2*sqrt(theo_var), mean(error) + 2*sqrt(theo_var)];
outside = (sum(error > confint(2)) + sum(error < confint(1)) ) / length(error);
display("k = " + k + " Prediction error variance: " + sigma2 + ...
     " Theoretical variance is : " + theo_var + ... 
     ", Prediction error mean: " + mu +...
     " Num samples outside: " + outside * 100 + "%")
plot(y)
hold on
plot(yhat_k)
plotACFnPACF(error, 20, 'k = 1', 0.05);
figure
plot(error)
hold on 


plot(ones(length(error),1)*mean(error) - 1.96*sqrt(theo_var),'-')
plot(ones(length(error),1)*mean(error) + 2*sqrt(theo_var),'-')

k = 3;
[Fk, Gk] = polydiv( C, A, k );
yhat_k = filter( Gk, C, y );
yhat_k = yhat_k(length(Gk)+1:end);
error = yhat_k - y((length(Gk)+1:end));
sigma2 =  var(error);
theo_var = sum(Fk.^2) * sigma2_one_step;
mu = mean(error);
confint = [mean(error) - 2*sqrt(theo_var), mean(error) + 2*sqrt(theo_var)];
outside = (sum(error > confint(2)) + sum(error < confint(1)) ) / length(error);
display("k = " + k + " Prediction error variance: " + sigma2 + ...
     " Theoretical variance is : " + theo_var + ... 
     ", Prediction error mean: " + mu +...
     " Num samples outside: " + outside * 100 + "%")

plot(y)
hold on
plot(yhat_k)
plotACFnPACF(error, 20, 'k = 3', 0.05);

figure
plot(error)
hold on 
plot(ones(length(error),1)*mean(error) - 2*sqrt(theo_var),'-')
plot(ones(length(error),1)*mean(error) + 2*sqrt(theo_var),'-')



k = 26;
[Fk, Gk] = polydiv( C, A, k );
yhat_k = filter( Gk, C, y );
yhat_k = yhat_k(length(Gk)+1:end);
error = yhat_k - y((length(Gk)+1:end));
sigma2 =  var(error);
theo_var = sum(Fk.^2) * sigma2_one_step;
mu = mean(error);
confint = [mean(error) - 2*sqrt(theo_var), mean(error) + 2*sqrt(theo_var)];
outside = (sum(error > confint(2)) + sum(error < confint(1)) ) / length(error);
display("k = " + k + " Prediction error variance: " + sigma2 + ...
     " Theoretical variance is : " + theo_var + ... 
     ", Prediction error mean: " + mu +...
     " Num samples outside: " + outside * 100 + "%")
figure 
plot(y)
hold on
plot(yhat_k)
plotACFnPACF(error, 30, 'k = 26', 0.05);
figure
plot(error)
hold on 
plot(ones(length(error),1)*mean(error) - 2*sqrt(theo_var),'-')
plot(ones(length(error),1)*mean(error) + 2*sqrt(theo_var),'-')


%%
plot(error)
hold on 
plot(ones(length(error),1)*mean(error) - 2*sqrt(theo_var),'-')
plot(ones(length(error),1)*mean(error) + 2*sqrt(theo_var),'-')


%% 2.4 
clear all
clc
load sturup.mat 
load svedala.mat
y = svedala;
x = sturup;
k = 4;
A= [ 1 -1.49 0.57 ];
B = [ 0 0 0 0.28 -0.26 ];
C=[1];
[Fk, Gk] = polydiv( C, A, k );
[Fhat, Ghat] = polydiv( conv(B,Fk), C, k);

xhat = filter( Gk, C, x);
y_hat = filter( Gk, C, y ) + filter( Ghat, C, x ) + filter(Fhat, 1, xhat );
y_hat_bad = filter( Gk, C, y ) + filter( Ghat, C, x );
plot(y_hat)
hold on
plot(y_hat_bad)
hold on
plot(y)


legend(["y hat", "y hat bad", "y true"])
samples_to_remove = max([length(Fk), length(Fhat), length(Gk), length(Ghat), length(C), ...
    length(A), length(B)]) + 1;
y = y(samples_to_remove:end);y_hat = y_hat(samples_to_remove:end);
y_hat_bad = y_hat_bad(samples_to_remove:end);

error = y - y_hat;
error_bad = y - y_hat_bad;
figure
plot(error)
hold on
plot(error_bad)
plotACFnPACF(error, 20, 'Error', 0.05)




sigma2 =  var(error);
mu = mean(abs(error));
confint = [mean(error) - 2*sqrt(sigma2), mean(error) + 2*sqrt(sigma2)];
outside = (sum(error > confint(2)) + sum(error < confint(1)) ) / length(error);
display("k = " + k + " Prediction error variance: " + sigma2 + ...
     ", Prediction error mean: " + mu +...
     " Num samples outside: " + outside * 100 + "%")

sigma2 =  var(error_bad);
mu = mean(abs(error_bad));
confint = [mean(error_bad) - 2*sqrt(sigma2), mean(error_bad) + 2*sqrt(sigma2)];
outside = (sum(error_bad > confint(2)) + sum(error < confint(1)) ) / length(error);
display("BAD ### k = " + k + " Prediction error variance: " + sigma2 + ...
     ", Prediction error mean: " + mu +...
     " Num samples outside: " + outside * 100 + "%")



%%
clear all
clc
load svedala.mat
s = 24;
AS = [ 1 zeros(1, s-1) -1 ];
y = svedala;
plotACFnPACF(svedala, 25, 'Svedala', 0.05)
[ foundModel, ey, acfEst, pacfEst ] = estimateARMA(svedala, [1 1 1], [1 1 1], 'Hello', 20);

A_season = conv(foundModel.a, AS);
A_no_season = foundModel.a;
C = foundModel.c;

k = 5;
[Fk_season, Gk_season] = polydiv( C, A_season, k );
yhat_k_season = filter( Gk_season, C, y );

[Fk, Gk] = polydiv( C, A_no_season, k );
yhat_k_no_season = filter( Gk, C, y );


samples_to_remove_s = max([length(Fk), length(Gk), length(C), ...
    length(A_season)]) + 1;
samples_to_remove = max([length(Fk), length(Gk), length(C), ...
    length(A_season)]) + 1;
yhat_k_no_season = yhat_k_no_season(samples_to_remove_s:end);
yhat_k_season = yhat_k_season(samples_to_remove_s:end);
y = y(samples_to_remove_s:end);

%%
plot(y)
hold on
plot(yhat_k_season)
hold on
plot(yhat_k_no_season)
legend(["y True", "with season", "without season"])


%%
r_season = yhat_k_season - y;
r_no_season = yhat_k_no_season - y;
relative_errors_s = r_season ./ y;
relative_errors = r_no_season ./ y;
mu_s = mean(abs(r_season));
mape_s = mean(abs(relative_errors_s));
mape = mean(abs(relative_errors));
sigma_2_s = var(r_season);
mu_ns = mean(abs(r_no_season));
sigma_2 = var(r_no_season);
display("------------------------------SARMA MODEL--------------------------------")
display("k = " + k + " Prediction error variance: " + sigma_2_s + ...
     ", Prediction error absolute mean: " + mu_s + ...
     " Mean relative absolute error: " + mape_s * 100 + "%")
display("------------------------------ARMA MODEL--------------------------------")
display("k = " + k + " Prediction error variance: " + sigma_2 + ...
     ", Prediction error mean: " + mu_ns + ...
     " Mean relative absolute error: " + mape * 100 + "%")


