% coordinate transformation; from rpos to sec
% һЩ��ֵ�ǰ���R��λ��Ϊ����ģ� ���ǰ���ת��Ϊ��ʱ��Ϊ���ꡣ
% ����RR���ڣ���AFEv����ֵ��
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
    % 15s�ڱ�����5�����ϵ���������
    if iend - istart >= 5
        x = value(istart:iend);       
        val_c(ii) = mean(x);
    else  % ���15s��û��5��beat���򱣳�ԭ�������ʣ�������Ϊ0 
       val_c(ii) = 0; 
    end
    
end


% figure;plot_ecg_beat_type(ecg1,beatinfo.pos,beatinfo.anntype,beatinfo.pos(90),beatinfo.pos(118));

