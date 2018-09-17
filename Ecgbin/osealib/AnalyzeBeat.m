%% 1862
function [tpr, tqrs,tqt , pamp,tamp,st,ramp] = AnalyzeBeat(x,fs,fig)
ISO_LENGTH1 = floor(0.05*fs);
ISO_LENGTH2 = floor(0.08*fs);
%   x = avg_ecg(113,:);

PAMP_LIMIT = 0.1;
findmark = 0.4*fs;
[isoStart,isoEnd] = find_iso_position(x,findmark,fs);
[onset, offset] = find_slope_position(x,findmark, fs);
onset1 = onset;
offset1 = offset;
isoStart1 = isoStart;
isoEnd1 = isoEnd;

if fig==1
    plot(x);hold on;plot([onset1 offset1],x([onset1 offset1]),'.r');
    plot([isoStart isoEnd],x([isoStart isoEnd]),'o');
end

if isoStart== ISO_LENGTH1 &&  onset > isoStart
    isoStart = onset;
else if onset - isoStart < 0.05*fs && onset > isoStart
        onset = isoStart;
    end
end
if isoEnd - offset <= 0.05*fs && isoEnd > offset
    offset = isoEnd;
end;
maxV = max(x(onset:offset));
minV = min(x(onset:offset));
if x(onset) - x(offset) > (maxV-minV)*2/8
    ii = offset;maxSlopeI = offset;maxSlope = x(offset) - x(offset-1);
    while ii < offset+0.1*fs && ii < length(x)
        slope = x(ii) - x(ii-1);
        if slope > maxSlope
            maxSlope = slope;
            maxSlopeI = ii;
        end
        ii = ii +1;
    end;
    if maxSlope > 0
        ii = maxSlopeI;
        while ii < length(x)&& x(ii) - x(ii-1) > maxSlope/2
            ii = ii+1;
        end
        offset = ii;
    end
end
PAMP_LIMIT = 0.08;%min((maxV-minV)/16,0.08);;
ii = findmark - floor(0.25*fs);
% 从0.25s往前开始寻找第一个平坦的地方
while ii > floor(0.08*fs) && isocheck(x,ii-floor(0.08*fs)+1,floor(0.08*fs),PAMP_LIMIT)==0;
    ii = ii-1;
end
beatBegin = ii;
% 如果0.25s是一个平坦的地方
if beatBegin == findmark - 0.25*fs
    % 往后开始寻找第一个不平坦的地方，为P波起点
    while ii <onset - floor(0.1*fs) && isocheck(x,ii-floor(0.08*fs)+1,floor(0.08*fs),PAMP_LIMIT)==1
        ii = ii+1;
    end
    beatBegin = ii ;
    % 如果没有找到平坦的地方
else if beatBegin == 0.08*fs
        %放松平坦条件
        while ii < onset - 0.05*fs && isocheck(x,ii-floor(0.08*fs)+1,floor(0.08*fs),PAMP_LIMIT)==0
            ii = ii+1;
        end
        %然后寻找第一个不平坦的地方做为P波起点
        if ii < onset
            while ii < onset- 0.1*fs && isocheck(x,ii- floor(0.05*fs)+1,floor(0.05*fs),PAMP_LIMIT)==1
                ii = ii+1;
            end
            if ii < onset
                beatBegin = ii;
            end;
        end
    end
end

ii = findmark+0.3*fs;
% 寻找第一个平坦的地方
while ii < length(x) && isocheck(x,ii-floor(0.08*fs),floor(0.08*fs),0.1)==0
    ii = ii+1;
end;

[Tonset, Toffset,Tpos] = twavefind(x,findmark,fs);
% [Ponset,Poffset,Ppos,pamp] = pwavefind_v2(x,onset,fs,0);
[Ponset,Poffset,Ppos] = pwavefind(x,onset,fs);

pamp = x(Ppos) - (x(Ponset) + x(Poffset))/2;
tamp = x(Tpos) - (x(Toffset)+x(Tonset))/2;
[ramp ,Rpos]= max(x(onset:offset)) ;
ramp = ramp- x(onset);
Rpos = Rpos+onset-1;
% pamp =  pamp/ramp;
% Ponset = max(Ppos-0.05*fs,1);
% Poffset = Ppos+0.05*fs;


qrsamp = max(x(onset:offset)) - min(x(onset:offset));

if abs(pamp) < 0.02
    tpr = 0.1*fs;
else
    tpr = onset - Ppos;
end
tpr = tpr*1000/fs;
tqrs = (offset - onset)*1000/fs;
tqt = (Tpos - onset)*1000/fs;
%  pamp = max(x(beatBegin -0.05*fs : beatBegin +0.05*fs )) - min(x(beatBegin -0.05*fs : beatBegin +0.05*fs ));
%  tamp = max(x(offset  : beatEnd )) - min(x(offset  : beatEnd ));

tamp = tamp/qrsamp;
a = median(x(onset-floor(0.05*fs):onset));
b = median(x(offset:offset+floor(0.05*fs)));
st = abs(a-b);

poslist1 = [Ponset,Poffset,Ppos];
poslist2 = [ Tonset Tpos  Toffset];
poslist3= [onset offset Rpos ];
%   poslist2 = [onset1 offset1];
if fig==1
    plot(poslist1,x(poslist1),'.r');
    hold on;plot(poslist2,x(poslist2),'.k');
    plot(poslist3,x(poslist3),'*m');
    hold off; title(num2str([pamp st tpr tqrs tqt ]));
end


