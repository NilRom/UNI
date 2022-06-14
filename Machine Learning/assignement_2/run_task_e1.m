clear all
clc
load("A2_data.mat") 
data = train_data_01;
pi = run_pca(data, 2);

%%
path = 'outputs/t41.png';
figure
viz_pca(pi, train_labels_01)
legend('Class 0','Class 1')
saveas(gcf,path)




