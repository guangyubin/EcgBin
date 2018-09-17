%%
II = x;
RR = 1;
QT=(.4*sqrt(RR));
QT=round(QT*1000);
%   ---- Preprocessing ----
% Moving averaging
m=length(II); clear IIf; clear V2f
IIf(10:m-11)=(II(1:m-20)+II(2:m-19)+II(3:m-18)+II(4:m-17)+II(5:m-16)+...
    II(6:m-15)+II(7:m-14)+II(8:m-13)+II(9:m-12)+II(10:m-11)+...
    II(11:m-10)+II(12:m-9)+II(13:m-8)+II(14:m-7)+II(15:m-6)+...
    II(16:m-5)+II(17:m-4)+II(18:m-3)+II(19:m-2)+II(20:m-1))/20 - ...
    (II(21:m)+II(1:m-20))/40;
IIf(1:9)=IIf(10);
IIf(length(II)-11:length(II))=IIf(length(II)-12);

% Baseline wander suppression filter
% Forward high-pass recursive filter useing the formula:
%          Y(i)=C1*(X(i)-X(i-1)) + C2*Y(i-1)
Hz=1000;    % 1000 Hz sampling rate
T=1/Hz;        % [s] - sampling period
Fc=0.64;               % [Hz]
C1=1/[1+tan(Fc*pi*T)];  C2=[1-tan(Fc*pi*T)]/[1+tan(Fc*pi*T)];
b=[C1 -C1]; a=[1 -C2];
IIf=IIf-IIf(1);
ECG=filter(b,a,IIf);
ECG=fliplr(ECG);
ECG=ECG-ECG(1);
ECG=filter(b,a,ECG);
ECG=fliplr(ECG);
% Cubic approximation
clear A;
n=15;                % +- 15 ms
i1=-n:n;				% coeficient calculation
coef=((3.*n.*n+3.*n-1)-5.*i1.*i1);
coef=rot90(coef);
for j=n+1:length(ECG)-n;
    A(j)=ECG(j-n:j+n)*(coef);
end
A=A*3/((2*n+1)*(4*n*n+4*n-3));
for j=1:n; A(j)=A(n+1); end
for j=length(ECG)-n+1:length(ECG); A(j)=A(length(ECG)-n);end
II=A;

QRS_best= 400;
i = 1;
[QRSmax(i) ma(i)]=max(abs(II(QRS_best-100:QRS_best+100)));
ma(i)=ma(i)+QRS_best-100-1;
QRSmax(i)=sign(II(ma(i)))*QRSmax(i);

% Ampitude of the QRS
QRSampl=max(II(ma(i)-60:ma(i)+60))-min(II(ma(i)-60:ma(i)+60));

%   ---- Q ----
%	---- Flat segmet search to the left
Flat=20;        % 20 ms
Crit=0.02*QRSampl;     % mV
From=ma(i)-20; To=max([From-150+Flat, 2+Flat]);
Pnt=0; a=0;
while Pnt==0;
    if a<2; a=a+1; 			%increase a
    else Crit=Crit+0.002;	%increase Crit with 1 uV
    end
    
    for ii=From:-1:To;
        d(1:Flat)=II(ii:-1:ii-Flat+1)-II(ii-1:-1:ii-Flat);
        if max(abs(d)) < Crit &...
                abs(II(ii)-II(ii-Flat-1)) < 4*a*Crit &...
                abs(II(ii)-II(ii-floor(Flat/2))) < 3*a*Crit &...
                abs(II(ii-Flat)-II(ii-floor(Flat/2))) < 3*a*Crit &...
                abs(II(ii))<0.1+Crit;
            Pnt=ii; break
        end
    end
end

Qflat=Pnt-Flat;

%	---- Simultaneous searh for peak or slope
s=10;                           % 10 ms
Crit=QRSampl*.005;		% .5%
Qsl=0;
Crit1=Crit*3;		%*3
Crit2=Crit*4;       %*4
for ii=Qflat+s:ma(i)-s;         % 100 ms
    D1=II(ii)-II(ii-s); D2=II(ii)-II(ii+s);
    if D1>Crit1 & D2>Crit1; Qsl=ii+s/2; break;
    elseif  D1<-Crit1 & D2<-Crit1; Qsl=ii+s/2; break;
    elseif II(ii)-II(ii+2)>Crit2 & II(ii+2)-II(ii+4)>Crit2 & II(ii+4)-II(ii+6)>Crit2 & II(ii+3)-II(ii+5)>Crit2 & II(ii+4)-II(ii+6)>Crit2 & II(ii+5)-II(ii+7)>Crit2 & II(ii+6)-II(ii+8)>Crit2 & II(ii+7)-II(ii+9)>Crit2;
        Qsl=ii+s/2+3; break;
    elseif II(ii)-II(ii+2)<-Crit2 & II(ii+2)-II(ii+4)<-Crit2 & II(ii+4)-II(ii+6)<-Crit2 & II(ii+3)-II(ii+5)<-Crit2 & II(ii+4)-II(ii+6)<-Crit2 & II(ii+5)-II(ii+7)<-Crit2 & II(ii+6)-II(ii+8)<-Crit2 & II(ii+7)-II(ii+9)<-Crit2;
        Qsl=ii+s/2+3; break;
    end
end
if Qsl==0; Qsl=Qflat+30; disp ('ERROR !'); end

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
Flat=20;        % 20 ms
Crit=0.02*QRSampl;     % mV
From=ma(i)+20; To=From+150;
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
s=40;           % 40 ms
Wing(s:length(II)-s)=(II(1:length(II)-2*s+1)-II(s:length(II)-s)).*(II(s:length(II)-s)-II(2*s:length(II)));
Wing=Wing(s:length(Wing));

%	----	Find Tpeak (the min of the 'wing')
[Mi,mi2]=min(Wing(Sis+round(QT/18):max([Q_a(i)+round(QT-QT/8) Sis+30])));
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
if Sis-Q_a(i)>200; Tis=Sis; Ts=Tis-30; end

% Tangent
clear angT1; clear angT2;
s1=10;
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
else
    
    %	---- 	Find end of T where two concecutive angles differ most
    angT=angT1-angT2;
    [Max,T_end]=max(abs(angT));
end


Tend(i)=T_end;
figure;plot(II);hold on;plot([Q_a(1) Tend(i)], II([Q_a(1) Tend(i)]),'.r');