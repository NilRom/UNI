rng(0)
addpath Code/project/custom_functions/
clear 
clc
df = loadCleanValidate(0);
start_date = '1994-09-01';
[df_train, df_val, df_test] = trainValTestSplit(df, start_date, 1);
%% we now want to model the input as a process
plot(df_train.time, df_train.tp_stu)
% looks like we need a differenenffieation

%% differentiation
detrender = [1 -1];
detrended = filter(detrender, 1, df_train.tp_stu);
detrended = detrended(length(detrender):end);
time = df_train.time(length(detrender):end);
plot(time, df_train.tp_stu(length(detrender): end))
hold on
plot(time, detrended)
title("STURUP")
legend(["Original", "Detrended"])


%% Lets take a look at the statistics of sturup
plotACFnPACF(detrended, 50, 'STURUP', 0.05);


%% Prewhitening
%Now we want to model the exogenous input as a white noise that is filtered
%trough a model

A = [1 1 0 0 0 0 0 0 0 0 0 zeros(1,12) 1 1 1];
C = [1 0 0 0 0 0 0 0 0 0 0 zeros(1,12) 0 1 0];

whitening_model = estimateARMA(detrended,A, C, 'AR(2)', 59);
present(whitening_model)
whitening_model.a = conv(detrender,whitening_model.a);

%% Turns out this is really tricky
% Despite a lot of trial and error this seems impossible. 
r = resid(df_train.tp_stu, whitening_model);
whitenessTest(r)

%% Look at cross correlation between wt and epsilon tilde after whitening
epst = resid(whitening_model, df_train.t_sla);
wt = resid(whitening_model, df_train.tp_stu);
n = length(df_train.t_sla);
M=40;
stem(-M:M,crosscorr(wt,epst,M));
title('Cross correlation function');
xlabel('Lag')
hold on
plot(-M:M, 2/sqrt(n)*ones(1,2*M+1)) 
plot(-M:M, -2/sqrt(n)*ones(1,2*M+1))
hold off

%% Next step in BJ model order estimation is to look at the cross correlation between x and y
% Since we can not construct a model that transfers white noise to x this
% is irrelevant
d = 0;
A2 = [1 1];
B = [zeros(1,d) 1 1];
Mi = idpoly(1 ,B ,[] ,[] ,A2);
Mi.Structure.b.Free = [zeros(1,d) 1 1];
z = iddata(df_train.t_sla,df_train.tp_stu);
Mba2 = pem(z,Mi);
present(Mba2)
etilde = resid(Mba2, z );
crosscorr(etilde.OutputData, df_train.tp_stu)
checkIfWhite(etilde.OutputData)


%% Look at acf and pacf of etilde
plotACFnPACF(etilde.OutputData, 20, 'etilde', 0.05)
estimateARMA(etilde.OutputData, [1 1 1], [1 1], 'AR Estimate of x', 20);