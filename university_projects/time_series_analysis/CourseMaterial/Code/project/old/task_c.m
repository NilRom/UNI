rng(0)
addpath Code/project/custom_functions/
clear 
clc
df = loadCleanValidate(0);
start_date = '1994-09-01';
[df_train, df_val, df_test] = trainValTestSplit(df, start_date, 1);


%%
load Code/project/models/model_a.mat
load Code/project/models/model_b.mat
model_init_a = model_arma;
model_init_b = foundModel;
present(model_init_a)
present(model_init_b)


%% 
% Reformulate BJ model on the ARMAX form
K_a = conv(model_init_b.D, model_init_b.F); %A1A2 This is A
K_b = conv(model_init_b.D, model_init_b.B); %A1B This is B
K_c = conv(model_init_b.F, model_init_b.C); %A2C This is C

y = df.t_sla;
u = df.tp_stu;
N = length(y);
ehat = zeros(N,1);
A = 1;
idx_a = find(K_a(2:end));
idx_c = find(K_c(2:end));
idx_b = [0 find(K_b(1:end-1))];
[idx_a idx_c idx_b]
disp("State space representation including")
disp("a_" + idx_a)
disp("c_" + idx_c)
disp("b_" + idx_b)
xt_t1 = [K_a(idx_a+1) K_c(idx_c+1) K_b(idx_b+1)]';
disp("a_" + idx_a + " = " + K_a(idx_a+1))
disp("c_" + idx_c + " = " + K_c(idx_c+1))
disp("b_" + idx_b + " = " + K_b(idx_b+1))
og_params = xt_t1;
Rxx_1 = 1 * eye(length(xt_t1));
Re = 1e-3 * eye(length(xt_t1)); %make smaller
Rw = 3; %look at variance of previous residuals
yhats = zeros(N,1);
yhatk = zeros(N,1);
Xsave = zeros(length(xt_t1), N);

k = 9;

