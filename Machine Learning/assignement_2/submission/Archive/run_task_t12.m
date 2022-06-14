%T1
x = [-2 -1 1 2];
y = [1 -1 -1 1];
k = [x.^2 ; x];

K = zeros(4,4);
for i = [1 2 3 4]
    for j = [1]
        K(i,j) = [x(i) x(i).^2] * [x(j) x(j).^2]'
    end
end 


%T2
sum = 0
for i = [1 2 3 4]
    for j = [1 2 3 4]
        sum = sum + y(i)* y(j) * [x(i) x(i).^2] * [x(j) x(j).^2]';
    end
end
sum

%T3
        