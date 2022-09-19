function y = maxpooling_forward(x)
    assert(mod(size(x,1), 2) == 0 && mod(size(x,2), 2) == 0, ...
        'For maxpooling, the first and second dimension must be divisible by two.');
    y = cat(5, x(1:2:end, 1:2:end,:,:), ...
        x(1:2:end, 2:2:end,:,:), ...
        x(2:2:end, 1:2:end,:,:), ...
        x(2:2:end, 2:2:end,:,:));
    y = max(y, [], 5);
end