
%% Task 5
clear all;
clc;
load("../A1_data.mat")
K = 50;
lambda_min = 0.1;
lambda_max = 10;
param_grid= exp(linspace(log(lambda_min),log(lambda_max), 50));
[wopt,lambdaopt,RMSEval,RMSEest] = lasso_cv(t,X,param_grid,K);

%% 
figure(1)
hold on
plot(param_grid, RMSEval, ['-', 'o', 'red'])
plot(param_grid, RMSEest,['-', '+', 'blue'])
xl=xline(lambdaopt, '--', ('Best \lambda'));
xl.LineWidth = 4;
xl.Color = 'black';
xlabel('lambda');
ylabel('RMSE');
set(gca, 'Xscale', 'log');
legend_string= sprintf('Lambda = %.3f',lambdaopt);
legend('RMSEval', 'RMSEest', legend_string);
xlabel('\lambda');
ylabel('RMSE');
saveas(gcf,'../outputs/t51.png')

%% 
figure(2)
hold on;
plot(n,t, ['o','red'])
plot(n, X * wopt, ['o','blue'])
plot(ninterp, Xinterp*wopt,['-','blue']);
legend_string= sprintf('Lambda = %.3f',lambdaopt);
legend(legend_string)
legend('Ground Truth', legend_string, 'interpolation', 'Interpreter','latex');
xlabel('Time indices n');
saveas(gcf,'../outputs/t52.png')
