function [] = viz_pca(pi, labels)
    gscatter(pi(1,:), pi(2,:), labels, 'rbgym','xo*.s')
    title('Linear 2 Dimensional PCA')
    xlabel('Principal Component 1')
    ylabel('Principal Component 2')
end