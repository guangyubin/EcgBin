%%
[heasig,ecg]  = loadmgcdata('D:\MGCDB\ST\s20421');
fidf= fopen('D:\MGCDB\ST250\s20421.dat','wb');
fwrite(fid,ecg(:,1)*200,'short');
fclose(fid);
%%
fid = fopen('D:\MGCDB\ST250\s20421.hea','w');
fprintf(fid,'s20421 %d %d %d\n', 1,heasig.freq,heasig.nsamp);
fprintf(fid,'s20421.dat 16 200 16 0 0 0 0 II');
fclose(fid);

% fid = fopen('D:\MGCDB\ST250\s20421.dat','rb');
% d = fread(fid,'short');
% figure;plot(d);