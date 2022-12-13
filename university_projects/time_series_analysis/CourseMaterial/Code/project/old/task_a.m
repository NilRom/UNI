clear; clc;
close all;

load Code/Project/projDatafiles/utempSla_9395.dat
load Code/Project/projDatafiles/tid93.mat
load Code/Project/projDatafiles/tid94.mat
load Code/Project/projDatafiles/tid95.mat
%%
addpath('Code/functions', 'Code/data')  

%%
T = vertcat(tid93, tid94, tid95);

% We begin by making one dataset with time and temperature data, and alining
% them 
big = horzcat(utempSla_9395, T(1:length(utempSla_9395),:)); %Ok since they start on same date

% Data validation check

% we check that the year time stamp (which is present in both sets) aline
assert(mean(big(:,1) == big(:,5)) == 1)
% we check that the hourly time stamp also aline
assert(mean(big(:,2) == big(:,8)) == 1)
% if both of the above values are 1 then our concatenation is successful

%%
% removing unnecessary columns
new_big = big(:,[1 2 3]);

% using table format instead, for less cumbersome handling 
df = array2table(new_big, 'VariableNames',{'year','hour','temperature'});

% making a date-time-table instead for easier represenation 
start_time = '1-Jan-1993';
t = datetime(start_time):hours(1):datetime(start_time) + hours(length(df.temperature)-1);
df.('time') = t';

% removing the first samples that are from before start of measurements 
df = df(6803:end, :);

%% evaluating data 
plot(df.time,df.temperature)

%% evaluating data for 10 weeks in the middle of the dataset
start = length(df.temperature) / 2;
ed = start + 10*24*7 ;
plot(df.time(start:ed), df.temperature(start:ed))


% the once-a-day-at-23:00-o'clock-zero-value is evident and needs to be
% handled

%% handling the 23 oclock-thing by setting it as NaN and fill them as linear intepolation
idx = df.hour == 23;
df.temperature(idx) = NaN; 
df.temperature = fillmissing(df.temperature,'linear'); 

%checking that we caught all NaN
assert(sum(isnan(df.temperature))==0)
%%
plot(df.time, df.temperature)

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

idx = df.temperature == 0;
df.temperature(idx) = NaN; 
df.temperature = fillmissing(df.temperature,'linear'); 
assert(sum(isnan(df.temperature))==0)

plot(df.time,df.temperature)

% this looks good!

%% train test split
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
plot(df_train.time, df_train.temperature)

hold on
plot(df_val.time, df_val.temperature)

hold on
plot(df_test.time, df_test.temperature)
legend(["Train", "Validation", "Test"])

%% Do a final check for outliers in the data
figure
subplot(311)
tacfEstimate = tacf(df.temperature, 25, 0.02, 0.05, 1);
title('TACF')
subplot(312)
acfEstimate = acf(df.temperature, 25, 0.05, 1);
title('ACF')
subplot(313)
stem(abs(tacfEstimate - acfEstimate))
title('|ACF-TACF|')

%They look pretty similar so we are good


%% Test for transform
df_train_temp = df_train;
bcNormPlot(df_train_temp.temperature)% probably not necessary

%% Detrend the data using a differentiating filter
df_train_temp = df_train;
df_detrend = df_train_temp;
plot(df_detrend.time, df_detrend.temperature)
hold on
detrender = [1 -1];
df_detrend.temperature = filter(detrender, 1,df_detrend.temperature);
df_detrend = df_detrend(2:end,:);
plot(df_detrend.time, df_detrend.temperature)
legend(["Original Data", "Detrended Data"])
disp("Mean of detrended data: " + mean(df_detrend.temperature))
%trend is gone, and we have a zero mean SSP


%% Take a look at the detrended data
plotACFnPACF(df_detrend.temperature, 48, 'Detrended', 0.05)


%% Fit on training data and look at model residual
df_train_temp = df_detrend;
season = 24;
p = 2;
q = 1;
A = [ones(1,p+1), zeros(1,season - p - 2) 1 0 1];
C = [ones(1,q+1) zeros(1,season-2) 1];



model_arma = estimateARMA(df_train_temp.temperature,A,C, "\nabla_{1}SARMA(" + p + "," + q + ") ", 48);
present(model_arma)
model_arma.a = conv(detrender, model_arma.a);



%% Lets validate this model
%apply same transforms to validation data lets make a 1 step pred


k = 1;
df_val_t = df_val;
y = df_val_t.temperature;

%df_val_t.temperature = df_val_t.temperature
y = vertcat(df_train.temperature, df_val.temperature);
time = vertcat(df_train.time, df_val.time);


[Fk, Gk] = polydiv( model_arma.c, model_arma.a, k);
yhat_k_val = filter( Gk, model_arma.c, y);


%yhat_k = yhat_k(length(df_train.temperature):end);

%Plot together with warm start
plot(time, y)
hold on
plot(time, yhat_k_val)
xline(df_val.time(1))
legend(["Actual", k + "-Step Prediction", "Validation Starts"])

%Store this for big viz later
df_result_val = array2table(time, 'VariableNames',{'time'});
df_result_val.("pred") = yhat_k_val;
df_result_val.("actual") = y;

yhat_k_val = yhat_k_val(length(df_train.temperature):end);
y = y(length(df_train.temperature):end);
resid_val = yhat_k_val - y;
figure
plot(resid_val)
legend('Validation Residual')
plotACFnPACF(resid_val,20,'Validation Residual', 0.05)
disp(k + " step prediction. Residual variance: "+ var(resid_val))
disp("Val Data variance : " + var(y))



%% lets test this model
%apply same transforms to test data lets make a 1 step pred
k = 9;
df_test_t = df_test;
y = df_test_t.temperature;

%df_val_t.temperature = df_val_t.temperature
[Fk, Gk] = polydiv( model_arma.c, model_arma.a, k);
yhat_k_test = filter( Gk, model_arma.c, y);

plot(df_test.time, y);
hold on 
plot(df_test.time, yhat_k_test);

legend(["Actual", k + "-Step Prediction"])

df_result_test = array2table(df_test.time, 'VariableNames',{'time'});
df_result_test.("pred") = yhat_k_test;
df_result_test.("actual") = y;

resid_test = yhat_k_test - y;
figure
plot(resid_test)
legend('Test Residual')
plotACFnPACF(resid_test,20,'Test Residual', 0.05)
disp(k + " step prediction. Residual variance: "+ var(resid_test))
disp("Test Data variance : " + var(y))




%% Putting it all together

hello = outerjoin(df,df_result_test,LeftKeys="time",RightKeys="time");
hello =outerjoin(hello,df_result_val,LeftKeys="time_df",RightKeys="time");

plot(hello.time_df, hello.pred_hello, 'red')
hold on
plot(hello.time_df, hello.actual_df_result_val, 'blue')
hold on
plot(hello.time_df, hello.pred_df_result_val, 'red')
hold on
plot(hello.time_df, hello.actual_hello, 'blue')
xline(df_val.time(1), ':')
xline(df_test.time(1), ':')
legend(["Prediction", "Actual"])




%% Lets validate this model



