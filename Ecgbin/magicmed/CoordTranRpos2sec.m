% coordinate transformation; from rpos to sec
% 一些数值是按照R波位置为坐标的， 我们把他转化为以时间为坐标。
% 例如RR间期，　AFEv等数值。
% Author: guangyubin@bjut.edumcn
%         2017/10/10
function val_c = CoordTranRpos2sec(rpos,value,fs,dsec,dur)
% rpos = beatinfo.pos;
% fs = 250;

dsec = dsec*fs;
dur = dur*fs;
nTime= floor(rpos(end)/(dsec));
istart = 1;
iend = 1;
val_c = zeros(1,nTime);
for ii = 1:nTime
    if ii*dsec*fs < dur
        while rpos(istart) < (ii-1)*dsec && istart < length(rpos)
            istart = istart +1;
        end
        while rpos(iend) < 2*dur+(ii-1)*dsec && iend < length(rpos)
            iend = iend +1;
        end
    else
        while rpos(istart) < ii*dsec-dur && istart < length(rpos)
            istart = istart +1;
        end
        while rpos(iend) < ii*dsec+dur && iend < length(rpos)
            iend = iend +1;
        end       
    end
%     disp([istart iend]);
    % 15s内必须有5个以上的心率数据
    if iend - istart >= 5
        x = value(istart:iend);       
        val_c(ii) = mean(x);
    else  % 如果15s内没有5个beat，则保持原来的心率，或者设为0 
       val_c(ii) = 0; 
    end
    
end


% figure;plot_ecg_beat_type(ecg1,beatinfo.pos,beatinfo.anntype,beatinfo.pos(90),beatinfo.pos(118));

