%%
function [Tonset,Toffset,Tpos] = twavefind(x,tstart,tend,fs)

% ii = findmark +0.16*fs;

% tend = min(0.42*fs, rr-0.2*fs);
ii = tstart+0.1*fs;
maxflue = 0;
maxflueI = ii;
while ii < tend-0.1*fs
    tmp = x(ii:ii+0.06*fs);
    if maxflue < max(tmp)-min(tmp);
        maxflue = max(tmp)-min(tmp);
        maxflueI = ii;
    end;
    ii = ii +1 ;
end
% 从最大波动处，往后寻找平坦的地方
ii = maxflueI+0.06*fs;
while ii < tend-0.08*fs &&  isocheck(x,ii,0.08*fs,0.05)==0
    ii = ii+1;
end;
Toffset = ii;
% 如果没有找到平坦的地方，放松条件继续找
if ii == tend
    ii = maxflueI+0.06*fs;
    while ii < tend &&  isocheck(x,ii,0.08*fs,0.1)==0
        ii = ii+1;
    end;
    Toffset = ii;
end

% 往前找平坦的地方，
ii = maxflueI-0.06*fs;
while ii > tstart &&  isocheck(x,ii,0.08*fs,0.05)==0
    ii = ii-1;
end;
Tonset = ii;
%放松条件继续找
if ii == tstart
    ii = maxflueI-0.06*fs;
    while ii > tstart &&  isocheck(x,ii,0.04*fs,0.05)==0
        ii = ii-1;
    end;
    Tonset = ii;
end


z = (x(Toffset)+x(Tonset))/2;
[a ,b ] = max(abs(x(Tonset:Toffset)-z));
Tpos = Tonset+b-1;

% figure;plot(x); hold on;plot([Tpos,Toffset],x([Tpos,Toffset]),'.r');