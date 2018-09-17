
function ecg_qrst_plot(ecg,POS,AMP)
    P = POS.P(~isnan(POS.P));
QRSbeg = POS.QRSonset(~isnan(POS.QRSonset));
QRSend = POS.QRSoffset(~isnan(POS.QRSoffset));
R = POS.R(~isnan(POS.R));
T = POS.T(~isnan(POS.T));
 subplot(221);plot(ecg); hold on;;
 plot(P,ecg(P),'.r');
 plot(QRSbeg,ecg(QRSbeg),'.k');
 plot(R,ecg(R),'*r');
 plot(QRSend,ecg(QRSend),'.k');
 plot(T,ecg(T),'.r');  plot(POS.fiducial,AMP.R);plot(POS.fiducial,AMP.S);hold off;
 
 rr = diff(POS.R);
 
 subplot(222);hist(AMP.R); %scatter(AMP.R(1:end-1),rr);
 subplot(223);plot(POS.QRSoffset- POS.QRSonset);
  subplot(224);hist(rr); 
 
 