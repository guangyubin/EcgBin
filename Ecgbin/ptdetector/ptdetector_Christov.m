% PQRST detector using Christov's method
% Input:x ECG data
%       fs: sample rate
%       findmark: QRS position from QRS det
%       rr: RR interval  in ms
%       fig: plot 
% Output: wavepos 1*9 vector [Ponset P Poffset QRSonset R QRSoffset Tonset T Toffset]
function wavepos = ptdetector_Christov(x,fs,findmark,rr,fig)

if nargin  < 5
    fig = 0 ;
end;


% fs = 1000;
% rr = 1000;
II = x;
% findmark = 0.4*fs;
% II = resample(x,250,1000);
% II = DATA(:,800)';
RR = rr/1000;
QT=(.4*sqrt(RR));
QT=round(QT*fs);
%   ---- Preprocessing ----
% Moving averaging
% m=length(II); clear IIf; clear V2f
% IIf(10:m-11)=(II(1:m-20)+II(2:m-19)+II(3:m-18)+II(4:m-17)+II(5:m-16)+...
%     II(6:m-15)+II(7:m-14)+II(8:m-13)+II(9:m-12)+II(10:m-11)+...
%     II(11:m-10)+II(12:m-9)+II(13:m-8)+II(14:m-7)+II(15:m-6)+...
%     II(16:m-5)+II(17:m-4)+II(18:m-3)+II(19:m-2)+II(20:m-1))/20 - ...
%     (II(21:m)+II(1:m-20))/40;
% IIf(1:9)=IIf(10);
% IIf(length(II)-11:length(II))=IIf(length(II)-12);
IIf = smooth(II,fs/50)';

% Baseline wander suppression filter
% Forward high-pass recursive filter useing the formula:
%          Y(i)=C1*(X(i)-X(i-1)) + C2*Y(i-1)

T=1/fs;        % [s] - sampling period
Fc=0.64;               % [Hz]
C1=1/[1+tan(Fc*pi*T)];  C2=[1-tan(Fc*pi*T)]/[1+tan(Fc*pi*T)];
b=[C1 -C1]; a=[1 -C2];
IIf=IIf-IIf(1);
ECG = filtfilt(b,a,IIf);
% Cubic approximation
% clear A;
% n=15;                % +- 15 ms
% i1=-n:n;				% coeficient calculation
% coef=((3.*n.*n+3.*n-1)-5.*i1.*i1);
% coef=rot90(coef);
% for j=n+1:length(ECG)-n;
%     A(j)=ECG(j-n:j+n)*(coef);
% end
% A=A*3/((2*n+1)*(4*n*n+4*n-3));
% for j=1:n; A(j)=A(n+1); end
% for j=length(ECG)-n+1:length(ECG); A(j)=A(length(ECG)-n);end
% II=A;
II = ECG;
QRS_best= findmark;
i = 1;
[QRSmax, ma]=max(abs(II(QRS_best-floor(0.06*fs):QRS_best+0.1*fs)));
ma=ma+QRS_best-floor(0.06*fs)-1;
QRSmax=sign(II(ma))*QRSmax;

% Ampitude of the QRS
LAT1 = floor(0.06*fs);
QRSampl=max(II(ma-LAT1:ma+LAT1))-min(II(ma-LAT1:ma+LAT1));

%   ---- Q ----
%	---- Flat segmet search to the left
Flat= floor(0.020*fs);        % 20 ms
LAT1 = floor(0.15*fs);
Crit=0.02*QRSampl;     % mV

From=ma-Flat; To=max([From-LAT1+Flat, 2+Flat]);
Pnt=0; a=0;
while Pnt==0;
    if a<2; a=a+1; 			%increase a
    else Crit=Crit+0.001;	%increase Crit with 1 uV
    end
    
    for ii=From:-1:To;
        d(1:Flat)=II(ii:-1:ii-Flat+1)-II(ii-1:-1:ii-Flat);
        if ...    
            max(abs(d)) < Crit &...
                abs(II(ii)-II(ii-Flat-1)) < 4*a*Crit &...
                abs(II(ii)-II(ii-floor(Flat/2))) < 3*a*Crit &...
                abs(II(ii-Flat)-II(ii-floor(Flat/2))) < 3*a*Crit...
