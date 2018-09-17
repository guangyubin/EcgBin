%% 
function wavepos = ptdetector_bin(x,fs,findmark,rr,fig)


IIf = smooth(x,fs/50)';
T=1/fs;        % [s] - sampling period
Fc=0.64;               % [Hz]
C1=1/[1+tan(Fc*pi*T)];  C2=[1-tan(Fc*pi*T)]/[1+tan(Fc*pi*T)];
b=[C1 -C1]; a=[1 -C2];
IIf=IIf-IIf(1);
ECG = filtfilt(b,a,IIf);
x = ECG;

ISO_LENGTH1 = floor(0.05*fs);
ISO_LENGTH2 = floor(0.08*fs);

rr = rr*fs/1000;

[QRSmax, ma]=max(abs(x(findmark-floor(0.06*fs):findmark+0.1*fs)));
ma=ma+findmark-floor(0.06*fs)-1;
QRSmax=sign(x(ma))*QRSmax;
% Ampitude of the QRS
LAT1 = floor(0.06*fs);
QRSampl=max(x(ma-LAT1:ma+LAT1))-min(x(ma-LAT1:ma+LAT1));


PAMP_LIMIT = 0.1;
% findmark = 0.4*fs;
[isoStart,isoEnd] = find_iso_position(x,ma,fs,QRSampl*0.1);
[onset, offset] = find_slope_position(x,ma, fs);
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

tend = min(length(x),findmark+rr-0.2*fs);

[Tonset, Toffset,Tpos] = twavefind(x,offset,tend,fs);
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
wavepos = [Ponset;Ppos;Poffset;...
    onset;Rpos ;offset ;...
    Tonset; Tpos ;Toffset];

