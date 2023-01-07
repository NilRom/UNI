%% Deterministic Detrend 
df_train_temp = df_train;
x = linspace(1,length(df_train_temp.temperature),length(df_train_temp.temperature));
betas = polyfit(x,df_train_temp.temperature,1);
figure
plot(df_train_temp.temperature)
hold on
plot(x, betas(2) + betas(1)*x)
df_detrend = df_train_temp;
df_detrend.temperature = df_detrend.temperature - ones(1,length(x))'*betas(2) - betas(1)*x';
hold off
figure
plot(df_detrend.temperature)

%% Whiteness test on detrended zero meaned model
df_train_temp = df_detrend;
season = 24;
p = 2;
As = [1 zeros(1,season-2) -1 0];
A = ones(p+1,1);
A = conv(A, As);
A = [ones(1,p+1), zeros(1,season-p-1-1) 1 0 1];
C = [1];
Cs = [1 zeros(1,season-1) -1];
C = conv(C, Cs);


model_arma = estimateARMA(df_train_temp.temperature,A,C, 'SARMA(2,)', 48);
present(model_arma)


%% Make it zero mean
df_train_temp = df_train;
df_train_temp.temperature = df_train_temp.temperature - mean(df_train_temp.temperature);
plot(df_train_temp.time, df_train_temp.temperature)


%% check pred on modelling data
%   A(z) = 1,       B(z) = B(z),    F(z) = A2(z)
%   C(z) = C1(z),   D(z) = A1(z)
y = df_train.t_sla;
x = df_train.tp_stu;
time = df_train.time;

k = 9;
K_a = conv(foundModel.D, foundModel.F); %A1A2
K_b = conv(foundModel.D, foundModel.B); %A1B
K_c = conv(foundModel.F, foundModel.C); %A2C
[Fk, Gk] = polydiv( K_c, K_a, k );
[Fhat, Ghat] = polydiv( conv(K_b,Fk), K_c, k);
xhat = filter( Gk, K_c, x);
y_hat = filter( Gk, K_c, y ) + filter( Ghat, K_c, x ) + filter(Fhat, 1, xhat );

samples_to_remove = max([length(Fk), length(Fhat), length(Gk), length(Ghat), length(K_c), ...
    length(K_a), length(K_b)]) + 1;
y = y(samples_to_remove:end);
y_hat = y_hat(samples_to_remove:end);
time = time(samples_to_remove:end);

plot(time, y)
hold on
plot(time, y_hat)
legend(["Actual", k + "-step rediction"])
title("Model Prediction")


%% Check pred on validation data
%Let it warm start on training data to ring in
y = vertcat(df_train.t_sla, df_val.t_sla);
x = vertcat(df_train.tp_stu, df_val.tp_stu); 
time = vertcat(df_train.time, df_val.time); 

%Transform BJ formulation to ARMAX formulation
K_a = conv(foundModel.D, foundModel.F); %A1A2
K_b = conv(foundModel.D, foundModel.B); %A1B
K_c = conv(foundModel.F, foundModel.C); %A2C


k = 1;
y_hat = predictARMAX(K_a,K_b,K_c,y,x,k);

samples_to_remove = length(df_train.t_sla);
y = y(samples_to_remove:end);
y_hat = y_hat(samples_to_remove:end);
time = time(samples_to_remove:end);

plot(time,y_hat)
hold on
plot(time,y)
resid_val = y - y_hat;
legend(["Actual", k + "-step rediction"])
title("Validation")

%Look at validation residual
disp(k + " step prediction. Residual variance: "+ var(resid_val))
plotACFnPACF(resid_val, 50, "Validation Residual", 0.05);
checkIfWhite(resid_val);





%% lets do a 9 step prediction on our validation data
y = vertcat(df_train.t_sla, df_val.t_sla);
x = vertcat(df_train.tp_stu, df_val.tp_stu); 
time = vertcat(df_train.time, df_val.time); 
k = 9;
y_hat = predictARMAX(K_a,K_b,K_c,y,x,k);

samples_to_remove = length(df_train.t_sla);
y = y(samples_to_remove:end);
y_hat = y_hat(samples_to_remove:end);
time = time(samples_to_remove:end);

plot(time,y_hat)
hold on
plot(time,y)
resid_val = y - y_hat;
legend(["Actual", k + "-step rediction"])
title("Validation")

disp(k + " step prediction. Residual variance: "+ var(resid_val))
plotACFnPACF(resid_val, 50, "Validation Residual", 0.05);
checkIfWhite(resid_val);


%% Check pred on test data
y = df_test.t_sla;
x = df_test.tp_stu;
time = df_test.time;
k = 1;
K_a = conv(foundModel.D, foundModel.F); %A1A2
K_b = conv(foundModel.D, foundModel.B); %A1B
K_c = conv(foundModel.F, foundModel.C); %A2C

y_hat = predictARMAX(K_a,K_b,K_c,y,x,k);

%Remove corrupted samples
samples_to_remove = max([length(Fk), length(Fhat), length(Gk), length(Ghat), length(K_c), ...
    length(K_a), length(K_b)]) + 1;
