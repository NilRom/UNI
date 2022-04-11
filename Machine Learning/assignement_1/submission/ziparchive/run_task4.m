
%% Task 4
clear all;
clc;
load("../A1_data.mat")
lambda = 0.1;
w1 = lasso_ccd(t,X,lambda);
nnz_1 = nnz(w1);
lambda = 10;
w2 = lasso_ccd(t,X,lambda);
nnz_2 = nnz(w2);
lambda = 1;
w3 = lasso_ccd(t,X,lambda);
nnz_3 = nnz(w3);
w_perfect = lasso_ccd(t,X,0);
nnz_perfect = nnz(w_perfect);

fig = figure(1);
hold on;
plot(n,t, ['o','red'])
plot(n, X * w1, ['o','blue'])
plot(ninterp, Xinterp*w1,['-','blue']);
legend('Ground Truth', 'lambda = 0.1', 'interpolation');
xlabel('Time indices n');
saveas(gcf,'../outputs/t41.png')


figure(2)
hold on;
plot(n,t, ['o','red'])
plot(n, X * w2, ['o','blue'])
plot(ninterp, Xinterp*w2,['-','blue']);
legend('Ground Truth', 'lambda = 10', 'interpolation');
xlabel('Time indices n');
saveas(gcf,'../outputs/t42.png')


figure(3)
hold on;
plot(n,t, ['o','red'])
plot(n, X * w3, ['o','blue'])
plot(ninterp, Xinterp*w3,['-','blue']);
legend('Ground Truth', 'lambda = 1', 'interpolation');
non_zero_params = [0.1 nnz_1;10 nnz_2;1 nnz_3;0 nnz_perfect]

xlabel('Time indices n');
saveas(gcf,'../outputs/t43.png')



