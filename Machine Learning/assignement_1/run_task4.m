
%% Task 4
clear all;
clc;
load("A1_data.mat")
lambda = 0.1;
w1 = skeleton_lasso_ccd(t,X,lambda);
nnz_1 = nnz(w1);
lambda = 10;
w2 = skeleton_lasso_ccd(t,X,lambda);
nnz_2 = nnz(w2);
lambda = 3;
w3 = skeleton_lasso_ccd(t,X,lambda);
nnz_3 = nnz(w3);

figure(1)
hold on;
plot(n,t, ['o','red'])
plot(n, X * w1, ['o','blue'])
plot(ninterp, Xinterp*w1,['-','blue']);
legend('Ground Truth', 'lambda = 0.1', 'interpolation');

figure(2)
hold on;
plot(n,t, ['o','red'])
plot(n, X * w2, ['o','blue'])
plot(ninterp, Xinterp*w2,['-','blue']);
legend('Ground Truth', 'lambda = 10', 'interpolation');

figure(3)
hold on;
plot(n,t, 'o')
plot(n, X * w3, 'o')
plot(ninterp, Xinterp*w3,['-','blue']);
legend('Ground Truth', 'lambda = 4', 'interpolation');
[nnz_1, nnz_2, nnz_3]'




