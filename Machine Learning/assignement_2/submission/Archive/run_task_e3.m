clear all
clc
load("A2_data.mat")
% 2
K = 2;
[y,C] = K_means_clustering(train_data_01, K);

%% viz
figure(1)
path = 'outputs/e3a.png';
dim = 28;
for i = 1:2
    subplot(1,2,i)
    imshow(reshape(C(:,i),dim,dim))
    str = sprintf('Cluster %d', i);
    title(str, 'FontSize', 10);
end
saveas(gcf,path)

%% 5
K = 5;
[y,C] = K_means_clustering(train_data_01, K);

%% viz
figure(2)
path = 'outputs/e3b.png';
for i = 1:5
    subplot(1,5,i)
    imshow(reshape(C(:,i),dim,dim))
    str = sprintf('Cluster %d', i);
    title(str, 'FontSize', 10);
end
saveas(gcf,path)




