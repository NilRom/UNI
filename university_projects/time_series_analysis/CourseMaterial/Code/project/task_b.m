clear; clc;
close all;
addpath('Code/functions', 'Code/data')  

load Code/project/projDatafiles/utempSla_9395.dat
load Code/Project/projDatafiles/ptstu93.mat
load Code/Project/projDatafiles/ptstu94.mat
load Code/Project/projDatafiles/ptstu95.mat

load Code/Project/projDatafiles/ptvxo93.mat
load Code/Project/projDatafiles/ptvxo94.mat
load Code/Project/projDatafiles/ptvxo95.mat

load Code/Project/projDatafiles/tid93.mat
load Code/Project/projDatafiles/tid94.mat
load Code/Project/projDatafiles/tid95.mat

%%
addpath('Code/functions', 'Code/data')  
%%
T = vertcat(tid93, tid94, tid95);
utetempstur = vertcat(ptstu93,ptstu94,ptstu95);
utetempvxo = vertcat(ptvxo93,ptvxo94,ptvxo95);

% since they differ in length we zeropad to make ends meet
zeropad = zeros(1,length(utetempstur)-length(utetempvxo))';
utetempvxo = vertcat(utetempvxo,zeropad);
shift = 2;
% We begin by making one dataset with time and temperature data, and alining
% them 
big = horzcat(utetempvxo,utetempstur, utempSla_9395, T(1:length(utempSla_9395),:)); %Ok since they start on same date

% Data validation check

% we check that the year time stamp (which is present in both sets) aline
assert(mean(big(:,1+shift) == big(:,5+shift)) == 1)
% we check that the hourly time stamp also aline
assert(mean(big(:,2+shift) == big(:,8+shift)) == 1)
% if both of the above values are 1 then our concatenation is successful

%%
% removing unnecessary columns
new_big = big(:,[1 2 1+shift 2+shift 3+shift]);

% using table format instead, for less cumbersome handling 
df = array2table(new_big, 'VariableNames',{'tp_vxo','tp_stu','year','hour','t_sla'});

% making a date-time-table instead for easier represenation 
start_time = '1-Jan-1993';
t = datetime(start_time):hours(1):datetime(start_time) + hours(length(df.t_sla)-1);
df.('time') = t';

% removing the first samples that are from before start of measurements 
df = df(6803:end, :);
%% evaluating data 
figure(1)
plot(df.tp_vxo);
hold on
%plot(df.t_sla);

figure(2)
plot(df.tp_stu);
hold on
%plot(df.t_sla);

%% evaluating data for 10 weeks in the middle of the dataset
for name = ["t_sla", "tp_stu", "tp_vxo"]
    
    figure
    start = length(df.(name)) / 2;
    ed = start + 10*24*7 ;
    plot(df.time(start:ed), df.(name)(start:ed))
    title(name)
end 



% the once-a-day-at-23:00-o'clock-zero-value is evident and needs to be
% handled


%% handling the 23 oclock-thing by setting it as NaN and fill them as linear intepolation
idx = df.hour == 23;
df.t_sla(idx) = NaN; 
df.t_sla= fillmissing(df.t_sla,'linear'); 

%checking that we caught all NaN
assert(sum(isnan(df.t_sla))==0)
%%
plot(df.time, df.t_sla)

% we can still see that some missing values occur, for example if the
% temperature is identically 0 at 14:00 in august. We draw the conclusion
% that all missing measurements have been handled as setting the value to
% zero.
%% Handling missing values 
% We figure that the best way is to handle all identically zero values as 
% a linear interpolation between previous and next value. This will not 
% disturb the winter temperature that actually are zero too much since we 
% measure with one decimal and they will probably be close to their acutal
% value after interpolation

idx = df.t_sla == 0;
df.t_sla(idx) = NaN; 
df.t_sla = fillmissing(df.t_sla,'linear'); 
assert(sum(isnan(df.t_sla))==0)

plot(df.time,df.t_sla)

% this looks good!

%% evalute the correlation between our to exogenous in order to find best
figure 
subplot(211)
crosscorr(df.tp_stu,df.t_sla, NumLags = 40)
subplot(212)
crosscorr(df.tp_vxo,df.t_sla, NumLags = 40)

%Note that sturup has stronger correlation compared to växsjö, as expected
%due to gEoGraPhY


%% We do the same splitting scheme

start_date = '1994-09-01';
start_train = find(df.time == start_date);
end_train= start_train + 10*24*7;

start_val = end_train;
end_val = end_train + 2*24*7;

start_test = end_train + 20*24*7;
end_test = start_test + 2*24*7;


df_train = df(start_train:end_train,:);
df_val = df(start_val:end_val,:);
df_test = df(start_test:end_test,:); %Never touch this :)

figure