%             &...
%                 abs(II(ii))<0.1+Crit;
            Pnt=ii; break
        end
    end
end

Qflat=Pnt-Flat;
     % 往前看，是否有dx> maxslope/4
%      ii = Qflat;
%     while(ii > Qflat - 0.04*fs &&  II(ii) - II(ii-1)  <  Crit)
%         ii = ii - 1;
%     end;
%     % 如果有dx > maxslope/4
%     if ii > Qflat - 0.04*fs
%         % 继续搜索
%         while ii > 1 &&  II(ii) - II(ii-1) >  Crit
%             ii = ii-1;
%         end
%         Qflat = ii - 1;
%     end
% Qflat = 93;
%	---- Simultaneous searh for peak or slope
s=floor(0.01*fs);                           % 10 ms
Crit=QRSampl*.005;		% .5%
Qsl=0;
Crit1=Crit*3;		%*3
Crit2=Crit*4;       %*4
% for ii=Qflat+s:ma-s;         % 100 ms
%     D1=II(ii)-II(ii-s); D2=II(ii)-II(ii+s);
%     if D1>Crit1 & D2>Crit1; Qsl=ii+s/2; break;
%     elseif  D1<-Crit1 & D2<-Crit1; Qsl=ii+s/2; break;
%     elseif  II(ii)-II(ii+2)>Crit2 & II(ii+2)-II(ii+4)>Crit2 & II(ii+4)-II(ii+6)>Crit2 & II(ii+3)-II(ii+5)>Crit2 & II(ii+4)-II(ii+6)>Crit2 & II(ii+5)-II(ii+7)>Crit2 & II(ii+6)-II(ii+8)>Crit2 & II(ii+7)-II(ii+9)>Crit2;
%         Qsl=ii+s/2+3; break;
%     elseif II(ii)-II(ii+2)<-Crit2 & II(ii+2)-II(ii+4)<-Crit2 & II(ii+4)-II(ii+6)<-Crit2 & II(ii+3)-II(ii+5)<-Crit2 & II(ii+4)-II(ii+6)<-Crit2 & II(ii+5)-II(ii+7)<-Crit2 & II(ii+6)-II(ii+8)<-Crit2 & II(ii+7)-II(ii+9)<-Crit2;
%         Qsl=ii+s/2+3; break;
%     end
% end

for ii=Qflat+s:ma-s;         % 100 ms
    D1=II(ii)-II(ii-s); D2=II(ii)-II(ii+s);
    if abs(D1)>Crit2 && abs(D2)>Crit2; 
        Qsl=ii+s/2; break;
    end

end
if Qsl==0; 
    Qsl=Qflat+0.03*fs; 
    disp ('ERROR !'); 
end

%	---- Find QRS onset when two concecutive angles differ most
clear angQ1; clear angQ2; clear Q;
if Qflat+s>=Qsl-s; Qflat=Qflat-s; end
for j=Qflat+s:Qsl-s;
    angQ1(j)=atan((II(j+s)-II(j))*250/s)*180/pi;	%bigger-less
    angQ2(j)=atan((II(j)-II(j-s))*250/s)*180/pi;	%bigger-less
end;

angQ=angQ1-angQ2;
angQ=angQ(Qflat+s:length(angQ));
[Max,Q_a(i)]=max(abs(angQ));            % Automatic Q onset
Q_a(i)=Q_a(i)+(Qflat+s);
Q_a(i)=Q_a(i);

%   ---- T ----
%	---- Flat segmet search to the right
Flat=floor(0.02*fs);        % 20 ms
Crit=0.02*QRSampl;     % mV
From=ma+Flat; To=From+floor(0.15*fs);
Pnt=0; a=0;
while Pnt==0;
    if a<2; a=a+1; 			%increase a
    else Crit=Crit+0.002;	%increase Crit with 1 uV
    end
    
    for ii=From:To;
        d(1:Flat)=II(ii:ii+Flat-1)-II(ii+1:ii+Flat);
        if max(abs(d)) < Crit &...
                abs(II(ii)-II(ii+Flat+1)) < 4*a*Crit &...
                abs(II(ii)-II(ii+floor(Flat/2))) < 3*a*Crit &...
                abs(II(ii+Flat)-II(ii+floor(Flat/2))) < 3*a*Crit &...
                abs(II(ii))<0.2+Crit;
            Pnt=ii; break
        end
    end
