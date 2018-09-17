
function [tpr, tqrs, tqrs2 , tqt , pamp,qamp,samp,tamp,st,qrmrp,tso,ramp] = ecg_avg_feat(avg_ecg,fs,fig)

if nargin <3
    fig = 0 ;
end;

[POS,AMP,VAL_QT,VAL_QTC,VAL_QRS,AMP_Q,AMP_R,AMP_S]= bin_PQRSTdetect1(avg_ecg',0.4*fs,fs,fig);

tpr = 1000*(POS.QRSonset - POS.Ponset)/fs;
tqrs = VAL_QRS;
tqt = VAL_QT;
pamp = AMP.P;
ramp = AMP.R;
qamp = AMP.Q;
samp = AMP.S;
tamp = AMP.T;

pamp(isnan(pamp)) = 0 ;
qamp(isnan(qamp)) = 0 ;
samp(isnan(samp)) = 0 ;
tamp(isnan(tamp)) = 0 ;
if isempty(tpr)||isnan(tpr)  tpr = 0 ; end
if isempty(tqrs)||isnan(tqrs)  tqrs = 0 ; end
if isempty(tqt)||isnan(tqt)  tqt = 0 ; end
pamp = mean(pamp)/mean(ramp);;
qamp = mean(qamp)/mean(ramp);;
samp = mean(samp)/mean(ramp);;
tamp = mean(tamp)/mean(ramp);;

% QRS width
x = POS.Q; 
if isnan(x)
    x = POS.QRSonset;
end;
y = POS.S;  
if isnan(y)
    y = POS.QRSoffset;
end
tqrs2 = 1000*(y - x)/fs;
    





% ST ·ù¶È
st1 = avg_ecg(POS.QRSonset);
st2 =  mean(avg_ecg(POS.QRSoffset:POS.QRSoffset+0.04*fs));
st = abs(st1-st2);

% QRS¹â»¬¶È
dx = diff(avg_ecg);
ddx = diff(dx);
x = ddx(POS.QRSonset:POS.R);
m = 0;
for ii = 1:length(x)-1
    if (x(ii) < 0 && x(ii+1) > 0 ) ||(x(ii) > 0 && x(ii+1) < 0 )
        m = m +1;
    end
end;
qrmrp = m;
if ~isnan(POS.Q)
    tso = POS.QRSoffset - POS.Q;
else
    tso = 0 ;
end
