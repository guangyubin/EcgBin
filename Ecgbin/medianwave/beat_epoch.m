% 提取R波后，利用R波位置进行分段
% 需要利用相关系数进行对齐
% output: (nchan, 600, m) 每导联对其后的m个心拍
% Author: guangyubin@bjut.edu.cn
%         2017/11/14

function segdata = beat_epoch(wave,rpos,QRStype,type,tleft,tright,fs)

nchan = size(wave,2);
% tleft = 0.5;
% tright = 0.7;
rpos0 = rpos( (QRStype==type ));

for chan = 1:nchan
    x0 = wave(rpos0(2) - tleft*fs+3: rpos0(2)+tright*fs-1+3,chan);
    wave_segment = [];
    m = 1;
    lag = -5:1:5;
    for ii = 1:length(rpos0)
        if  rpos0(ii)+tright*fs +10< size(wave,1) && rpos0(ii) - tleft*fs+1-5 > 1
            for kk = 1:length(lag)
                x = wave(rpos0(ii) - tleft*fs+3+lag(kk): rpos0(ii)+tright*fs+lag(kk)-1+3,chan);
                RR = corrcoef(x0,x);
                R(kk) = RR(1,2);
            end;
            [a, idx] = max(R);
            tmp = wave(rpos0(ii) - tleft*fs+lag(idx)+3: rpos0(ii)+tright*fs+lag(idx)-1+3,chan);%
            wave_segment(:,m) = tmp;
            m = m +1;
        end;
    end
    segdata(chan,:,:) = wave_segment;
    
end