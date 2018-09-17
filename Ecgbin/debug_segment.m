%%
dur = 250*30;

m0 = 1;
m1 = 1;

mmm = 1;
y=[]; f = []; pos = [];
for ii = 1:10*250:length(ECG.ecg1)-dur
    s0 = ii;
    s1 = ii+dur-1;
    x = 200*ECG.ecg1(s0:s1) ;
    m0 = m1;
    while ECG.AnnBeat.time(m1) < s1
        m1 = m1+1;
    end    
    rpos = ECG.AnnBeat.time(m0:m1-1)-s0;    
    [y(mmm,:), f(mmm,:)  pos(mmm,:)] = matmgc('segment',x,rpos);
    mmm = mmm+1;
end;


%%
figure;subplot(211);plot(f);
subplot(212);plot(4*smooth(double(ECG.AnnBeat.qrs(:,7) - ECG.AnnBeat.qrs(:,5)),20));
%%

nn = 18;
figure;plot(y(nn,:)); hold on;plot(pos(nn,:),y(nn,pos(nn,:)),'.r'); title(num2str(pos(nn,9) - pos(nn,4)));
% figure;subplot(211);plot(x);subplot(212);plot(y); 
clear matmgc
% f