addpath('Code/functions', 'Code/data')  
clear
clc
load tar2.dat
load thx.dat
%% EDA
subplot(211)
plot(tar2)
subplot(212)
plot(thx)

%% 2.1 Recursive Least Squares estimation
X = recursiveAR (2);
X.ForgettingFactor = 0.95; X.InitialA = [1 0 0];
for kk=1:length(tar2)
    [Aest(kk,:) ,yhat(kk)] = step(X, tar2(kk) );
end

%% Plot real and estimated paramteres

subplot(211)
plot(thx)
title('Real Parameters')
subplot(212)
plot(Aest(:,2:end))
title('Estimated Parameters')


%% Find Best Lambda
n = 100;
lambda_line = linspace(0.85, 1, n);
ls2 = zeros(n,1);
yhat = zeros(n,1);
for i = 1:length(lambda_line)
    reset(X)
    X.ForgettingFactor = lambda_line(i);
    X.InitialA = [1 0 0];
    for kk = 1:length(tar2)
        [~, yhat(kk)] = step(X, tar2(kk));
    end
    ls2(i) = sum((tar2 - yhat).^2);
end
plot(lambda_line, ls2)


%% Find best lambda
[min_val, min_index] = min(ls2);
disp("Best $\{lambda}$ : " + lambda_line(min_index))

%% 2.2 Kalman Filtering for time series
y = tar2;
N = length(y);

%Define state space equations
A = 1;
Re = [ .004 0; 0 0];
Rw = 1.25;
Rxx_1 = 10*eye(2); %Initial state variance
xt_t1 = [0 0]'; %Initial state value
Xsave = zeros(length(xt_t1), N);
ehat = zeros(1,N);
yt1 = zeros(1,N);
yt2 = zeros(1,N);


%The filter use data up to time t−1 to predict value at t, % then update using the prediction error . Why do we start
% from t=3? Why stop at N−2?
for t = 3:N-2
    Ct = [-y(t-1) -y(t-2)]; %C{t|t−1}
    yhat = Ct * xt_t1;          %y{t|t−1}
    ehat(t) = y(t) - yhat;       %%et=yt−y{t|t−1} One step prediction error
    
    % Update
    Ryy = Ct * Rxx_1 * Ct' + Rw;                     %Rˆ{yy}{t|t−1}
    Kt = Rxx_1 * Ct' / Ryy;                      %Kt Kalman gain
    xt_t = xt_t1 + Kt * ehat(t);                      %x{t|t}
    Rxx = Rxx_1 - Kt * Ryy * Kt';                     %R{xx}{t|t}

    % Predict the next state
    xt_t1 = A * xt_t;                  %x_{t+1|t}
    Rxx_1 = A * Rxx * A' + Re;                  % Rˆ{xx} {t+1|t}
    %Pred part which we ignore at first

    Xsave(:,t) = xt_t;
end
disp(sum(ehat.^2))

