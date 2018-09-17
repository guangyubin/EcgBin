%��RPOS�õ���������
% �������߰���ÿ5sһ����ֵ������15s�ڵ�beats���������� 
function hr = rpos2hr(rpos,fs,dsec,dur)
% rpos = beatinfo.pos;
% fs = 250;

dsec = dsec*fs;
dur = dur*fs;
nTime= floor(rpos(end)/(dsec));
istart = 1;
iend = 1;
hr = zeros(1,nTime);
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
        x = rpos(istart:iend);
        rr = diff(x);
        rr = rr((rr > 0.3*fs & rr < 4*fs));
        rr = mean(rr);
        try
        hr(ii) = 60*fs/rr;
        catch
            disp(rr)
        end
    else  % ���15s��û��5��beat���򱣳�ԭ�������ʣ�������Ϊ0
        if ii > 1
            hr(ii) = hr(ii-1);
        else
            hr(ii) = 0;
        end
    end
    
end


% figure;plot_ecg_beat_type(ecg1,beatinfo.pos,beatinfo.anntype,beatinfo.pos(90),beatinfo.pos(118));

