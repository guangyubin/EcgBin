%Coefficient of Variance
function p = ceof_var(x)

 y = sort(x);
 
n = length(x);

y = y(floor(0.1*n+1):floor(0.9*n-1));

p = std(y)/mean(y);