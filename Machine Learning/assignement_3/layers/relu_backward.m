function dldX = relu_backward(X, dldY)
    sympref('HeavisideAtOrigin', 0);
    dldX = dldY.*heaviside(X);
end
