function Y = fully_connected_forward(X, W, b)
    % Inputs
    %   X - The input variable. The size might vary, but the last dimension
    %       tells you which element in the batch it is.
    %   W  - The weight matrix
    %   b  - The bias vector
    %
    % Outputs
    %   Y - The result as defined in the assignment instructions.
    
    % We take all dimension except the last one and vectorize them all so
    % that x has size [features x batchsize]
    sz = size(X);
    batch = sz(end);
    features = prod(sz(1:end-1));

    % Suitable for matrix multiplication
    X = reshape(X, [features, batch]);
    %size(X)
    Y = W*X + b;
    assert(size(W, 2) == features, ...
        sprintf('Expected %d columns in the weights matrix, got %d', features, size(W,2)));
    assert(size(W, 1) == numel(b), 'Expected as many rows in W as elements in b');
    
    %error('Implement this!');
end
