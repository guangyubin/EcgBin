function b = powerfreqcheck(x)
%%
fs = 250;
t = (0:49)/fs;
% x = cos(2*pi*t*50);
x = reshape(x,[5 10]);
x = mean(x,2);
b = max(x)-min(x);
