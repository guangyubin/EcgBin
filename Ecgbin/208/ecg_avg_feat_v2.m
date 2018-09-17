
function [dur_P_Q ,dur_QRS,dur_QT,val_ST] = ecg_avg_feat_v2(ecg,POS,SQIType,fs)
%%


dur_P_Q = 100 ;
dur_QT = 300 ; 
dur_QRS = 60;
val_ST = 0 ;

list = find(SQIType==1);

x = POS.QRSonset(list)- POS.Ponset(list);
idx = ~isnan(x);
if isempty(list(idx)) return ;end;
dur_P_Q = median(x(idx))*1000/fs;


x = POS.QRSoffset(list)- POS.QRSonset(list);
idx = ~isnan(x);
if isempty(list(idx)) return ;end;
dur_QRS = median(x(idx))*1000/fs;


x = POS.Toffset(list)- POS.QRSoffset(list);
idx = ~isnan(x);
if isempty(list(idx)) return ;end;
dur_QT =  median(x(idx))*1000/fs;;


idx = (~isnan(POS.QRSoffset(list))) & (~isnan(POS.Tonset(list))) & (~isnan(POS.Poffset(list))) & (~isnan(POS.QRSonset(list)));
if isempty(list(idx)) return ;end;

p = POS.Poffset(list); p = p(idx);
q = POS.QRSonset(list); q = q(idx);
s =  POS.QRSoffset(list); s = s(idx);
t = POS.Tonset(list); t = t(idx);
for ii = 1 : length(idx)
    base = mean(ecg(p:q));
    st(ii) = max(abs((ecg(s:t)) - base));;
end;
val_ST = median(st);

