rng(0)
addpath Code/project/custom_functions/
clear 
clc
df = loadCleanValidate(0);
start_date = '1994-09-01';
[df_train, df_val, df_test] = trainValTestSplit(df, start_date, 1);


%% Now we want to use one of the external signals
%Looking at the cross correlation Sturup appears to be the best choice
figure 
subplot(211)
crosscorr(df.tp_stu,df.t_sla, NumLags = 40)
subplot(212)
crosscorr(df.tp_vxo,df.t_sla, NumLags = 40)


%% go to model order estimation file here

%% The model order estimation scheme failed
% Instead we turn to trial and error and guess our way to a functioning BJ
% model. These model orders seem to be appropriate since the model residual
% is white and the x is almost uncorrelated with the residual. Sometimes
% trial and error is superior to the BJ model order estimation scheme
d = 1;
C1 = [1 1];
A1 = [1 1 1 zeros(1,19) 0 1 1 0];
B = [1 1 1 ];
A2 = [1 1 1 zeros(1,19) 0 1 0 1];
y = df_train.t_sla;
x = df_train.tp_vxo;

[foundModel, ey, acfEst, pacfEst ] = estimateBJ(y,x,C1,A1,B,A2,'Hello', 40);
crosscorr(x, ey)
save Code/project/models/model_b foundModel


%% Lets do some prediction with this model
y = df.t_sla;
x = df.tp_stu;
time = df.time;
%Reformulate as an ARMAX process
K_a = conv(foundModel.D, foundModel.F); %A1A2
K_b = conv(foundModel.D, foundModel.B); %A1B
K_c = conv(foundModel.F, foundModel.C); %A2C

%% Specify when training, validation, test starts and end
%Training
train_start = find(df.time == df_train.time(1));
train_end = find(df.time == df_train.time(end));

%Validation
val_start = find(df.time == df_val.time(1));
val_end = find(df.time == df_val.time(end));

%Test
test_start = find(df.time == df_test.time(1));
test_end = find(df.time == df_test.time(end));

%% Do a 1 and 9 step prediction on all data
y_hat_1 = predictARMAX(K_a,K_b,K_c,y,x,1);
y_hat_9 = predictARMAX(K_a,K_b,K_c,y,x,9);

%Fetch respective prediction
%modelling
y_model = y(train_start:train_end);
yhat_model_1 = y_hat_1(train_start:train_end);
yhat_model_9 = y_hat_9(train_start:train_end);

%Validation
y_val = y(val_start:val_end);
yhat_val_1 = y_hat_1(val_start:val_end);
yhat_val_9 = y_hat_9(val_start:val_end);

%Test
y_test = y(test_start:test_end);
yhat_test_1 = y_hat_1(test_start:test_end);
yhat_test_9 = y_hat_9(test_start:test_end);


%% Plot Predictions
%modelling
figure
plot(df_train.time, df_train.t_sla)
hold on
plot(df_train.time, yhat_model_1)
plot(df_train.time, yhat_model_9)
title("Model Predictions")
legend(["Actual", "1 Step Prediction", "9 Step Prediction"])

%Validation
figure
plot(df_val.time, df_val.t_sla)
hold on
plot(df_val.time, yhat_val_1)
plot(df_val.time, yhat_val_9)
title("Validation Predictions")
legend(["Actual", "1 Step Prediction", "9 Step Prediction"])

%Test
figure
plot(df_test.time, df_test.t_sla)
hold on
plot(df_test.time, yhat_test_1)
plot(df_test.time, yhat_test_9)
title("Test Predictions")
legend(["Actual", "1 Step Prediction", "9 Step Prediction"])

%% Get residuals
resid_1_model = y_model - yhat_model_1;
resid_9_model = y_model - yhat_model_9;

resid_1_val = y_val - yhat_val_1;
resid_9_val = y_val - yhat_val_9;

resid_1_test = y_test - yhat_test_1;
resid_9_test = y_test - yhat_test_9;


%% Check model residual
disp("##########################Modelling Residual Analysis##########################")
plotACFnPACF(resid_1_model, 50, "Model Residual 1 Step", 0.05);
plotACFnPACF(resid_9_model, 50, "Model Residual 9 Step", 0.05);
disp("Model Residual Variance 1 step: " + var(resid_1_model))
figure
whitenessTest(resid_1_model)
title("1 Step Model")
disp("Model Residual Variance 9 step: " + var(resid_9_model))
figure
whitenessTest(resid_9_model)
title("9 Step Model")


%% Check Validation residual
disp("##########################Validation Residual Analysis##########################")
plotACFnPACF(resid_1_val, 50, "Validation Residual 1 Step", 0.05);
plotACFnPACF(resid_9_val, 50, "Validation Residual 9 Step", 0.05);
disp("Validation Residual Variance 1 step: " + var(resid_1_val))
figure
whitenessTest(resid_1_val)
title("1 Step Validation")
disp("Validation Residual Variance 9 step: " + var(resid_9_val))
figure
whitenessTest(resid_9_val)
title("9 Step Validation")

%% Check Test residual
disp("##########################Test Residual Analysis##########################")
plotACFnPACF(resid_1_test, 50, "Test Residual 1 Step", 0.05);
plotACFnPACF(resid_9_test, 50, "Test Residual 9 Step", 0.05);
disp("Test Residual Variance 1 step: " + var(resid_1_test))
figure
whitenessTest(resid_1_test)
title("1 Step Test")
disp("Test Residual Variance 9 step: " + var(resid_9_test))
figure
whitenessTest(resid_9_test)
title("9 Step Test")













