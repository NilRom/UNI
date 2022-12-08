clear; clc;
close all;
addpath('Code/functions', 'Code/data')  


%% Task 1
A1 = [ 1 -1.79 0.84 ]; C1 = [ 1 -0.18 -0.11 ];
A2 = [ 1 -1.79 ]; C2 = [ 1 -0.18 -0.11 ];


arma1 = idpoly(A1, [],C1);
arma2 = idpoly(A2, [],C2);


pzmap(arma1)
figure
pzmap(arma2)


%%
rng(0)
N = 300;
extraN = 100;
sigma2 = 1.5;
e = sqrt(sigma2) * randn( N+extraN, 1 );
y = filter(arma2.c, arma2.a, e ); y = y(extraN:end);
plot(y)

%%
N = 200;
rng(0)
extraN = 100;
e = sqrt(sigma2) * randn( N+extraN, 1 );
y2 = filter(arma2.c, arma2.a, e ); y2 = y2(extraN:end);
y1 = filter(arma1.c, arma1.a, e ); y1 = y1(extraN+1:end);

subplot (211)
plot(y1)
title('ARMA 1 Simulation')
subplot(212)
plot(y2)
title('ARMA 2 Simulation')



%%
m = 20;
r_theo = kovarians(arma1.c, arma1.a, m);
stem(0:m, r_theo*sigma2)
hold on
r_est = covf( y1, m+1 );
stem(0:m, r_est, 'r')
legend(["Theoretical", "Estimated"])


figure
m = 20;
r_theo = kovarians(arma2.c, arma2.a, m);
stem(0:m, r_theo*sigma2)
hold on
r_est = covf( y2, m+1 );
stem(0:m, r_est, 'r')
legend(["Theoretical", "Estimated"])



%%
normplot(y1)
plotACFnPACF( y1, 50, 'y1' );

%%
rng(0)
data = iddata(y1);
ar_model = arx(y1, 2);
arma_model = armax( y1, [3 1]);
e_hat = filter(arma_model.a, arma_model.c, y1);
e_hat_ar = filter(ar_model.a, ar_model.c, y1);

present(arma_model)
e_hat = e_hat(length(arma_model.a):end);
e_hat_ar = e_hat_ar(length(arma_model.a):end);
checkIfWhite(e_hat)
checkIfWhite(e_hat_ar)
fpe(arma_model)
fpe(ar_model)


%%
num_as = 2;
num_cs = 2;
fpes_arma = zeros(num_as,num_cs);
fpes_ar = zeros(num_as,num_cs);
aics = zeros(num_as,num_cs);
bics = zeros(num_as,num_cs);
for i = 1:num_as
    for j = 1:num_cs
        arma_model = armax( y1, [i j]);
        ar_model = armax( y1, [i 0]);
        present(ar_model)
        fpe(ar_model)
        fpes_ar(i,j) = fpe(ar_model);
        fpes_arma(i,j) = fpe(arma_model);
        aics(i,j) = aic(arma_model);
        
    end
end 
%%
% num_as = 5;
% fpes_ar = zeros(1,num_as);
% for i = 1:num_as
%     y1(i:end);
%     ar_model = arx(y1, i);
%     poly = ones(1,i);
%     pem(y1, poly)
%     fpes_ar(i) = fpe(ar_model);
% 
% end
% min(fpes_ar)


%%
% 
% ar_model = pem(y1, [1 1 1])
% pem(y1, ar_model)
%%
estimateARMA(y1, [1 1], [1 1], 'ARMA(1,1)', 20)


%%


poly_a = [1 1 1 1];
y1 = filter(arma1.c, arma1.a, e ); y1 = y1(length(poly_a):end);
estimateARMA(y1, poly_a, 1, 'Hej', 20)

%% PART 2
load data.dat
load noise.dat
data=iddata(data);
ar1_model = arx(data, 1);
ar2_model = arx(data, 2);
rar1=resid(ar1_model,data); rar1 = rar1(2:end);
rar2=resid(ar2_model,data); rar2 = rar2(3:end);
present(ar1_model)
present(ar2_model)
plot(rar1)
hold on
plot(noise, 'r')
figure
plot(rar2)
hold on
plot(noise, 'r')

%%
am12_model = armax(data ,[1 1]);
rar12 = resid(am12_model,data); rar12 = rar12(2:end);
present(am12_model)
plot(rar12)
hold on
plot(noise, 'r')
plotACFnPACF(data.OutputData,20, 'Data', 0.05)
var(rar12.OutputData)
plotACFnPACF(rar12.OutputData,20, 'Residual', 0.05)

%%
for i = 1:5
    m = arx(data, i);
    r = resid(m,data);
    disp("Order AR("+ i + "). Variance: " + var(r.OutputData)) 
end

for i = 1:5
    for j = 1:5
        m = armax(data, [i, j]);
        r = resid(m,data);
        disp("Order ARMA("+ i + ", " + j + "). Variance: " + var(r.OutputData)) 
    end
end


%%
m = armax(data, [1,1]);
present(m)



%% SARIMA PART
clc
clear all
rng(0)
A = [1 -1.5 0.7];
C = [1 zeros(1,11) -0.5];
A12 = [1 zeros(1,11) -1];
A_star = conv(A,A12);
e = randn(1e4 ,1);
y = filter(C,A_star,e);
y = y(101:end);
plot(y)
plotACFnPACF(y,20,'Hello',0.05)
figure
normplot(y)


%%
y_s = filter(A12,1,y);
y_s = y_s(length(A12):end);
data = iddata(y_s);
model_init = idpoly([1 0 0] ,[] ,[]);
model_armax = pem(data,model_init);
present(model_armax)


%%
r = resid(model_armax,data);
plotACFnPACF(r.OutputData, 20, 'Residual', 0.05)

%%
model_init = idpoly([1 0 0],[],[1 zeros(1,12)]);
model_init.Structure.c.Free = [zeros(1,12) 1];
model_armax = pem(data,model_init);
present(model_armax)
r = resid(model_armax,data);
plotACFnPACF(r.OutputData, 20, 'Residual', 0.05)

%%
load svedala.mat;
svedala = iddata(svedala);


plot(svedala.OutputData)
plotACFnPACF(svedala.OutputData, 48, 'Residual', 0.05)
figure
normplot(svedala.OutputData)
model_init = idpoly([1 1 1],[],[1 zeros(1,24)]);
model_init.Structure.c.Free = [0 1 zeros(1,22) 1];
model_armax = pem(svedala,model_init);
present(model_armax)

%% Residual analysis
r = resid(model_armax,svedala);
plotACFnPACF(r.OutputData, 48, 'Residual', 0.05)
checkIfWhite(r.OutputData)
whitenessTest(r.OutputData)


%%
load svedala.mat;
A12 = [1 zeros(1,23) -1];
svedala = filter(A12,1,svedala);

svedala = iddata(svedala);
p = 3;
q = 1;
season = 24;

model_init = idpoly(conv(ones(1,p+1), zeros(1,season)),[],[1 zeros(1,season)]);
model_init.Structure.c.Free = [0 1 zeros(1,22) 1];
model_init.Structure.A.Free = [0 1 1 1 zeros(1,18) 1 1 1];
model_armax = pem(svedala,model_init);
present(model_armax)



%%
svedala = svedala(24:end);
r = resid(model_armax,svedala);
normplot(r.OutputData)
plotACFnPACF(r.OutputData, 100, 'Residual', 0.05)
checkIfWhite(r.OutputData)
whitenessTest(r.OutputData)