%%
plot(thx, "blue")
hold on
plot(Xsave', "red")
title('Estimated Parameters and Real Parameters')
ylim([-2 2])
legend(["Real Params","",  "Estimated Params", ""])
%%
disp("Sum of squares is: " + sum(ehat.^2))


%% 2.3 Using Kalman Filtering for prediction

rng (0);
N = 10000;
ee = 0.1*randn(N,1);
A0 = [1 -.8 .2];
y = filter(1, A0, ee);
Re = [1e-6 0; 0 1e-6];
Rw = 0.1;

%Define state space equations
A = 1;
Rxx_1 = 10*eye(2); %Initial state variance
xt_t1 = [0 0]'; %Initial state value
Xsave = zeros(length(xt_t1), N);
ehat = zeros(1,N);
yt1 = zeros(1,N);
yt2 = zeros(1,N);


%The filter use data up to time t−1 to predict value at t, % then update using the prediction error . Why do we start
% from t=3? Why stop at N−2?
for t = 3:N-2
    Ct = [-y(t-1) -y(t-2)]; %C{t|t−1}
    yhat = Ct * xt_t1;          %y{t|t−1}
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
    Ct1 = [-y(t) -y(t-1)];                     %C{t+1|t}
    yt1(t+1) = Ct1 * xt_t1;                % y {t+1|t} = C {t+1|t} x {t|t}
    Ct2 = [-yt1(t+1) -yt1(t)];                     %C{t+2|t}
    yt2(t+2) = Ct2 * xt_t1;                 % y {t+2|t} = C {t+2|t} x {t|t}
    Xsave(:,t) = xt_t;
end
disp(sum(ehat.^2))


%%
plot( y(end-100-2:end-2) )
hold on
plot( yt1(end-100-1:end-1),'g' )
plot( yt2(end-100:end),'r')
hold off
legend ( 'y ' , ' k=1 ' , ' k=2 ' )


%%
plot([-.8*ones(length(Xsave),1) .2*ones(length(Xsave),1)])
hold on
plot(Xsave(:,1:end-2)')
title('Estimated Parameters and Real Parameters')
legend(["$a_1$","$a_2$","$\hat{a}_1$", "$\hat{a}_2$"],'Interpreter','latex')
ylim([-2 2])


%% 2.4 Quality Control of a Process


%% Dr Markov Chain
N = 1000;
P = [7/8 1/8; 1/8 7/8];
mc = dtmc(P);
u = simulate(mc,N);
subplot(211);
graphplot(mc,'ColorEdges',true);
title("Process Viz")
subplot(212)
plot(u)
title("Realisation")


%%
rng(1)
N = 1000;
P = [7/8 1/8; 1/8 7/8];
mc = dtmc(P);
u = simulate(mc,N-1) - 1;
sigma2_e = 1;
sigma2_v = 4;
b = 20;
ee = sigma2_e * randn(N,1);
ev = sigma2_v * randn(N,1);
x = filter(1, [1 -1], ee);
y = x + b * u + ev;
plot(y)
hold on
plot(u*b)


%% 
%Get state space formulation from 8,7 in book
Re = [sigma2_e 0; 0 0];
Rw = sigma2_v;

%Define state space equations
A = eye(2);
Rxx_1 = 10*eye(1); %Initial state variance
xt_t1 = [0 0]'; %Initial state value i.e x and b stacked
Xsave = zeros(length(xt_t1), N);
ehat = zeros(1,N);
yt1 = zeros(1,N);
yt2 = zeros(1,N);



%The filter use data up to time t−1 to predict value at t, % then update using the prediction error . Why do we start
% from t=3? Why stop at N−2?
for t = 3:N-2
    Ct = [1 u(t)]; %C{t|t−1}
    yhat = Ct * xt_t1;          %y{t|t−1}
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
    %Ct1 = [-y(t) ];                     %C{t+1|t}
    %yt1(t+1) = Ct1 * xt_t1;                % y {t+1|t} = C {t+1|t} x {t|t}
    %Ct2 = [-yt1(t+1)];                     %C{t+2|t}
    %yt2(t+2) = Ct2 * xt_t1;                 % y {t+2|t} = C {t+2|t} x {t|t}
    Xsave(:,t) = xt_t;
end
disp(sum(ehat.^2))


%%

plot(Xsave(:,1:end-2)')
hold on
plot(x)
yline(20)
legend(["$\hat{x}$","$\hat{b}$", "x", "b"],'Interpreter','latex')
xlabel("Iteration")
ylabel("Parameter Value")


%% 2.5 Recursive Temperature Modelling
clear
load svedala94.mat
T = linspace(datenum(1994 ,1 ,1) ,datenum(1994 ,12 ,31) ,...
    length(svedala94 ));
plot(T, svedala94 );
datetick('x');

%%
season = 6;
differ = [1 zeros(1,season - 1) -1];
ydiff = filter(differ, 1, svedala94);
plot(T, ydiff);
hold on
plot(T, svedala94 );
datetick('x');
legend(["Detrended", "Original"])

%%
th = armax(ydiff ,[2 2]);
th_winter = armax( ydiff (1:540) ,[2 2]);
th_summer = armax( ydiff (907:1458) ,[2 2]);

%%
X = recursiveARMA([2 2]);
X.InitialA = [1 th_winter.A(2:end)];
X.InitialC = [1 th_winter.C(2:end)];
X.ForgettingFactor = 0.99;
for k=1:length( ydiff )
[Aest(k,:) ,Cest(k,:) ,yhat(k)] = step( X, ydiff(k) );
end

%%
subplot 211
plot(T, svedala94);
datetick('x')
subplot 212
plot(Aest (: ,2:3))
hold on
plot(repmat(th_winter.A(2:end),[length(ydiff) 1]),'g:');
plot(repmat(th_summer.A(2:end),[length(ydiff) 1]),'r:');
axis tight
hold off
datetick('x')


%% 2.6 Recursive Temperature Modelling, again

clear
load svedala94
y = svedala94(850:1100) - mean(svedala94(850:1100));
plot(y)
%%
season = 6;
t = (1:length(y))';
U = [sin(2*pi*t/season) cos(2*pi*t/season)];
Z = iddata(y,U);
model = [3 [1 1] 4 [0 0]]; %[na [nb1 nb2] nc [nk1 nk2]]; BJ scheme
thx = armax(Z,model);


plot(U*cell2mat(thx.b)')
hold on
plot(y)
legend(["Season", "y"])
%At some points it is well modelled, at some points not. The season seems
%to vary over time


%%

U = [sin(2*pi*t/6) cos(2*pi*t/6) ones(size(t ))];
Z = iddata(y,U);
m0 = [thx.A(2:end) cell2mat(thx.B) 0 thx.C(2:end)];
Re = diag([0 0 0 0 0 1 0 0 0 0] );
model=[3 [1 1 1] 4 0 [0 0 0] [1 1 1]];
[thr,yhat] = rpem(Z,model,'kf',Re,m0);
plot(y)
hold on
plot(yhat)

%%
m= thr(:,6);
a = thr(end,4);
b = thr(end,5);
y_mean = m + a*U(:,1)+b*U(: ,2);
y_mean = [0;y_mean(1:end-1)];

plot(y)
hold on
plot(y_mean)
