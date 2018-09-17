
% function [err1,err2,err3,err4,err5] = muse_getmdwave(fname)
clc
clear
load('D:\MGCDB\MuseDB_500Hz.mat');

for 
for sub = 385
    try
        sub
        fname = fullfile('D:\DataBase\MUSE',list(sub).name);
        [wave,rpos,QRStype,wave_median,fs,label,Meas,Meas_Orig,diag,diag_orig,Meas_Matrix,adu,PatientID]=musexmlread(fname);
        
        rpos = floor(rpos*Meas.ECGSampleBase/(2*fs));
        tleft = 0.5;
        tright = 0.7;
        rpos0 = rpos( (QRStype==0 ));
        for chan = 1:8
            x0 = wave(rpos0(2) - tleft*fs+3: rpos0(2)+tright*fs-1+3,chan);
            wave_segment = [];
            m = 1;
            lag = -5:1:5;
            for ii = 1:length(rpos0)
                if  rpos0(ii)+tright*fs +10< size(wave,1) && rpos0(ii) - tleft*fs+1-5 > 1
                    for kk = 1:length(lag)
                        x = wave(rpos0(ii) - tleft*fs+3+lag(kk): rpos0(ii)+tright*fs+lag(kk)-1+3,chan);
                        R(kk) = corrcoef(x0,x);
                    end;
                    [a, idx] = max(R);
                    tmp = wave(rpos0(ii) - tleft*fs+lag(idx)+3: rpos0(ii)+tright*fs+lag(idx)-1+3,chan);%
                    wave_segment(:,m) = tmp;
                    m = m +1;
                end;
            end
            x0 = wave_median(:,chan);
            istart = 1;  iend = length(x0);
            while x0(istart) ==0 && istart < length(x0)-1
                istart = istart+1;
            end;
            
            while x0(iend) ==0 && iend > 1
                iend = iend-1;
            end;
            x1 = median(wave_segment,2);
            x2 = wavelete_median(wave_segment);
            x3 = mean(wave_segment,2);
            x0 = x0(istart:iend) - mean(x0(istart:iend));
            x1 = x1(istart:iend) - mean(x1(istart:iend));
            x2 = x2(istart:iend) - mean(x2(istart:iend));
            x3 = x3(istart:iend) - mean(x3(istart:iend));
            
            err1(sub,chan) = sum(abs(x1 - x0))/length(x0);
            err2(sub,chan) = sum(abs(x2-x0))/length(x0);
            err3(sub,chan) = sum(abs(x3-x0))/length(x0);
            figure;
            plot(x0 - mean(x0));hold on;
            plot(x1-mean(x1));
            plot(x2-mean(x2));
            hold on;plot(x3-mean(x3));
            legend('ref','median' , 'wavelete median','mean');
        end;
    catch
    end
end
%%
mean(mean(err1))
mean(mean(err2))
mean(mean(err3))
% figure;
% plot(x0 - mean(x0));hold on;
% plot(x1-mean(x1));
% plot(x2-mean(x2));
% hold on;plot(x3-mean(x3));
% legend('ref','median' , 'wavelete median','mean');

