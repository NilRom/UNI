clear all
clc
load("A2_data.mat")

%training
svm = fitcsvm(train_data_01', train_labels_01);
labels_pred = predict(svm, train_data_01');
cfm_train = confusionmat(train_labels_01,labels_pred)
n_train = sum(cfm_train, 'all')
miss = cfm_train(2,1) + cfm_train(1,2)
miss_rate = miss/n_train * 100

%Test
labels_pred = predict(svm, test_data_01');
cfm_test = confusionmat(test_labels_01,labels_pred)
n_test = sum(cfm_test, 'all')
miss = cfm_test(2,1) + cfm_test(1,2)
miss_rate = miss/n_test * 100


%% RBF

for beta = linspace(4,7, 5*2)
    svm = fitcsvm(train_data_01', train_labels_01,'KernelFunction','gaussian', 'KernelScale', beta);
    labels_pred = predict(svm, train_data_01');
    cfm_train = confusionmat(train_labels_01,labels_pred);
    n_train = sum(cfm_train, 'all');
    miss = cfm_train(2,1) + cfm_train(1,2);
    miss_rate = miss/n_train * 100;
    
    %Test
    labels_pred = predict(svm, test_data_01');
    cfm_test = confusionmat(test_labels_01,labels_pred);
    n_test = sum(cfm_test, 'all');
    miss = cfm_test(2,1) + cfm_test(1,2);
    miss_rate = miss/n_test * 100
    beta
    if miss_rate == 0
        best_beta = beta
        cfm_test
        cfm_train
        miss_rate
        break
    end
end
