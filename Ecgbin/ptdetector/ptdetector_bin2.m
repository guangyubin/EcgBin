% PQRST detector using Christov's method
% Input:x ECG data
%       fs: sample rate
%       findmark: QRS position from QRS det
%       rr: RR interval  in ms
%       fig: plot
% Output: wavepos 1*9 vector [Ponset P Poffset QRSonset R QRSoffset Tonset T Toffset]

% Author: guangyubin@bjut.edu.cn
% History: 2017/10/15  Modify refer the Christov'method
%          2017/10/17  Add P wave detector
function [wavepos, QRSampl,Tampl] = ptdetector_bin2(x,fs,findmark,rr,fig)

if nargin  < 5
    fig = 0 ;
end;


RR = rr/1000;
QT=(.4*sqrt(RR));
QT=round(QT*fs);
%   ---- Preprocessing ----
% 
IIf = smooth(x,fs/50)';

T=1/fs;       
Fc=0.64;             
C1=1/[1+tan(Fc*pi*T)]; 
C2=[1-tan(Fc*pi*T)]/[1+tan(Fc*pi*T)];
b=[C1 -C1]; a=[1 -C2];
IIf=IIf-IIf(1);
ECG = filtfilt(b,a,IIf);
x = ECG;
% x = x - mean(x);
% figure;subplot(211);plot(x);subplot(212);plot(ECG);
i = 1;
[QRSmax, ma]=max(abs(x(findmark-floor(0.02*fs):findmark+0.1*fs)));
ma=ma+findmark-floor(0.02*fs)-1;
QRSmax=sign(x(ma))*QRSmax;

% Ampitude of the QRS
LAT1 = floor(0.06*fs);
QRSampl=max(x(ma-LAT1:ma+LAT1))-min(x(ma-LAT1:ma+LAT1));
if QRSampl < 0.001
    wavepos = zeros(1,9);
    Tampl = 0 ;
    return;
end;
%   ---- Q ----
%	---- Flat segmet search to the left


Qflat1 = findFlatLeft(x,fs,floor(0.020*fs),0.02*QRSampl,ma, floor(0.12*fs),'left');
Qsl = findSlopeOrPeakRight(x,fs,floor(0.01*fs),Qflat1,ma,QRSampl*0.015,QRSampl*0.02,'right');
Q_a = findAnglesDiffMost(x,fs,floor(0.01*fs),Qflat1,Qsl);

% str = sprintf('%d %d  %d  %d \n ' ,ma,  Qflat1,Qsl,Q_a);
% disp(str);

Sis = findFlatLeft(x,fs,floor(0.02*fs),0.02*QRSampl,ma, floor(0.15*fs),'right');
Qe_flat = Sis;
Qe_slop = findSlopeOrPeakRight(x,fs,floor(0.01*fs),Qe_flat,ma,QRSampl*0.015,QRSampl*0.02,'left');
Qe_onst = findAnglesDiffMost(x,fs,floor(0.01*fs),Qe_slop,Qe_flat);
Q_e = Qe_onst;
% str = sprintf('%d %d  %d  %d\n  ' ,ma,  Qe_flat,Qe_slop,Q_e);
% disp(str);
%-----------Find P -----------------------------------------------------------------

% Qflat2 = findFlatLeft(x,floor(0.020*fs),0.02*QRSampl,Q_a, floor(0.06*fs),'left');
s=floor(0.06*fs);           % 40 ms
Qflat1 = Qflat1-floor(0.01*fs);
Qflat0 = findFlatLeft(x,fs,floor(0.020*fs),0.04*QRSampl,Qflat1-floor(0.1*fs), floor(0.12*fs),'left');
% str = sprintf('%d \n  ' ,Qflat0);
% disp(str);

Wing(s:length(x)-s)=(x(1:length(x)-2*s+1)-x(s:length(x)-s)).*(x(s:length(x)-s)-x(2*s:length(x)));
Wing=[zeros(1,s) Wing(s:length(Wing))];
% figure;plot(Wing);

[Mi,mi2]=min(Wing(Qflat0:Qflat1-floor(0.04*fs)));
Pp=mi2+Qflat0-1;

% str = sprintf('Pp = %d Qflat0 = %d  Qflat1 = %d\n  ' ,Pp ,Qflat0 ,Qflat1);
% disp(str);

