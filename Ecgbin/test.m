 %%
x = ECG.ecg1;
ponst = double(ECG.AnnBeat.time)+double(ECG.AnnBeat.qrs(:,4)); 
 qonst = double(ECG.AnnBeat.time)+double(ECG.AnnBeat.qrs(:,5)); 
 qoffset = double(ECG.AnnBeat.time)+double(ECG.AnnBeat.qrs(:,6));
 y = matmgc('do_baseline_remove', x*200, qonst);
 x1 = x-y/200;
 t = 11000:18000;
 
 figure;subplot(211);plot(x(t));subplot(212);plot(x1(t));
 
 figure;plot(ponst - qonst);
 