%%
start = max([idx_a idx_b idx_c])+1;
ed = N-k;
for t = start:ed
    Ct = [-y(t-idx_a)' ehat(t-idx_c)' u(t-idx_b)'];

    yhat = Ct * xt_t1;          %y{t|t−1}
    yhats(t) = yhat;
    ehat(t) = y(t) - yhat;       %%et=yt−y{t|t−1} One step prediction error
    
    % Update
    Ryy = Ct * Rxx_1 * Ct' + Rw;                     %Rˆ{yy}{t|t−1}
    Kt = Rxx_1 * Ct' / Ryy;                      %Kt Kalman gain
    xt_t = xt_t1 + Kt * ehat(t);                      %x{t|t}
    Rxx = Rxx_1 - Kt * Ryy * Kt';                     %R{xx}{t|t}

    % Predict the next state
    xt_t1 = A * xt_t;                  %x_{t+1|t}
    Rxx_1 = A * Rxx * A' + Re;                  % Rˆ{xx} {t+1|t}
    
    %Form the 2 step prediction
    Ck = [-y(t-idx_a+1)' ehat(t-idx_c+1)' u(t-idx_b+1)'];                     %C{t+1|t}
    yk = [Ck * xt_t1 zeros(1,12)];                           % \hat{y}_{t+1|t} = C_{t+1|t} A x_{t|t}
    
    for k0=2:k
        Ck = [-yk ehat(t - idx_c + k0)' u(t - idx_b + k0)']; % C_{t+k|t}
        yk(k0) = Ck * A^k * xt_t1;                    % \hat{y}_{t+k|t} = C_{t+k|t} A^k x_{t|t}
    end
    yhatk(t) = yk(k);       

    Xsave(:,t) = xt_t;
end
disp(var(ehat))

%% Validation
val_start = find(df.time == df_val.time(1));
val_stop = find(df.time == df_val.time(end));

%% Plot prediction on validation set
plot(y(val_start:val_stop))
hold on
plot(yhatk(val_start:val_stop))
legend(["Actual", "Pred"])


%% Check validation residual
val_resid = y(val_start:val_stop) - yhatk(val_start:val_stop);
var(val_resid)
disp(k + " Step Validation Residual Variance: " + var(val_resid))
plotACFnPACF(val_resid, 20, k + " Step Test Residual");
figure
whitenessTest(val_resid);



%% Test
test_start = find(df.time == df_test.time(1));
test_stop = find(df.time == df_test.time(end));

%plot prediction on test set
plot(y(test_start:test_stop))
hold on
plot(yhatk(test_start:test_stop))
legend(["Actual", "Pred"])


%% check test residual
val_resid = y(test_start:test_stop) - yhatk(test_start:test_stop);
disp(k + " Step Test Residual Variance: " + var(val_resid))
plotACFnPACF(val_resid, 20, k + " Step Test Residual");
figure
whitenessTest(val_resid);

%% check params
plot(df.time(start:ed),Xsave(:,start:ed)')
hold on
Q0 = og_params;
for k0=1:length(Q0)
    line([df.time(start) df.time(ed)], [Q0(k0) Q0(k0)], 'Color','red','LineStyle',':')
end



%%
estimateARMA(y,K_a,K_c,'hello',24)


%% Lets try to simulate some data to check the implementation

K_a = [1 0.5 0.4 0.5];
K_c = [1 0.2 0.3];
K_a_2 = [1 0.7 0.1];
K_c_2 = [1 0.3 0.5];
K_b = [-0.001];



rng(0);
N = 10000;
P = [7/8 1/8; 1/8 7/8];
mc = dtmc(P);
u = simulate(mc,2*N-1)-1;
ee = 0.1*randn(N,1);
y = filter(K_c, K_a, ee);
y2 = filter(K_c_2, K_a_2, ee);
y = vertcat(y,y2);
y = y + filter(K_b, 1, u);
N = 2*N;
ehat = zeros(N,1);
A = 1;
idx_a = find(K_a(2:end));
idx_c = find(K_c(2:end));
idx_b = [0 find(K_b(1:end-1))];
[idx_a idx_c idx_b]
xt_t1 = [nonzeros(K_a(2:end))' nonzeros(K_c(2:end))' nonzeros(K_b(1:end))']';
og_params = [nonzeros(K_a(2:end))' nonzeros(K_c(2:end))' nonzeros(K_b(1:end))']';
og_params_2 = [nonzeros(K_a_2(2:end))' nonzeros(K_c_2(2:end))' nonzeros(K_b(1:end))']';
Rxx_1 = 1 * eye(length(xt_t1));
Re =  1e-3 * eye(length(xt_t1)); %make smaller
Rw = 3; %look at variance of previous residuals
yhats = zeros(N,1);
yhatk = zeros(N,1);
Xsave = zeros(length(xt_t1), N);
k = 9;
plot(y(100:200))
hold on
plot(u(100:200))



%% 
start = max([idx_a idx_b idx_c])+1;
ed = N-k;
for t = start:ed
    Ct = [-y(t-idx_a)' ehat(t-idx_c)' u(t-idx_b)'];

    yhat = Ct * xt_t1;          %y{t|t−1}
    ehat(t) = y(t) - yhat;       %%et=yt−y{t|t−1} One step prediction error
    yhats(t) = yhat;
    % Update
    Ryy = Ct * Rxx_1 * Ct' + Rw;                     %Rˆ{yy}{t|t−1}
    Kt = Rxx_1 * Ct' / Ryy;                      %Kt Kalman gain
    xt_t = xt_t1 + Kt * ehat(t);                      %x{t|t}
    Rxx = Rxx_1 - Kt * Ryy * Kt';                     %R{xx}{t|t}

    % Predict the next state
    xt_t1 = A * xt_t;                  %x_{t+1|t}
    Rxx_1 = A * Rxx * A' + Re;                  % Rˆ{xx} {t+1|t}
    
     %Form the 2 step prediction
    Ck = [-y(t-idx_a+1)' ehat(t-idx_c+1)' u(t-idx_b+1)'];                     %C{t+1|t}
    yhat1 = Ck * A * xt_t1;                           % \hat{y}_{t+1|t} = C_{t+1|t} A x_{t|t}
    Ck = [-yhat1 -y(t) y(t-1) ehat(t-idx_c+2)' u(t-idx_b+2)'];
    yhat2 = Ck * A * xt_t1;
    Ck = [-yhat2 -yhat1 y(t) ehat(t-idx_c+3)' u(t-idx_b+3)'];
    yhat3 = Ck * A * xt_t1;
    Ck = [-yhat3 -yhat2 ehat(t-idx_c+4)' u(t-idx_b+4)'];
    yhat4 = Ck * A * xt_t1;
    Ck = [-yhat4 -yhat3 ehat(t-idx_c+5)' u(t-idx_b+5)'];
    yhat5 = Ck * A * xt_t1;
    Ck = [-yhat5 -yhat4 ehat(t-idx_c+6)' u(t-idx_b+6)'];
    yhat6 = Ck * A * xt_t1;
    Ck = [-yhat6 -yhat5 ehat(t-idx_c+7)' u(t-idx_b+7)'];
    yhat7 = Ck * A * xt_t1;
    Ck = [-yhat7 -yhat6 ehat(t-idx_c+8)' u(t-idx_b+8)'];
    yhat8 = Ck * A * xt_t1;
    Ck = [-yhat8 -yhat7 ehat(t-idx_c+9)' u(t-idx_b+9)'];
    yhat9 = Ck * A * xt_t1;
    %for k0=2:k
     %   Ck = [yhatk(t-idx_a+k0)' ehat(t - idx_c + k0)' u(t - idx_b + k0)']; % C_{t+k|t}
     %   yk = Ck * A^k * xt_t1;                    % \hat{y}_{t+k|t} = C_{t+k|t} A^k x_{t|t}
    %end
    yhatk(t+9) = yhat9;       
     

    Xsave(:,t) = xt_t;
end
disp(var(ehat))


% %% Plot prediction on validation set
figure
 plot(y(10:200))
 hold on
 plot(yhatk(10:200))
 legend(["Actual", "Pred"])

figure
Q0 = og_params;
Q0_2 = og_params_2;
plot(Xsave(:,1:ed)')
hold on
for k0=1:length(Q0)
    
    line([1 N], [Q0(k0) Q0(k0)],'LineStyle',':')
    line([1 N], [Q0_2(k0) Q0_2(k0)],'color', 'red', 'LineStyle',':')
end
legend(["a1","a2","c1","c2", "b0"])


%% Lets try to simulate some data to check the implementation

K_a = [1 0.5 0.4 0.5];
K_c = [1 0.2 0.3];
K_b = [0.000000001];



rng(0);
N = 10000;
P = [7/8 1/8; 1/8 7/8];
mc = dtmc(P);
u = simulate(mc,N-1)-1;
ee = 0.1*randn(N,1);
y = filter(K_c, K_a, ee);
y = y + filter(K_b, 1, u);
ehat = zeros(N,1);
A = 1;
idx_a = find(K_a(2:end));
idx_c = find(K_c(2:end));
idx_b = [0 find(K_b(1:end-1))];
[idx_a idx_c idx_b]
xt_t1 = [nonzeros(K_a(2:end))' nonzeros(K_c(2:end))' nonzeros(K_b(1:end))']';
xut_t1 = [1]';
og_params = [nonzeros(K_a(2:end))' nonzeros(K_c(2:end))' nonzeros(K_b(1:end))']';
Rxx_1 = 1 * eye(length(xt_t1));
Ruu_1 = 1 * eye(length(xut_t1));
Re =  1e-6 * eye(length(xt_t1)); %make smaller
Reu =  1e-3 * eye(length(xut_t1)); %make smaller
Rw = 3; %look at variance of previous residuals

ymix = zeros(N,1);
yhatk = zeros(N,1);

umix = zeros(N,1);
uhatk = zeros(N,1);

Xsave = zeros(length(xt_t1), N);
k = 1;
plot(y(100:200))
hold on
plot(u(100:200))



%% 
start = max([idx_a idx_b idx_c])+1;
ed = N-k;
for t = start:ed
    Ct = [-y(t-idx_a)' ehat(t-idx_c)' u(t-idx_b)'];
    Cu = [-u(t-idx_b-1)'];

    yhat = Ct * xt_t1;          %y{t|t−1}
    uhat = Cu * xut_t1;
    
    ehat(t) = y(t) - yhat;       %%et=yt−y{t|t−1} One step prediction error
    ehat_u(t) = u(t) - uhat;       %%et=yt−y{t|t−1} One step prediction error
    
    % Update y parameter esimates
    Ryy = Ct * Rxx_1 * Ct' + Rw;                     %Rˆ{yy}{t|t−1}
    Kt = Rxx_1 * Ct' / Ryy;                      %Kt Kalman gain
    xt_t = xt_t1 + Kt * ehat(t);                      %x{t|t}
    Rxx = Rxx_1 - Kt * Ryy * Kt';                     %R{xx}{t|t}

    % Update u parameter esimates
    Ryy = Cu * Ruu_1 * Cu' + Rw;                     %Rˆ{yy}{t|t−1}
    Ku = Ruu_1 * Cu' / Ryy;                      %Kt Kalman gain
    xut_t1 = xut_t1 + Ku * ehat_u(t);                      %x{t|t}
    Ruu = Ruu_1 - Ku * Ryy * Ku';  

    % Predict the next state
    xt_t1 = A * xt_t;                  %x_{t+1|t}
    Rxx_1 = A * Rxx * A' + Re;                  % Rˆ{xx} {t+1|t}

    % Predict the next signal state
    xut_t1 = A * xut_t1;                  %x_{t+1|t}
    Ruu_1 = A * Ruu * A' + Reu;                  % Rˆ{xx} {t+1|t}
    
     %Form the 1 step prediction
    Ck = [-y(t-idx_a+1)' ehat(t-idx_c+1)' u(t-idx_b+1)'];                     %C{t+1|t}
    y_estimate = Ck * A * xt_t1;                           % \hat{y}_{t+1|t} = C_{t+1|t} A x_{t|t}
    ymix(t+1) = y_estimate;
    ymix(t) = y(t);

     %Form the 1 step prediction
    Cuk = [-u(t-idx_b+1)'];                     %C{t+1|t}
    u_estimate = Cuk * A * xut_t1;                           % \hat{y}_{t+1|t} = C_{t+1|t} A x_{t|t}
    umix(t+1) = u_estimate;
    umix(t) = u(t);
    % Loop over the rest using estimates where appropriate and real y
    % otherwise
    for i = 1:k
        Ck = [-ymix(t-idx_a+i)' ehat(t-idx_c+i)' umix(t-idx_b+i)'];
        Cuk = [-u(t-idx_b+i-1)']; 
        y_estimate = Ck * A * xt_t1;
        u_estimate = Cuk * A * xut_t1;
        ymix(t+i) = y_estimate;
        ymix(t) = y(t);
        umix(t+i) = u_estimate;
        umix(t) = u(t);
    end
    yhatk(t+i) = y_estimate; 
    uhatk(t+i) = u_estimate;


    Xsave(:,t) = xt_t;
end
disp(var(ehat))

% %% Plot prediction on validation set
figure
 plot(y(100:200))
 hold on
 plot(yhatk(100:200))
 legend(["Actual", "Pred"])
 title("y k step prediction")

 figure
plot(u(100:150))
hold on
plot(uhatk(100:150))
legend(["Actual", "Pred"])
title("u k step prediction")


figure
Q0 = og_params;
Q0_2 = og_params_2;
plot(Xsave(:,1:ed)')
hold on
for k0=1:length(Q0)
    
    line([1 N], [Q0(k0) Q0(k0)],'LineStyle',':')
end
legend(["a1","a2", "a3","c1","c2", "b0", "b1"])



%% 
clear 
close