% tic
Pis = findFlatLeft(Wing,fs,floor(0.020*fs),floor(0.04*Wing(Pp)),Pp, floor(0.05*fs),'right');
[Mi2 mi2]=max(Wing(Pp:Pis));
Pth=Pp+mi2-1;
% toc
P_Off = findAnglesDiffMost(x,fs,floor(0.01*fs),Pth,Pis);




Pis = findFlatLeft(Wing,fs,floor(0.020*fs),0.04*Wing(Pp),Pp, floor(0.06*fs),'left');
[Mi2 mi2]=max(Wing(Pis:Pp));
Pth=Pis+mi2-1;
P_On = findAnglesDiffMost(x,fs,floor(0.01*fs),Pis,Pth);

if fig==1

subplot(211);plot(x);hold on;plot([Qflat0  Pp Qflat1 P_On],x([Qflat0  Pp Qflat1 P_On]),'.') ;hold off;
subplot(212);plot(Wing);hold on;plot([Qflat0  Pp Qflat1 P_On],Wing([Qflat0  Pp Qflat1 P_On]),'.');hold off;
end
%----------------------------------------------------------------------------

%	-------------	Searching for big peaks by 'wings' function

s=floor(0.04*fs);           % 40 ms
Wing(s:length(x)-s)=(x(1:length(x)-2*s+1)-x(s:length(x)-s)).*(x(s:length(x)-s)-x(2*s:length(x)));
Wing=Wing(s:length(Wing));



%	----	Find Tpeak (the min of the 'wing')
[Mi,mi2]=min(Wing(Sis+round(QT/18):max([Q_a(i)+round(QT-QT/8) Sis+floor(0.03*fs)])));
Tp=mi2+Sis+round(QT/18)+s-1;

%	----	Find the steepest slope right from the Tpeak
[Mi2 mi2]=max(Wing(Tp-s:Tp-s+round(QT/5)));
Tth=Tp+mi2;

% Find the inflection point of the T wave
[Mi2 mi2]=min(Wing(Tth-s:Tth-s+round((QT/5))));
Tis=Tth+mi2;

%	----	Set a trash hold value = 80% of the amplitude
Tampl=x(Tp)-x(Tis);

tmp = [zeros(1,s) Wing zeros(1,s-1)];

Ts = Tth;
for ii=Tth:Tis;
    if abs(x(Tp)-x(ii))>abs(Tampl)*8/10; Ts=ii; break; end;
end

% If the QRS > 200 ms
% if Sis-Q_a(i)>floor(0.2*fs); Tis=Sis; Ts=Tis-floor(0.03*fs); end


clear angT1; clear angT2;
s1=floor(0.01*fs);
Tis=Tis+s1;     % Tis to be considered
for j=Ts:Tis;
    angT1(j)=atan((x(j+s1)-x(j))*250/s1)*180/pi;	%bigger-less
    angT2(j)=atan((x(j)-x(j-s1))*250/s1)*180/pi;	%bigger-less
end
%	---- 	Find end of T where there is change of sign of the tangent
mul=angT1.*angT2;
Sign=find(mul<0);
if length(Sign)>0;
    T_end=Sign(1)-s1;
else   %	---- 	Find end of T where two concecutive angles differ most
    angT=angT1-angT2;
    [Max,T_end]=max(abs(angT));
end

 if abs(Tampl)< QRSampl*0.05
     T_end = Q_a+QT;
 end;
% T_end = findAnglesDiffMost(x,floor(0.01*fs),Ts,TiTifloor(0.01*fs)s1);
P_On = P_On- 0.004*fs;
P_Off = P_Off+ 0.012*fs;
Q_a = Q_a - 0.004*fs;
Q_e = Q_e  -0.008*fs ;
T_end = T_end+0.004*fs;

wavepos(1) = P_On ;
wavepos(2) = Pp;
wavepos(3) = P_Off;
wavepos(4) = Q_a;
wavepos(5) = ma;
wavepos(6) = Q_e;
wavepos(9) = T_end;
wavepos = floor(wavepos);
% if fig==1;
%     plot(x);hold on;plot([Q_a(1) Tend(i)], x([Q_a(1) Tend(i)]),'.r');
% end