y = y(samples_to_remove:end);
y_hat = y_hat(samples_to_remove:end);
time = time(samples_to_remove:end);


plot(time,y_hat)
hold on
plot(time,y)
resid_val = y - y_hat;
legend(["Actual", k + "-step rediction"])
title('Test')


disp(k + " step prediction. Residual variance: "+ var(resid_val))
plotACFnPACF(resid_val, 50, "Test Residual", 0.05);
checkIfWhite(resid_val);


%% Lets do a 9 step prediction on our test data

y = df_test.t_sla;
x = df_test.tp_stu;
time = df_test.time;
k = 9;
y_hat = predictARMAX(K_a,K_b,K_c,y,x,k);

%Remove corrupted samples
samples_to_remove = max([length(Fk), length(Fhat), length(Gk), length(Ghat), length(K_c), ...
    length(K_a), length(K_b)]) + 1;
y = y(samples_to_remove:end);
y_hat = y_hat(samples_to_remove:end);
time = time(samples_to_remove:end);


plot(time,y_hat)
hold on
plot(time,y)
resid_val = y - y_hat;
legend(["Actual", k + "-step rediction"])
title('Test')

disp(k + " step prediction. Residual variance: "+ var(resid_val))
plotACFnPACF(resid_val, 50, "Test Residual", 0.05);
checkIfWhite(resid_val);



%% Lets validate this model
%Warm start on training data to save samples in validation data
y = vertcat(df_train.t_sla, df_val.t_sla);
time = vertcat(df_train.time, df_val.time);
A = model_arma.a;
C = model_arma.c;

%Specify prediction horizon
k = 1;

%Solve diofantine equation
yhat_k_val = predictARMA(A,C,y,k);

%Remove samples from the modelling data that were used to warm start
yhat_k_val = yhat_k_val(length(df_train.t_sla):end);
y = y(length(df_train.t_sla):end);
time = time(length(df_train.time):end);

%Plot prediction and actual
plot(time, y)
hold on
plot(time, yhat_k_val)
legend(["Actual", k + "-Step Prediction"])

%Inspect Residual
resid_val = yhat_k_val - y;
disp(k + " step prediction. Residual variance: "+ var(resid_val))
disp("Validation Data variance : " + var(y))
plotACFnPACF(resid_val, 50, "Validation Residual", 0.05);
checkIfWhite(resid_val);


%% Do a 9 step prediction
y = vertcat(df_train.t_sla, df_val.t_sla);
time = vertcat(df_train.time, df_val.time);

%Specify prediction horizon
k = 9;

%Solve diofantine equation
yhat_k_val = predictARMA(A,C,y,k);

%Remove samples from the modelling data that were used to warm start
yhat_k_val = yhat_k_val(length(df_train.t_sla):end);
y = y(length(df_train.t_sla):end);
time = time(length(df_train.time):end);

%Plot prediction and actual
plot(time, y)
hold on
plot(time, yhat_k_val)
legend(["Actual", k + "-Step Prediction"])

%Inspect Residual
resid_val = yhat_k_val - y;
disp(k + " step prediction. Residual variance: "+ var(resid_val))
disp("Validation Data variance : " + var(y))
plotACFnPACF(resid_val, 50, "Validation Residual", 0.05);


%% lets test this model
k = 1;
y = df_test.t_sla;
time = df_test.time;

%Solve diofantine equations
yhat_k_test = predictARMA(A, C, y, k);

%Here we cant remove warm start samples. Instead we remove the necessary
%number of samples
samples_to_remove = max([length(A), length(C)]);
yhat_k_test = yhat_k_test(samples_to_remove:end);
y = y(samples_to_remove:end);
time = time(samples_to_remove:end);

%Plot prediction and actual
plot(time, y);
hold on 
plot(time, yhat_k_test);
legend(["Actual", k + "-Step Prediction"])

%Inspect Residual
resid_val = yhat_k_test - y;
disp(k + " step prediction. Residual variance: "+ var(resid_val))
disp("Validation Data variance : " + var(y))
plotACFnPACF(resid_val, 50, "Validation Residual", 0.05);
checkIfWhite(resid_val);

%% lets do a 9 step prediction
k = 9;
y = df_test.t_sla;
time = df_test.time;

%Solve diofantine equations
yhat_k_test = predictARMA(A, C, y, k);

%Here we cant remove warm start samples. Instead we remove the necessary
%number of samples
samples_to_remove = max([length(A), length(C)]);
yhat_k_test = yhat_k_test(samples_to_remove:end);
y = y(samples_to_remove:end);
time = time(samples_to_remove:end);

%Plot prediction and actual
plot(time, y);
hold on 
plot(time, yhat_k_test);
legend(["Actual", k + "-Step Prediction"])
title('Test')

%Inspect Residual
resid_val = yhat_k_test - y;
disp(k + " step prediction. Residual variance: "+ var(resid_val))
disp("Test Data variance : " + var(y))
plotACFnPACF(resid_val, 50, "Test Residual", 0.05);
checkIfWhite(resid_val);
