
function [err1,err2,err3,err4,err5] = muse_getmdwave(fname)

[wave,rpos,QRStype,wave_median,fs,label,Meas,Meas_Orig,diag,diag_orig,Meas_Matrix,adu,PatientID]=musexmlread(fname);
rpos = floor(rpos*Meas.ECGSampleBase/(2*fs));

% figure;subplot(211);plot_ecg_beat_type(wave(:,2),rpos,QRStype);
% subplot(212);plot(wave_median);
tleft = 0.5;
tright = 0.7;
chan  = 5;
rpos0 = rpos( (QRStype==0 ));

for chan = 1:8
    x0 = wave(rpos0(2) - tleft*fs+3: rpos0(2)+tright*fs-1+3,chan);
    wave_md2 = [];
    wave_md2_lp = [];
    wave_md2_hp = [];
    m = 1;
    lag = -5:1:5;
    for ii = 1:length(rpos0)
        if  rpos0(ii)+tright*fs +10< size(wave,1) && rpos0(ii) - tleft*fs+1-5 > 1
            for kk = 1:length(lag)
                x = wave(rpos0(ii) - tleft*fs+3+lag(kk): rpos0(ii)+tright*fs+lag(kk)-1+3,chan);
                R(kk) = corrcoef(x0,x);
            end;
            [a, idx] = max(R);
            tmp = wave(rpos0(ii) - tleft*fs+lag(idx)+3: rpos0(ii)+tright*fs+lag(idx)-1+3,chan);;
            y = ecg_baseline(tmp',0.5/500)';
            wave_md2(:,m) = tmp;
            wave_md2_lp(:,m)  =y ;
            wave_md2_hp(:,m)  = tmp - y;
            m = m +1;
        end;
        
    end
    %%
    
    LP = cat(2,median(wave_md2_lp(:,1:3:end),2),median(wave_md2_lp(:,2:3:end),2),mean(wave_md2_lp(:,3:3:end),2));
    HP = cat(2,mean(wave_md2_hp(:,1:3:end),2),mean(wave_md2_hp(:,2:3:end),2),mean(wave_md2_hp(:,3:3:end),2));
    
    x1 = median(LP,2) + median(HP,2);x1 = x1 - mean(x1);
    x0= wave_median(:,chan); x0 = x0 - mean(x0);
    
    x2 =median(wave_md2_hp,2)+median(wave_md2_lp,2) ; x2 = x2 - mean(x2);
    
    x3 = median(wave_md2,2); x3 = x3 - mean(x3);
    x4 = mean(wave_md2,2); x4 = x4 - mean(x4);
    
    
    LP = cat(2,median(wave_md2_lp(:,1:3:end),2),median(wave_md2_lp(:,2:3:end),2),mean(wave_md2_lp(:,3:3:end),2));
    HP = cat(2,median(wave_md2_hp(:,1:3:end),2),median(wave_md2_hp(:,2:3:end),2),mean(wave_md2_hp(:,3:3:end),2));
    x5 = mean(LP,2) + mean(HP,2);x5 = x5 - mean(x5);
    err1(chan) = sum(abs(x1 - x0))/length(x0);
    err2(chan) = sum(abs(x2-x0))/length(x0);
    err3(chan) = sum(abs(x3-x0))/length(x0);
    err4(chan) = sum(abs(x4-x0))/length(x0);
    err5(chan) = sum(abs(x5-x0))/length(x0);
    %   disp([err1 ;err2 ;err3; err4] );
end;
% figure;plot(x0);hold on;plot(x1);
