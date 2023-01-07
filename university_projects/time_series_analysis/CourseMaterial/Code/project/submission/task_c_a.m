rng(0)
addpath Code/project/custom_functions/
clear 
clc
df = loadCleanValidate(0);
df = shift_exo(df, 0);
start_date = '1994-09-01';
[df_train, df_val, df_test] = trainValTestSplit(df, start_date, 0);

load Code/project/models/model_a.mat
load Code/project/models/model_b.mat
model_init_a = model_arma;
present(model_init_a)

%%
%trial and error

y = df.t_sla;


K_a = model_init_a.a;
K_c = model_init_a.c;



N = length(y);
ehat = zeros(N,1);


A = 1;
idx_a = find(K_a(2:end));
idx_c = find(K_c(2:end));

[idx_a idx_c]
disp("State space using")
disp("a_" + idx_a)
disp("c_" + idx_c)

xt_t1 = [K_a(idx_a+1) K_c(idx_c+1)]';
og_params = [K_a(idx_a+1) K_c(idx_c+1)]';
Rxx_1 = 1 * eye(length(xt_t1));
Re =  1e-7 * eye(length(xt_t1)); %make smaller
Rw = 0.22; %look at variance of previous residuals

ymix = zeros(N,1);
yhatk = zeros(N,1);
yhat1 = zeros(N,1 );

Xsave = zeros(length(xt_t1), N);
k = 9;

start = max([idx_a idx_c])+1;
ed = N-k;
for t = start:ed
    Ct = [-y(t-idx_a)' ehat(t-idx_c)'];

    yhat = Ct * xt_t1;        %y{t|t−1}
    
    
    ehat(t) = y(t) - yhat;       %%et=yt−y{t|t−1} One step prediction error
    
    
    % Update y parameter esimates
    Ryy = Ct * Rxx_1 * Ct' + Rw;                     %Rˆ{yy}{t|t−1}
    Kt = Rxx_1 * Ct' / Ryy;                      %Kt Kalman gain
    xt_t = xt_t1 + Kt * ehat(t);                      %x{t|t}
    Rxx = Rxx_1 - Kt * Ryy * Kt';                     %R{xx}{t|t}

  
    % Predict the next state
    xt_t1 = A * xt_t;                  %x_{t+1|t}
    Rxx_1 = A * Rxx * A' + Re;                  % Rˆ{xx} {t+1|t}

    
     %Form the 1 step prediction
    Ck = [-y(t-idx_a+1)' ehat(t-idx_c+1)'];                     %C{t+1|t}
    y_estimate = Ck * A * xt_t1;                           % \hat{y}_{t+1|t} = C_{t+1|t} A x_{t|t}
    ymix(t+1) = y_estimate;
    ymix(t) = y(t);
    yhat1(t+1) = y_estimate;

    % Loop over the rest using estimates where appropriate and real y
    % otherwise
    for i = 1:k
        Ck = [-ymix(t-idx_a+i)' ehat(t-idx_c+i)'];
        y_estimate = Ck * A * xt_t1;
        ymix(t+i) = y_estimate;
        ymix(t) = y(t);
    end
    yhatk(t+i) = y_estimate; 


    Xsave(:,t) = xt_t;
end
disp(var(ehat))



train_start = find(df.time == df_train.time(1));
train_end = find(df.time == df_train.time(end));
val_start = find(df.time == df_val.time(1));
val_end = find(df.time == df_val.time(end));
test_start = find(df.time == df_test.time(1));
test_end = find(df.time == df_test.time(end));


 %get preds
y_model = y(train_start:train_end);
yhat_model_1 = yhat1(train_start:train_end);
yhat_model_9 = yhatk(train_start:train_end);

%Validation
y_val = y(val_start:val_end);
yhat_val_1 = yhat1(val_start:val_end);
yhat_val_9 = yhatk(val_start:val_end);

%Test
y_test = y(test_start:test_end);
yhat_test_1 = yhat1(test_start:test_end);
yhat_test_9 = yhatk(test_start:test_end);


%plot preds
%modelling
f = figure;
newcolors = ["#0072BD","#D95319","#77AC30"];
colororder(newcolors);
f.Position = [100 100 1000 800];
set(f,'DefaultLineLineWidth',2)
subplot(311)
plot(df_train.time, df_train.t_sla)
hold on
plot(df_train.time, yhat_model_1)
plot(df_train.time, yhat_model_9)
title("Modeling Predictions")
legend(["Actual", "1 Step Prediction", "9 Step Prediction"])
ylabel("°C")

%Validation
subplot(312)
plot(df_val.time, df_val.t_sla)
hold on
plot(df_val.time, yhat_val_1)
plot(df_val.time, yhat_val_9)
title("Validation Predictions")
legend(["Actual", "1 Step Prediction", "9 Step Prediction"])
ylabel("°C")

saveas(gcf,"Code/project/figs/kalman_pred.png")


% Get residuals
resid_1_model = y_model - yhat_model_1;
resid_9_model = y_model - yhat_model_9;

resid_1_val = y_val - yhat_val_1;
resid_9_val = y_val - yhat_val_9;

% Check model residual
disp("##########################Modelling Residual Analysis##########################")
%plotACFnPACF(resid_1_model, 50, "Model Residual 1 Step", 0.05);
%plotACFnPACF(resid_9_model, 50, "Model Residual 9 Step", 0.05);
disp("Model Residual Variance 1 step: " + var(resid_1_model))
%figure
%whitenessTest(resid_1_model)
title("1 Step Model")
disp("Model Residual Variance 9 step: " + var(resid_9_model))
%figure
%whitenessTest(resid_9_model)
title("9 Step Model")


% Check Validation residual
disp("##########################Validation Residual Analysis##########################")
%plotACFnPACF(resid_1_val, 50, "Validation Residual 1 Step", 0.05);
%plotACFnPACF(resid_9_val, 50, "Validation Residual 9 Step", 0.05);
disp("Validation Residual Variance 1 step: " + var(resid_1_val))
%figure
%whitenessTest(resid_1_val)
title("1 Step Validation")
disp("Validation Residual Variance 9 step: " + var(resid_9_val))
%figure
%whitenessTest(resid_9_val)
title("9 Step Validation")



% plot param estimations
f = figure;
f.Position = [100 100 1000 800];
set(f,'DefaultLineLineWidth',2)
Q0 = og_params;
c_map = turbo(length(Q0));
leg = ["$\hat{a}$" + idx_a, "$\hat{c}$" + idx_c];
leg_2 = ["a" + idx_a, "c" + idx_c];
for k0=1:length(Q0)
    
    plot(df.time(start:ed),Xsave(k0,start:ed)', 'color', c_map(k0,:), 'DisplayName',leg(k0))    
    hold on
    line([df.time(start) df.time(ed)], [Q0(k0) Q0(k0)],'LineStyle',':','Color',c_map(k0,:), 'DisplayName',leg_2(k0))

end
line([df.time(start) df.time(ed)], [0 0],'LineStyle',':','Color',"black",'DisplayName',"0")

legend('Interpreter','latex')
title("Parameter Estimation")
saveas(gcf,"Code/project/figs/arma_kalman_param_estimation.png")

