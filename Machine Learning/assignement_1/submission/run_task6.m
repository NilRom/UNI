%% Task 6
clear all;
clc;
load("../A1_data.mat")
grid_size = 50;
K = 10;
lambda_min = 1e-4;
lambda_max = 1;
param_grid= exp(linspace(log(lambda_min),log(lambda_max), grid_size));
[Wopt,lambdaopt,RMSEval,RMSEest] = multiframe_lasso_cv(Ttrain,X,param_grid,K);



%% Task 6 viz
figure(1)
hold on
plot(param_grid, RMSEval,['-', 'o', 'red'])
plot(param_grid, RMSEest,['-', '+', 'blue'])
xl = xline(lambdaopt, '--', ('Best \lambda'));
xl.LineWidth = 4;
xl.Color = 'black';
xlabel('\lambda');
ylabel('RMSE');
legend_string= sprintf('Lambda = %.3f',lambdaopt);
set(gca, 'Xscale', 'log');
legend('RMSEval', 'RMSEest', legend_string);
xlabel('\lambda');
ylabel('RMSE');
saveas(gcf,'../outputs/t61.png')

