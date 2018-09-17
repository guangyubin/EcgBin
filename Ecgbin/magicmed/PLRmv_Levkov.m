
%%
function y = PLRmv_Levkov(x)
N = 5;
d = zeros(1,length(x));
y = x;
buf = zeros(1,5);
for ii = N+1: length(x)-N
    d(ii) = max(x(ii:ii+N) - x(ii-N:ii)) - min(x(ii:ii+N) - x(ii-N:ii)) ;
    
    if d(ii) < 0.16
        y(ii) = mean(x(ii-2:ii+2));
        buf(mod(ii,5)+1) = x(ii) - y(ii);
    else
        y(ii) = x(ii) - buf(mod(ii,5)+1);
    end
end;
