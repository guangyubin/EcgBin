%%

fname = 'D:\dbmit\105';
[heasig,ecg1,AnnBeat,AnnWarning, AnnEventEnd,AnnComment] = loadmagicdata(fname);
%%
subplot(312);
plot_ecg_beat_type(ecg1,AnnBeat.pos,AnnBeat.subtype,AnnWarning.pos(1),AnnWarning.pos(1)+10000);
subplot(311);
plot_ecg_beat_type(ecg1,AnnEventEnd.pos,AnnEventEnd.subtype,AnnEventEnd.pos(1)-AnnEventEnd.duration(1),AnnEventEnd.pos(1)+100);

%%
fid = fopen('D:\DataBase\CareB_ART\raw001.dat','rb');
ecg = fread(fid,[1 inf],'short');
ecg = ecg/200;
fclose(fid);
% y = PLRmv_Levkov(ecg2);

plot(ecg1);
figure;
ecg2 = [  ecg];
subplot(311);
plot(ecg1(6:2500));hold on; plot(ecg2(1:2500)-mean(ecg2(1:2500))); legend('c','raw');
index = find(beatinfo.anntype==5);
plot_ecg_beat_type(ecg1,beatinfo.pos(index),beatinfo.anntype(index));
subplot(313);plot_ecg_beat_type(ecg1,beatinfo.pos,beatinfo.anntype,anninfo.pos(1)-7500,anninfo.pos(1)+5000);

%%

plot(ecg1((30815)*50:(30825)*50));hold on;plot(ecg2((30815)*50:(30825)*50));
%%
ecg_bl = ecg -  ecg_baseline(ecg,0.1/250);
figure;plot(ecg_bl);

alpha = 0.9962;
yn1 = 0;
for ii = 1 : length(ecg)
    xn = ecg(ii);    
    if abs(xn - yn1) > 5
        yn1 = xn;
    end;
    yn = (1-alpha)*xn + alpha*yn1;
    yn1 = yn;    
    bs(ii) = yn;
end;
ecg_bl2 = ecg-bs;
figure;
subplot(211);
plot(ecg_bl2(1:end)); 
subplot(212);
plot(ecg_bl(1:end));


%%

kkk =1;
m = 1;
ecg = ecg1;
y1 = ecg;
for ii = 1:50: length(ecg)-49    
    tmp = ecg(ii:ii+49); 
    b(m) =  powerfreqcheck(tmp) ;
    if max(tmp) - min(tmp) > 8 ||lineralCount(tmp)> 30 || powerfreqcheck(tmp) >1
        art(ii:ii+49) = 1 ;
        y1(ii:ii+49) = 0;
        zzz(kkk,:) = ecg(ii:ii+49);
        kkk = kkk+1;
    else
        art(ii:ii+49) = 0 ;
    end
    m = m+1;
end
subplot(311);plot(ecg); axis tight;
subplot(312);plot(y1); axis tight;
subplot(313);plot(art); axis tight;
% x = matmgc(y,250);
% toc
% plot_ecg_beat_type(y,x(1,:),x(2,:),1, 1600000);
% clear matmgc.mexw64

