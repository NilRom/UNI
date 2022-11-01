clear all
clc
load("A2_data.mat")
% 2

K = 2;
[~, N] = size(train_data_01)
[cluster_assignement,centroid] = K_means_clustering(train_data_01, K);
[num_ones, num_zeros, miss, cluster_labels] = K_means_classifier(cluster_assignement, train_labels_01, centroid, K);
train_k_2 = [[1;2] num_zeros, num_ones, cluster_labels, miss]
sum_miss = sum(miss)
miss_rate = sum_miss/N*100


[~, N] = size(test_data_01)
[cluster_assignement,centroid] = K_means_clustering(test_data_01, K);
[num_ones, num_zeros, miss, cluster_labels] = K_means_classifier(cluster_assignement, test_labels_01, centroid, K, cluster_labels);
test_k_2 = [[1;2] num_zeros, num_ones, cluster_labels, miss]
sum_miss = sum(miss)
miss_rate = sum_miss/N*100

K = 5;
[~, N] = size(train_data_01)
[cluster_assignement,centroid] = K_means_clustering(train_data_01, K);
[num_ones, num_zeros, miss, cluster_labels] = K_means_classifier(cluster_assignement, train_labels_01, centroid, K);
train_k_5 = [[1;2;3;4;5], num_zeros, num_ones , cluster_labels, miss]
sum_miss = sum(miss)
miss_rate = sum_miss/N*100

[~, N] = size(test_data_01)
[cluster_assignement,centroid] = K_means_clustering(test_data_01, K);
[num_ones, num_zeros, miss, cluster_labels] = K_means_classifier(cluster_assignement, test_labels_01, centroid, K, cluster_labels);
test_k_5 = [[1;2;3;4;5], num_zeros, num_ones , cluster_labels, miss]
sum_miss = sum(miss)
miss_rate = sum_miss/N*100


%% Compute for many Ks
miss_rates_train = zeros(1, 9);
miss_rates_test = zeros(1, 9);
for K = [2 : 10]
    [~, N] = size(train_data_01);
    [cluster_assignement,centroid] = K_means_clustering(train_data_01, K);
    [num_ones, num_zeros, miss, cluster_labels] = K_means_classifier(cluster_assignement, train_labels_01, centroid, K);
    sum_miss = sum(miss);
    miss_rates_train(K) = sum_miss/N*100;
    
    [~, N] = size(test_data_01);
    [cluster_assignement,centroid] = K_means_clustering(test_data_01, K);
    [num_ones, num_zeros, miss, cluster_labels] = K_means_classifier(cluster_assignement, test_labels_01, centroid, K, cluster_labels);
    sum_miss = sum(miss);
    miss_rates_test(K) = sum_miss/N*100;
    K
end

%% viz
figure()
subplot(1,2,1)
plot([2:11],miss_rates_train, 'b', 'Marker', '.','MarkerSize',10)
xlabel('K')
ylabel('Misclassification Rate [%]')
legend('Train')
grid()
title('Train Missclassification Rate')
subplot(1,2,2)
plot([2:11],miss_rates_test, 'r', 'Marker', '.','MarkerSize',10)
xlabel('K')
ylabel('Misclassification Rate [%]')
legend('Test')

title('Test Missclassification Rate')
grid()
saveas(gcf,'outputs/e5.png')



    

