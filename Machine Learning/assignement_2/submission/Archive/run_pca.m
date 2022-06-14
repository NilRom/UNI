function [pi, W] = run_pca(data, num_pcas)
    data = data - mean(data,2);
    [U,S,V] = svd(data);
    W = U(:,1:num_pcas);
    pi = W'*data;
end

