%%
[heasig,ecg1,AnnBeat,AnnWarning] = loadmagicdata('D:\MGCDB\mitafdb\04043');
%%
[heasig,ecg1,AnnBeat,AnnWarning] = loadmagicdata('D:\MGCDB\mitdb\105');
[heasig,ecg1,AnnBeat,AnnWarning] = loadmagicdata('D:\MGCDB\mitafdb\04043');


rpos = AnnBeat.pos;
fs = 250;
AFEv1 = double(AnnBeat.qrs(:,2));

hr = rpos2hr(rpos,fs,10,15);
t = (1:1:length(ecg1))/fs;
figure;subplot(311);plot_ecg_beat_type(ecg1,double(AnnBeat.pos)+1,AnnBeat.subtype,1,10000);
subplot(312);plot(hr);
AFE_sec = CoordTranRpos2sec(rpos,AFEv1,fs,10,15);
subplot(313);plot((0:length(AFE_sec)-1)*10,AFE_sec);  
%% AFE debug for c++

fid = fopen('D:\1.dat','rb');
a = fread(fid,'short');
hr2 = a(1:length(a)/2);
AFE_sec_2 = a(length(a)/2+1:end);
fclose(fid);
figure;subplot(211);plot(floor(hr));hold on;plot(hr2);
subplot(212);plot((0:length(AFE_sec)-1)*10,AFE_sec);  hold on;plot(rpos/fs,af_label*50);
plot((0:length(AFE_sec_2)-1)*10,AFE_sec_2);