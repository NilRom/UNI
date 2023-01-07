rng(0)

clear 
clc
df = loadCleanValidate(0);
start_date = '1994-09-01';
[df_train, df_val, df_test] = trainValTestSplit(df, start_date, 1);

%% Construct Naive model
% This is the guess-last-hour-value model.
A = [1 -0.5 zeros(1,22) -0.5];
C = [1];
model_naive = idpoly(A,[],C,[],[]);
present(model_naive)
save Code/project/models/model_naive model_naive


%% Lets do some prediction with this model
y = df.t_sla;
time = df.time;

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
y_hat_1 = predictARMA(A,C,y,1);
y_hat_9 = predictARMA(A,C,y,9);

%Fetch respective prediction
%modelling
y_model = y(train_start:train_end);
yhat_model_1 = y_hat_1(train_start:train_end);
yhat_model_9 = y_hat_9(train_start:train_end);

%Validation
y_val = y(val_start:val_end);
yhat_val_1 = y_hat_1(val_start:val_end);
yhat_val_9 = y_hat_9(val_start:val_end);
val_predictions_naive = [yhat_val_1 yhat_val_9];
save Code/project/preds/task_naive_val val_predictions_naive %Save these for later acf plot


%Test Note that this is saved for later when all models are tested in order
%to prevent tuning our model on test set.
y_test = y(test_start:test_end);
yhat_test_1 = y_hat_1(test_start:test_end);
yhat_test_9 = y_hat_9(test_start:test_end);
test_predictions_naive = [yhat_test_1 yhat_test_9];
save Code/project/preds/task_naive test_predictions_naive


%% Plot Predictions
%modelling

f = figure;
newcolors = ["#0072BD","#D95319","#77AC30"];
colororder(newcolors);
f.Position = [100 100 1000 800];
set(f,'DefaultLineLineWidth',2)
subplot(211)
plot(df_train.time, df_train.t_sla)
hold on
plot(df_train.time, yhat_model_1)
plot(df_train.time, yhat_model_9)
title("Model Predictions")
legend(["Actual", "1 Step Prediction", "9 Step Prediction"])
ylabel("°C")

%Validation
subplot(212)
plot(df_val.time, df_val.t_sla)
hold on
plot(df_val.time, yhat_val_1)
plot(df_val.time, yhat_val_9)
title("Validation Predictions")
legend(["Actual", "1 Step Prediction", "9 Step Prediction"])
ylabel("°C")

saveas(gcf,"Code/project/figs/naive_pred.png")


%% Get residuals
resid_1_model = y_model - yhat_model_1;
resid_9_model = y_model - yhat_model_9;

resid_1_val = y_val - yhat_val_1;
resid_9_val = y_val - yhat_val_9;


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


