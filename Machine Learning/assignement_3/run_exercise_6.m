%% Exercise 6
mnist_starter();

%% Plot kernels
load('models/network_trained_with_momentum.mat')
images_train = loadMNISTImages('data/mnist/train-images.idx3-ubyte');
images = loadMNISTImages('data/mnist/t10k-images.idx3-ubyte');
labels = loadMNISTLabels('data/mnist/t10k-labels.idx1-ubyte');
labels_train = loadMNISTLabels('data/mnist/train-labels.idx1-ubyte');
conv_layer = net.layers{2}.params.weights;
dims = size(conv_layer);
figure
for i = 1:dims(end)
    subplot(dims(end)/4, dims(end)/4 , i)
    imshow(conv_layer(:,:,:,i))
    title(['Kernel ', num2str(i)])
end
saveas(gcf,'outputs/e6.png')


%% Make predictions on test set

images = reshape(images, [28, 28, 1, 10000]);
labels(labels == 0) = 10;
pred = zeros(numel(labels), 1);
batch = 16;

for i=1:batch:size(labels)
    idx = i:min(i+batch-1, numel(labels));
    % note that images is only used for the loss and not the prediction
    y = evaluate(net, images(:,:,:,idx), labels(idx));
    [~, p] = max(y{end-1}, [], 1);
    pred(idx) = p;
end

%% Get and plot misses
missed_indices = find(pred ~= labels);
missed_labels = pred(missed_indices);
classes = [1:9 0];
figure
for i=1:16
    missed_index = missed_indices(i);
    subplot(4,4,i)
    imagesc(images(:,:,:,missed_index))
    colormap(gray);
    axis off;
    title(['Ground truth: ', num2str(classes(labels(missed_index))),' Prediction: ', num2str(classes(missed_labels(i)))]);
    set(gca,'FontSize',7)
end
saveas(gcf,'outputs/e6b.png')

%% Double check size of network
size(net.layers{2}.params.weights)
size(net.layers{5}.params.weights)
size(net.layers{8}.params.weights)



%% Get and plot confusion matrix, precision and recall
cnf = confusionmat(labels, pred);
confusionchart(cnf)
saveas(gcf,'outputs/e6c.png')
precisions = [classes' precision(cnf)]
recalls = [classes' recall(cnf)]


function y = precision(M)
  y = diag(M) ./ sum(M,2);
end

function y = recall(M)
  y = diag(M) ./ sum(M,1)';
end








