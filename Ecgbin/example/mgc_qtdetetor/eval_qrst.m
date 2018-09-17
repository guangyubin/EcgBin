
% %%
close all
[a ,b] =sort(abs(tPos2(:,1) - tPos3(:,1)-4));
b = [a b];
ii = 438;
x = DATA(ii).wave(:,2);
rr = floor(60000/DATA(ii).Meas.VentricularRate);
x = floor((x -mean(x))*200);
fid = fopen(['D:\' num2str(ii) '.bin'],'wb+');
 fwrite(fid,x,'short');
fclose(fid);
% 
fid = fopen(['D:\' num2str(ii) '.bin'],'rb');
d = double(fread(fid,'short'));
fclose(fid);
% d = x;
% plot(d);
fs = 250;
findmark = 0.4*fs;
% rr = 800;
fig = 1;
% tic 
[wavepos, QRSampl,Tampl] = ptdetector_bin3((d),fs,findmark,rr);
pos1 = wavepos([1 3 4 6 9]);
% qr = matmgc('analyze_beat_v1',d)

[pos2 , amp] = matmgc('analyze_beat_v1',d ,rr);
clear matmgc;
% qr = [90 113 76 224];
% toc
%%
subplot(311);;plot(d);hold on;plot(pos1,d(pos1),'.r');
subplot(312);;plot(d);hold on;plot(pos2,d(pos2),'.r');
  refpos = DATA(ii).pos;
  disp(wavepos)
  disp(pos2)
  subplot(313);;plot(d);hold on;plot(refpos,d(refpos),'.r');
 clear matmgc