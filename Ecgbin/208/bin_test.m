clc
clear
path_mitdb = 'D:\Database_MIT\mitdb\';
heasig = readheader('D:\Database_MIT\mitdb\106.hea');
 ecg=rdsign212('D:\Database_MIT\mitdb\106.dat',2,1,heasig.nsamp);
 annot = readannot('D:\Database_MIT\mitdb\106.atr');
 annot=isqrs(annot,heasig,[1 heasig.nsamp]); 
 Fs = heasig.freq;
rpos= annot.time; 

ecg = (ecg - heasig.adczero(1))/heasig.gain(1);
%%
npeak = 10;
x = ecg(rpos(npeak)-0.3*Fs:rpos(npeak)+1.5*Fs,1);

p = 0.3*Fs+2;

[POS,AMP,VAL_QT,VAL_QTC,VAL_QRS,AMP_Q,AMP_R,AMP_S]= bin_PQRSTdetect1(x,p,Fs);
% text(pos,x(pos),str);
pos = [POS.Q POS.R POS.S POS.T];
figure;subplot(211);plot(Xpb);hold on;plot(pos,Xpb(pos),'.r');
subplot(212);plot(x);hold on;plot(pos,x(pos),'.r');




%%
x = ecg;
[Xpa,Xpb,D,F,Der]=bin_lynfilt(x,Fs);
rpos= rpeak_correction(x,rpos,Fs);
 [POS,AMP,ANNOT,POS_ANNOT,NUMFIELD,SUBTYPEFIELD,CHANFIELD,POS_QT,VAL_QT,VAL_QTC,AMP_Q,POS_Q,AMP_R,POS_R,AMP_S,POS_S,VAL_QRS,POS_QRS,prewindt]=...
    bin_proces(0,X,Xpa,Xpb,D,F,Der,1,length(x),1,length(rpos),rpos,atyp,ns,Fs,nl,res,prewindt,Kq,Kr,Ks,Krr,Kpb,Kpe,Ktb,Kte,pco)