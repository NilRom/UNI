
%% Task 5
clear all;
clc;
load("A1_data.mat")
K = 50;
lambda_min = 0.1;
lambda_max = 10;
param_grid= exp(linspace(log(lambda_min),log(lambda_max), 50));
[wopt,lambdaopt,RMSEval,RMSEest] = skeleton_lasso_cv(t,X,param_grid,K);

%% 
figure(1)
hold on
plot(param_grid, RMSEval,['-', 'o', 'red'])
plot(param_grid, RMSEest,['-', '+', 'blue'])
xline(lambdaopt, '--', ('Best \lambda'))
xlabel('lambda');
ylabel('RMSE');
set(gca, 'Xscale', 'log');
legend('RMSEval', 'RMSEest', 'Best Lambda');

figure(2)
hold on;
plot(n,t, ['o','red'])
plot(n, X * wopt, ['o','blue'])
plot(ninterp, Xinterp*wopt,['-','blue']);
legend_string= sprintf('Lambda = %.3f',lambdaopt);
legend(legend_string)
legend('Ground Truth', legend_string, 'interpolation', 'Interpreter','latex');
