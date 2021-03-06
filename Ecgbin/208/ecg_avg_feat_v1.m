
function [tpr, tqrs, tqt , pamp,qamp,samp,tamp] = ecg_avg_feat_v1(avg_ecg,fs,fig)

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

if isempty(tpr)  tpr = 0 ; end
if isempty(tqrs)  tqrs = 0 ; end
if isempty(tqt)  tqt = 0 ; end

pamp = mean(pamp)/mean(ramp);;
qamp = mean(qamp)/mean(ramp);;
samp = mean(samp)/mean(ramp);;
tamp = mean(tamp)/mean(ramp);;

