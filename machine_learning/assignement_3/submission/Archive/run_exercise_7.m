%
clear all
clc
%cifar10_starter()

%%
cifar10_modified()

%% 
load("models/cifar10_modified.mat")

%% Plot kernels
conv_layer = net.layers{2}.params.weights;
conv_layer = rescale(conv_layer);
dims = size(conv_layer);
figure
for i = 1:dims(end)
    subplot(dims(end)/4, dims(end)/4 , i)
    imshow(conv_layer(:,:,:,i))
    title(['Kernel ', num2str(i)])
end
saveas(gcf,'outputs/e7.png')



%% Make predictions on test set
[x_train, z_train, x_test, z_test, classes] = load_cifar10(2);
perm = randperm(numel(z_train));
x_train = x_train(:,:,:,perm);
z_train = z_train(perm);


pred = zeros(numel(z_test),1);
batch = 16;
for i=1:batch:size(z_test)
    idx = i:min(i+batch-1, numel(z_test));
    % note that z_test is only used for the loss and not the prediction
    z = evaluate(net, x_test(:,:,:,idx), z_test(idx));
    [~, p] = max(z{end-1}, [], 1);
    pred(idx) = p;
end

%% Get and plot misses
missed_indices = find(pred ~= z_test);
missed_labels = pred(missed_indices);
figure
for i=1:16
    missed_index = missed_indices(i);
    subplot(4,4,i)
    imagesc(x_test(:,:,:,missed_index)/255)
    axis off;
    title(['Ground truth: ', classes(z_test(missed_index)),' Prediction: ', classes(missed_labels(i))]);
    set(gca,'FontSize',7)
end
saveas(gcf,'outputs/e7b.png')


%% Get and plot confusion matrix, precision and recall
temp_1 = {};
temp_2 = {};
for i = 1:length(pred)
    temp_1{i} = classes{z_test(i)};
    temp_2{i} = classes{pred(i)};
end

cnf = confusionmat(temp_1, temp_2);
confusionchart(temp_1,temp_2)
saveas(gcf,'outputs/e7c.png')


precisions = [classes' precision(cnf)]
recalls = [classes' recall(cnf)]
p = precision(cnf)
r = recall(cnf)

function y = precision(M)
  y = diag(M) ./ sum(M,2);
end

function y = recall(M)
  y = diag(M) ./ sum(M,1)';
end

