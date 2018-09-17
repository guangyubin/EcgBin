% coordinate transformation; from rpos to sec
% һЩ��ֵ�ǰ���R��λ��Ϊ����ģ� ���ǰ���ת��Ϊ��ʱ��Ϊ���ꡣ
% ����RR���ڣ���AFEv����ֵ��
% Author: guangyubin@bjut.edumcn
%         2017/10/10
function [ileft,iright] = getAnnIdx(rpos,ii,dur,istart,iend)
% rpos = beatinfo.pos;
% fs = 250;

p0 = ii - dur;
p1 = ii;
if p0 < 0
    p0 = 1;
end;
ileft = istart;
iright = iend;
while rpos(ileft) < p0 && ileft < length(rpos)
    ileft = ileft +1;
end
while rpos(iright) < p1 && iright < length(rpos)
    iright = iright +1;
end
iright = iright - 1;
if iright < 1 
    iright = 1;
end;