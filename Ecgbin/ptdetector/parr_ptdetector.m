function [wavepos8,QRSampl,Tampl] =  parr_ptdetector(wave,fs,rr)

wavepos8  = zeros(8,9);
QRSampl = zeros(1,8);
Tampl = zeros(1,8);
    for chan =1 :8
        [wavepos8(chan,:), QRSampl(chan),Tampl(chan)]= ptdetector_bin2(wave(:,chan),fs,0.4*fs,rr);
    end;