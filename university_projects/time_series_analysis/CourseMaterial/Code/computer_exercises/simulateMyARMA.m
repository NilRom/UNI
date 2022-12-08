function y = simulateMyARMA(a,c, N, extraN,sigma2)
%SIMULATEMYARMA Summary of this function goes here
%   Detailed explanation goes here


e = sqrt(sigma2) * randn( N+extraN, 1 );
y = filter(a, c, e );
y = y(extraN:end);
end

