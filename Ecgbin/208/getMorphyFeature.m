
%% 
function [mtQRS1,mtQRS2,mtPR,mPamp ,mQamp, mRamp ,mSamp, mTamp ] = getMorphyFeature(POS,AMP,idx,fs)



tQRS1 = POS.QRSoffset - POS.QRSonset;

x = POS.Q;  x(isnan(x)) = POS.QRSonset(isnan(x));
y = POS.S;  y(isnan(x)) = POS.QRSoffset(isnan(x));
tQRS2 = y - x;

tPR = POS.QRSonset - POS.P;
Pamp = AMP.P;
Qamp = AMP.Q;
Ramp = AMP.R;
Samp = AMP.S;
Tamp = AMP.T;


mPamp = avg_pro(Pamp(idx));
mQamp = avg_pro(Qamp(idx));
mRamp = avg_pro(Ramp(idx));
mSamp = avg_pro(Samp(idx));
mTamp = avg_pro(Tamp(idx));
mtQRS1 = 1000*avg_pro(tQRS1(idx))/fs;
mtQRS2 = 1000*avg_pro(tQRS2(idx))/fs;
mtPR = 1000*avg_pro(tPR(idx))/fs;

function mx = avg_pro(x)
n = length(find(~isnan(x)))/length(x);
if n > 0.5
    mx = median(x(~isnan(x)));
else 
    mx = 0 ;
end;
