
function smrr = ecg_rr_smooth(rr,n)
smrr = zeros(1,length(rr));
len  = length(rr);

if len < n
    smrr(1:len) = mean(rr);
else
    
    dn = floor(n / 2);    
    smrr(1:dn) = mean(rr(1:n));
    smrr(len-dn:len) = mean(rr(len-n+1:len));    
    for ii = dn+1 : len - dn
        smrr(ii) = mean(rr(ii-dn:ii+dn));
    end;
end
