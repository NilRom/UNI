clear all
clc
load("A2_data.mat")
K = 2;
[y,C] = K_means_clustering(train_data_01, K);
[pi, W] = run_pca(train_data_01, 2);

%% viz
C_norm = zeros(size(C));
for i=1:K
        C_norm(:,i) = C(:,i)-mean(train_data_01,2); 
end
C_proj = W'*C_norm; 
figure
hold on
path = 'outputs/e2.png';
viz_pca(pi, y)
plot(C_proj(1,:),C_proj(2,:), 'kx','LineWidth',3)
legend('Cluster 1','Cluster 2','Centroids');
title('Clustering Results')
saveas(gcf,path)

%%
K = 5;
[y,C] = K_means_clustering(train_data_01, K);

%% viz
C_norm = zeros(size(C));
for i=1:K
        C_norm(:,i) = C(:,i)-mean(train_data_01,2); 
end
C_proj = W'*C_norm; 
figure
path = 'outputs/e2b.png';
hold on
viz_pca(pi, y)
plot(C_proj(1,:),C_proj(2,:), 'kx','LineWidth',3)
lgd = legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4','Cluster 5','Centroids');
title('Clustering Results')
saveas(gcf,path)
