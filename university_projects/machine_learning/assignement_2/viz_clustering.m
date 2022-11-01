function [] = viz_clustering(pi, labels, C, K, path)
    figure
    gscatter(pi(1,:), pi(2,:), labels, 'bkrcg','xo')

    for i=1:K
        C(:,i) = C(:,i)-mean(X,2); 
    end
    C_proj = U_new'*centroid;

    legend('Class 0','Class 1')
    title('Linear 2 Dimensional PCA')
    xlabel('Principal Component 1')
    ylabel('Principal Component 2')
    saveas(gcf,path)
end