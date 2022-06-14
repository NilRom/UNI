function [y,C] = K_means_clustering(X,K)

% Calculating cluster centroids and cluster assignments for:
% Input:    X   DxN matrix of input data
%           K   Number of clusters
%
% Output:   y   Nx1 vector of cluster assignments
%           C   DxK matrix of cluster centroids

[D,N] = size(X);

intermax = 50;
conv_tol = 1e-6;
% Initialize
C = repmat(mean(X,2),1,K) + repmat(std(X,[],2),1,K).*randn(D,K);
y = zeros(N,1);
Cold = C;

for kiter = 1:intermax
    % CHANGE
    % Step 1: Assign to clusters
    for j = 1:N
        y(j) = step_assign_cluster(X(:,j), C, K);
    end
    
    % Step 2: Assign new clusters
    [C_new, travel_distance] = step_compute_mean(X, y, C, K);
    if travel_distance < conv_tol
        return
    end
    Cold = C_new;
    C = C_new;
    % DO NOT CHANGE
end

end

function d = fxdist(x,C)
    % CHANGE
    d = norm((x-C));
    % DO NOT CHANGE
end

function d = fcdist(C1,C2)
    % CHANGE
    d = norm((C1-C2));
    % DO NOT CHANGE
end

function y = step_assign_cluster(X, C, K)
    dists = zeros(1,K);
    for i = [1:K]
        dists(i) = fxdist(X, C(:,i));
    end 
    y = find(dists == min(dists));
end

function [C_new, travel_distance] = step_compute_mean(X, y, C, K)
    C_new = zeros(size(C));
    travel_distance = zeros(K);
    for i = [1:K]
        C_new(:,i) = mean(X(:,y==i), 2);
        travel_distance(i) = fcdist(C_new(:,i), C(:,i));
    end
end

