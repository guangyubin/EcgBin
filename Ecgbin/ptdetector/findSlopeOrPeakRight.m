% Description:
%     ��flat�ο�ʼ������������ң�Ѱ�Ҳ����ϴ�ĵط���
%     ������Q Onsetʶ��ʱ�� ����PQ��Flat.Ȼ���������findSlopeOrPeakRight�� Ѱ��б�ʽϴ���߹յ�
% Input:
%   II ecg data in mV
%    s   ��ֵĳ���  x(n) - x(n-s)
%    Crit1 : ��ֵ x(n) - x(n-s)
%    Crit2 : ��ֵ x(n) - x(n-s)
%    Crit  The cirt of Flat
%    Qflat    start position
%    ma    end position
%    direction  ����
%    def_val �Ҳ�����ʱ�򣬸�һ��Ĭ��ֵ
% Output:
%    Qs1:  �ҵ���ת�۵�λ��
%Author�� guangyubin@bjut.edu.cn
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