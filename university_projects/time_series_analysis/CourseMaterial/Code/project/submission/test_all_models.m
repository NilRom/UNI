rng(0)
addpath Code/project/custom_functions/
clear 
clc
df = loadCleanValidate(0);
df = shift_exo(df, 0);
start_date = '1994-09-01';
[df_train, df_val, df_test] = trainValTestSplit(df, start_date, 0);
load Code/project/preds/task_a.mat
load Code/project/preds/task_naive.mat
load Code/project/preds/task_b.mat
load Code/project/preds/task_c.mat
load Code/project/preds/task_a_val.mat
load Code/project/preds/task_naive_val.mat
load Code/project/preds/task_b_val.mat 
load Code/project/preds/task_c_val.mat

preds_1 = [test_predictions_naive(:,1) test_predictions_a(:,1) test_predictions_b(:,1) test_predictions_c(:,1)];
preds_9 = [test_predictions_naive(:,2) test_predictions_a(:,2) test_predictions_b(:,2) test_predictions_c(:,2)];
val_preds_1 = [val_predictions_naive(:,1) val_predictions_a(:,1) stackedprediction(:,1) val_predictions_c(:,1)];
val_preds_9 = [val_predictions_naive(:,2) val_predictions_a(:,2) stackedprediction(:,2) val_predictions_c(:,2)];

f = figure;
f.Position = [100 100 900 300*length(preds_1)];
newcolors = ["#0072BD","#D95319","#77AC30"];
model_names = ["Model Naive", "Model A","Model B","Model C"];
set(f,'DefaultLineLineWidth',2)
colororder(newcolors);
for k0 = 1:4
    subplot(4, 1, k0)
    plot(df_test.time, df_test.t_sla)
    hold on
    plot(df_test.time, preds_1(:,k0))
    hold on
    plot(df_test.time, preds_9(:,k0))
    title(model_names(k0))
    legend(["Actual", "1 Step Prediction", "9 Step Prediction"])
end
saveas(gcf,"Code/project/figs/test_preds.png")


%% Lets do some residual analysis on the test data 
y_test = df_test.t_sla;
for k0 = 1:4
    disp("##########################" + model_names(k0) + "##########################")
    resid_1_test = y_test - preds_1(:,k0);
    resid_9_test = y_test - preds_9(:,k0);
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
end

%% Lets create all the acf plots on the validation data
y_test = df_val.t_sla;
f = figure;
f.Position = [100 100 900 300*length(preds_1)];
newcolors = ["#0072BD","#D95319","#77AC30"];
model_names = ["Model Naive", "Model A","Model B","Model C"];
set(f,'DefaultLineLineWidth',2)
for k0 = 0:3
    resid_1_val = y_test - val_preds_1(:,k0+1);
    resid_9_val = y_test - val_preds_9(:,k0+1);
    
    subplot(4, 2, 2*k0+1)
    
    rho = acf( resid_1_val, 50, 0.05, 1);
    
    title(model_names(k0+1) + " \epsilon_{t+1|t} ")
    
    subplot(4, 2, 2*k0+2)
    rho = acf( resid_9_val, 50, 0.05, 1);
    
    title(model_names(k0+1) + " \epsilon_{t+9|t} ")
end

sgtitle('ACFs of prediction residuals from validation data') 
saveas(gcf,"Code/project/figs/val_acfs.png")




