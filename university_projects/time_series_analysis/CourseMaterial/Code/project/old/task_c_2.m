rng(0)
addpath Code/project/custom_functions/
clear 
clc
df = loadCleanValidate(0);
start_date = '1994-09-01';
[df_train, df_val, df_test] = trainValTestSplit(df, start_date, 0);
load Code/project/models/model_a.mat
model_init_a = model_arma;
present(model_init_a)


%%
model_init_a = model_arma;
%Uncomment this to check if param estimation works with simple model
%A = [1 1 1];
%C = [1 1 1];
%model_init_a = estimateARMA(df_train.t_sla,A,C, "Hello", 48);

K_a = model_init_a.A;
K_c = model_init_a.C;
y = df.t_sla;
N = length(y);
ehat = zeros(N,1);
idx_a = find(K_a(2:end));
idx_c = find(K_c(2:end));
disp("State space representation including")
disp("a_" + idx_a)
disp("c_" + idx_c)
xt_t1 = [nonzeros(K_a(2:end))' nonzeros(K_c(2:end))']';
og_params = [nonzeros(K_a(2:end))' nonzeros(K_c(2:end))']';
A = 1;
Rxx_1 = 1 * eye(length(xt_t1));
Re =  5e-8 * eye(length(xt_t1)); %make smaller
Rw = 0.4; %look at variance of previous residuals
ymix = zeros(N,1);
yhatk = zeros(N,1);
Xsave = zeros(length(xt_t1), N);

k = 9;




start = max([idx_a idx_c])+1;


ed = N-k;
for t = start:ed
    
    Ct = [-y(t-idx_a)' ehat(t-idx_c)'];
    yhat = Ct * xt_t1;          %y{t|t−1}
    ehat(t) = y(t) - yhat;       %%et=yt−y{t|t−1} One step prediction error

    Ryy = Ct * Rxx_1 * Ct' + Rw;                     %Rˆ{yy}{t|t−1}
    Kt = Rxx_1 * Ct' / Ryy;                         %Kt Kalman gain
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


figure
Q0 = og_params;

c_map = turbo(length(Q0(1:length(xt_t1))));
for k0=1:length(Q0(1:length(xt_t1)))
    
    plot(df.time(start:ed),Xsave(k0,start:ed)', 'color', c_map(k0,:))    
    hold on
    line([df.time(start) df.time(ed)], [Q0(k0) Q0(k0)],'LineStyle',':','Color',c_map(k0,:))

end


figure
val_start = find(df.time == df_val.time(1));
val_stop = find(df.time == df_val.time(end));
test_start = find(df.time == df_test.time(1));
test_stop = find(df.time == df_test.time(end));


plot(y(val_start:val_stop))
hold on
plot(yhatk(val_start:val_stop))
legend(["Actual", "Pred"])

figure
plot(y(test_start:test_stop))
hold on
plot(yhatk(test_start:test_stop))
legend(["Actual", "Pred"])
title("test")


val_resid = y(val_start:val_stop) - yhatk(val_start:val_stop);
var(val_resid)
disp(k + " Step Validation Residual Variance: " + var(val_resid))
plotACFnPACF(val_resid, 20, k + " Step val Residual");
figure
whitenessTest(val_resid);

val_resid = y(test_start:test_stop) - yhatk(test_start:test_stop);
var(val_resid)
disp(k + " Step Test Residual Variance: " + var(val_resid))
plotACFnPACF(val_resid, 20, k + " Step Test Residual");
figure
whitenessTest(val_resid);



