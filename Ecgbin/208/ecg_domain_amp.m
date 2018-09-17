function idx_dom = ecg_domain_amp(ramp)

if size(ramp,1)==1
    ramp = ramp';
end;
% index = find(ramp - mean(ramp) < 3*std(ramp));
[N,edges] = histcounts(ramp,3);
[a ,b ] = max(N);
idx_dom = (ramp > edges(b) & ramp < edges(b+1));
% idx_dom = index;



