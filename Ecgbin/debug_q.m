
   
   %%
%    qrs = matmgc('beat_detector',ECG.ecg1,fs);
%  figure;plot(qrs.qrs(8,:));
 figure;subplot(311);plot(ECG.AnnBeat.qrs(:,8));
   
   subplot(312);plot(ECG.AnnBeat.qrs(:,9),'.');
   subplot(313);plot(ECG.AnnBeat.qrs(:,10),'.');