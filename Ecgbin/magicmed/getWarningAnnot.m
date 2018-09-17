% function getWarningAnnot(fname)
%%
clc
path = 'D:\MGCDB\mitdb250';
record = '100';
heasig = readheader(fullfile(path, [record, '.hea']));
beat = loadAnn_mgc(fullfile(path, [record, '.qrs']));
fs = 250;
meaSec = heasig.nsamp/fs; 
ileft = 1; iright = 1;
x = [];
rPVC =  length(find(beat.anntyp == 'V'))/length(beat.anntyp);
rAF =  length(find(beat.qrs(:,2)> 20))/length(beat.anntyp);
nPVC = [];
for ii = 1:meaSec
    [ileft,iright] = getAnnIdx(beat.time,ii*fs,30*fs,ileft,iright);
    nPVC(ii) = length(find(beat.anntyp(ileft:iright) == 'V'));   
     x (:,ii) = [beat.time(ileft)/fs beat.time(iright)/fs];
end;

figure;plot(nPVC);
% 
% figure;plot(diff(AnnBeat.pos));
% 
% 
%  AnnBeat =  loadAnn_mgc('D:\Database_MIT\mitdb\232.atr','mit');
%  annbeat = matmgc('read_mit_annot','D:\Database_MIT\mitdb\232.atr');
%  clear matmgc;
%  %%
%  matmgc('file_analysis','D:\MGCDB\mitdb\116','D:\MGCDB\mitdb\116.qrs','mgc');
%  AnnBeat1 = loadAnn_mgc('D:\Database_MIT\mitdb\116.atr', 'mit');
%  AnnBeat2 = loadAnn_mgc('D:\MGCDB\MITDB\116.qrs', 'mgc');
%  %%
% 
% 
