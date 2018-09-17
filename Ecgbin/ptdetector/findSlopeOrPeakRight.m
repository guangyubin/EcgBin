% Description:
%     从flat段开始，往左或者往右，寻找波动较大的地方。
%     例如在Q Onset识别时， 先找PQ段Flat.然后往后调用findSlopeOrPeakRight， 寻找斜率较大或者拐点
% Input:
%   II ecg data in mV
%    s   差分的长度  x(n) - x(n-s)
%    Crit1 : 阈值 x(n) - x(n-s)
%    Crit2 : 阈值 x(n) - x(n-s)
%    Crit  The cirt of Flat
%    Qflat    start position
%    ma    end position
%    direction  方向
%    def_val 找不到的时候，给一个默认值
% Output:
%    Qs1:  找到的转折点位置
%Author： guangyubin@bjut.edu.cn
%           Version 1.0.0  2017/10/20

function Qsl = findSlopeOrPeakRight(II,fs,s,Qflat,ma,Crit1,Crit2,direction)

Qsl = 0 ;

def_val = floor(0.03*fs);

if strcmp(direction,'right')
    for ii=Qflat+s:ma-s;         % 100 ms
        D1=II(ii)-II(ii-s); D2=II(ii)-II(ii+s);
        if D1>Crit1 && D2>Crit1;
            Qsl=ii+s/2;
            break;
        elseif D1<-Crit1 && D2<-Crit1;
            Qsl=ii+s/2;
            break;
        elseif  II(ii)-II(ii+1)>Crit2 && II(ii+1)-II(ii+2)>Crit2 && II(ii+2)-II(ii+3)>Crit2 && II(ii+3)-II(ii+4)>Crit2
            Qsl=ii+s/2+3; break;
        elseif II(ii)-II(ii+1)<-Crit2 && II(ii+1)-II(ii+2)<-Crit2 && II(ii+2)-II(ii+3)<-Crit2 && II(ii+3)-II(ii+4)<-Crit2
            Qsl=ii+s/2+3; break;
        end
    end
    if Qsl==0;
        Qsl=Qflat+def_val;
        %     disp ('ERROR !');
    end
end
if strcmp(direction,'left')
    for ii=Qflat-s:-1:ma+s;         % 100 ms
        D1=II(ii)-II(ii-s); D2=II(ii)-II(ii+s);
        if D1>Crit1 && D2>Crit1;
            Qsl=ii-s/2;
            break;
        elseif D1<-Crit1 && D2<-Crit1;
            Qsl=ii-s/2;
            break;
        elseif  II(ii)-II(ii-1)>Crit2 && II(ii-1)-II(ii-2)>Crit2 && II(ii-2)-II(ii-3)>Crit2 && II(ii-3)-II(ii-4)>Crit2
            Qsl=ii-s/2-3; break;
        elseif II(ii)-II(ii-1)<-Crit2 && II(ii-1)-II(ii-2)<-Crit2 && II(ii-2)-II(ii-3)<-Crit2 && II(ii-3)-II(ii-4)<-Crit2
            Qsl=ii-s/2-3; break;
        end
    end
    if Qsl==0;
        Qsl=Qflat-def_val;
        %     disp ('ERROR !');
    end
end
Qsl = floor(Qsl);