subplot(211)
plot(df_train.time, df_train.t_sla)
hold on
plot(df_val.time, df_val.t_sla)
plot(df_test.time, df_test.t_sla)
title('SVEDALA')
legend(["Train", "Validation", "Test"])

subplot(212)

plot(df_train.time, df_train.tp_stu)
hold on
plot(df_val.time, df_val.tp_stu)
plot(df_test.time, df_test.tp_stu)
title('STURUP')

legend(["Train", "Validation", "Test"])

%% we now want to model the input as a process
plot(df_train.time, df_train.tp_stu)
% looks like we need a differenenffieation

%% differentiation
detrender = [1 -1];
detrended = filter(detrender, 1, df_train.tp_stu);
detrended = detrended(length(detrender):end);
plot(detrended)


%% soft diff
%% differentiation
detrender = arx(df_train.tp_stu, 1);
detrended = filter(detrender.a, 1, df_train.tp_stu);
detrended = detrended(length(detrender):end);
%detrended = detrended(2:end);
plot(detrended)

%% 
plotACFnPACF(detrended, 50, 'STURUP', 0.05)

%% Hard deseasoning
season = 24;
deseasoner = [1 zeros(1, season-1) -1];
deseasoned = filter(deseasoner, 1, detrended);
plot(deseasoned)
%% 
plotACFnPACF(deseasoned, 50, 'STURUP', 0.05);



%%
p = 5;
q = 3;
season = 24;
A = [ones(1,p+1) zeros(1,season-p - 2) 0 1 0];
C = [ones(1, q+1) zeros(1, season - q - 2) 0 1 0];

%A = [1 0 1 1 0 0 0 0 0 0 0 zeros(1,13) 1 1];
%C = [1 1 1 1 0 0 0 0 0 0 0 zeros(1,12) 1 1 1];

A = [1 1 1 1 1 1 zeros(1,18) 1];
C = [1 1 1 1 zeros(1,20) 1];

whitening_model = estimateARMA(detrended,A, C, 'AR(2)', 59);
present(whitening_model)
whitening_model.a = conv(detrender.a,whitening_model.a);


%%
r = resid(df_train.tp_stu, whitening_model);
whitenessTest(r)


%%


%%
epst = resid(whitening_model, df_train.t_sla);
wt = resid(whitening_model, df_train.tp_stu);
n = length(df_train.t_sla);
M=40;
stem(-M:M,crosscorr(wt,epst,M));
%stem(-M:M,crosscorr(epst,wt,M));
title('Cross correlation function');
xlabel('Lag')
hold on
plot(-M:M, 2/sqrt(n)*ones(1,2*M+1)) 
plot(-M:M, -2/sqrt(n)*ones(1,2*M+1))
hold off

%%
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


%%
plotACFnPACF(etilde.OutputData, 20, 'etilde', 0.05)
estimateARMA(etilde.OutputData, [1 1 1], [1 1], 'AR Estimate of x', 20);


%%
d = 1;
C1 = [1 1];
A1 = [1 1 1 zeros(1,19) 0 1 1 0];
B = [0 1 1 ];
A2 = [1 1 1 zeros(1,19) 0 1 1 1];
y = df_train.t_sla;
x = df_train.tp_vxo;

[foundModel, ey, acfEst, pacfEst ] = estimateBJ(y,x,C1,A1,B,A2,'Hello', 40);
crosscorr(x, ey)
%% check pred on model data
A = conv(foundModel.D, foundModel.F);
B = foundModel.B;
C = foundModel.C;
k = 1;
[Fk, Gk] = polydiv( C, A, k );
[Fhat, Ghat] = polydiv( conv(B,Fk), C, k);
xhat = filter( Gk, C, x);
y_hat = filter( Gk, C, y ) + filter( Ghat, C, x ) + filter(Fhat, 1, xhat );
plot(y_hat)
hold on
plot(y)


%% check pred on val data
y = df_val.t_sla;
x = df_val.tp_stu;
A = conv(foundModel.D, foundModel.F);
B = foundModel.B;
C = foundModel.C;
k = 1;
[Fk, Gk] = polydiv( C, A, k );
[Fhat, Ghat] = polydiv( conv(B,Fk), C, k);
xhat = filter( Gk, C, x);
y_hat = filter( Gk, C, y ) + filter( Ghat, C, x ) + filter(Fhat, 1, xhat );
samples_to_remove = max([length(Fk), length(Fhat), length(Gk), length(Ghat), length(C), ...
    length(A), length(B)]) + 1;
y = y(samples_to_remove:end);y_hat = y_hat(samples_to_remove:end);


plot(y_hat)
hold on
plot(y)
resid_val = y - y_hat;
legend(["Pred", "Actual"])
disp(k + " step prediction. Residual variance: "+ var(resid_val))


