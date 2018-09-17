function p2 = ecg_qrs_stats(ecg,rloc,fs)
% [Q_on ,S_off] =  ecg_QT_detect(ecg,fs,rloc);
% 
% for ii = 1 :length(Q_on)
%     ramp(ii) = max(ecg(Q_on(ii):S_off(ii)));
%     qrs_width(ii) = S_off(ii) - Q_on(ii);
% end;

ramp = [];
m = 1;
qrs = [] ;
for kk = 1 : length(rloc)
    n0 = floor(rloc(kk)-0.05*fs);
    n1 = floor(rloc(kk)+0.05*fs);
    n2 = floor(rloc(kk)-0.08*fs);
    n3 = floor(rloc(kk)+0.08*fs);
    if n2>=1&& n3 < length(ecg)
        ramp(m) =  max(ecg(n0:n1)) - min(ecg(n0:n1));
        qrs(m,:) = ecg(n2:n3) - ecg(rloc(kk));
        m = m+1;
    end
end
% caculation ceorrcoef
m = 1;
nqrs = size(qrs,1);
mcount= zeros(1,nqrs);
mr = mcount;
mcount_low = mr;
p2 = zeros(1,3);
r = corrcoef(qrs');
for ii=1:size(r,1)
    tmp = r(ii,:);
    tmp(ii) = [];
    mr(ii) = mean(tmp);
    mcount(ii) = length(find(tmp>0.9));
    mcount_low(ii) = length(find(tmp<0.6));
end

index = find(mcount_low > nqrs*0.9);
mr(index) = [];
ramp(index) = [];
rloc(index) = [];
% 如果有50%的QRS相似度大于0.9 则认为为正常信号
if length(mr) > 2
    p2(1,1) = mean(mr);
    p2(1,2) = ceof_var(((ramp)));
    p2(1,3) = max(mcount)/nqrs;
else
    p2 = ones(1,3);
end