end
Sis=Pnt+Flat;

%	----	Searching for big peaks by 'wings' function
clear Wing
s=floor(0.04*fs);           % 40 ms
Wing(s:length(II)-s)=(II(1:length(II)-2*s+1)-II(s:length(II)-s)).*(II(s:length(II)-s)-II(2*s:length(II)));
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
Tampl=II(Tp)-II(Tis);
for ii=Tth:Tis;
    if abs(II(Tp)-II(ii))>abs(Tampl)*8/10; Ts=ii; break; end;
end

% If the QRS > 200 ms
% if Sis-Q_a(i)>floor(0.2*fs); Tis=Sis; Ts=Tis-floor(0.03*fs); end

% Tangent
clear angT1; clear angT2;
s1=floor(0.01*fs);
Tis=Tis+s1;     % Tis to be considered
for j=Ts:Tis;
    angT1(j)=atan((II(j+s1)-II(j))*250/s1)*180/pi;	%bigger-less
    angT2(j)=atan((II(j)-II(j-s1))*250/s1)*180/pi;	%bigger-less
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

 %   ---- Check the amplitude of the T wave
%  if abs(Tampl)>0.040; Tamp(i)=0;
%  else Tamp(i)=1; disp('low ampl') % very low amplitude ?
%      
%      clear Wing
%      s=40;           % 40 ms
%      Wing(s:length(V2)-s)=(V2(1:length(V2)-2*s+1)-V2(s:length(V2)-s)).*(V2(s:length(V2)-s)-V2(2*s:length(V2)));
%      Wing=Wing(s:length(Wing));
%      
%      %	----	Find Tpeak (the min of the 'wing')
%      [Mi,Tp]=min(Wing(Sis+round(QT/18):Q_a(i)-x(1)+round(QT-QT/8)));
%      Tp=Tp+Sis+round(QT/18)+s-1;
%      
%      %	----	Find the steepest slope right from the Tpeak
%      [Mi2 mi2]=max(Wing(Tp-s:Tp-s+round(QT/5)));
%      Tth=Tp+mi2;
%      
%      % Find the inflection point of the T wave
%      [Mi2 mi2]=min(Wing(Tth-s:Tth-s+round((QT/5))));
%      Tis=Tth+mi2;
%      
%      %	----	Set a trash hold value = 80% of the amplitude
%      Tampl=V2(Tp)-V2(Tis);
%      for ii=Tth:Tis;
%          if abs(V2(Tp)-V2(ii))>abs(Tampl)*8/10; Ts=ii; break; end;
%      end
%      
%      % Tangent
%      clear angT1; clear angT2;
%      s1=10;
%      Tis=Tis+s1;     % Tis to be considered
%      for j=Ts:Tis;
%          angT1(j)=atan((V2(j+s1)-V2(j))*250/s1)*180/pi;	%bigger-less
%          angT2(j)=atan((V2(j)-V2(j-s1))*250/s1)*180/pi;	%bigger-less
%      end
%      
%      %	---- 	Find end of T where there is change of sign of the tangent
%      mul=angT1.*angT2;
%      Sign=find(mul<0);
%      if length(Sign)>0;
%          T_end=Sign(1)-s1;
%      else
%          %	---- 	Find end of T where two concecutive angles differ most
%          angT=angT1-angT2;
%          [Max,T_end]=max(abs(angT));
%      end
%  end
%  Tend(i)=T_end+x(1);
        
        
        
Tend(i)=T_end;
wavepos(1) = Qflat ;
wavepos(2) = Qsl;
wavepos(3) = Tth;
wavepos(4) = Q_a(1);
wavepos(5) = ma;
wavepos(6) = Sis;
wavepos(9) = T_end;
wavepos = floor(wavepos);
if fig==1;
    plot(II);hold on;plot([Q_a(1) Tend(i)], II([Q_a(1) Tend(i)]),'.r');
end