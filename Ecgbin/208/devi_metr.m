function y = devi_metr(x)

n = length(x);

sx = sort(x);
dn = floor(n*0.2);
sx = sx(dn+1:n-dn);

y = abs(x - mean(sx))/std(sx);