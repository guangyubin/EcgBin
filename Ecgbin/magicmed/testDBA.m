%%
record = 'D:\MGCDB\MITDB250\105';
[heasig, sig] = loadmgcdata(record);
qrs = loadmgcqrs(record);
fs = 250;


%%
ileft = fs*0.4;
iright = fs*0.6;
x1 = sig(qrs.time(2)-ileft : qrs.time(2)+iright);
x1 = x1 - mean(x1);
m = 1;
segdata = [];
for ii = 2:length(qrs.time)
    x2 = sig(qrs.time(ii)-ileft : qrs.time(ii)+iright);
    segdata(m,:) = x2;
    m = m +1;
end;
%%
average = DBA(segdata(10:100,:));
figure;plot(average);
hold on;;plot(x2);
% figure;
% subplot(211);plot(dist);
% subplot(212);plot(x1);hold on;plot(segdata(258,:));
