function [ones, zzeros, miss, cluster_labels] = K_means_classifier(cluster_assignement, gt_labels, C, K, cluster_labels)
    ones = zeros(K,1);
    zzeros = zeros(K,1);
    miss = zeros(K,1);
    if nargin < 5 %If we are using training data we want to assign centroid/cluster labels, in testing we use the centroid labelling from training
        cluster_labels = get_cluster_labels(cluster_assignement, gt_labels, C);
    end
    
    for i = 1:K
        zzeros(i) =  sum(gt_labels(cluster_assignement==i)==0);
        ones(i) = sum(gt_labels(cluster_assignement==i)==1);
        if cluster_labels(i) == 1
            miss(i) = zzeros(i);
        else
            miss(i) = ones(i);
        end

    end

end


function cluster_labels = get_cluster_labels(cluster_assignement, gt_labels, C)
    [~, n_c] = size(C);
    cluster_labels = zeros(n_c,1);
    for i = 1:n_c
        num_zeros = sum(gt_labels(cluster_assignement==i)==0); 
        num_ones = sum(gt_labels(cluster_assignement==i)==1); 
        if num_zeros < num_ones
            cluster_labels(i) = 1;
        else
            cluster_labels(i) = 0;
        end
    end
end