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