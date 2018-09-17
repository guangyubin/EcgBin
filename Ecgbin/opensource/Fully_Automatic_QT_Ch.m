%  Fully_Automatic_QT_Ch.m
%  Fully Automated Method for QT Interval Measurement in ECG
%  Copyright (C) 2006, Ivaylo Christov, Iana Simova.
%  This software is released under the terms of the GNU General
%  Public License (http://www.gnu.org/copyleft/gpl.html).

clear all
Pat= ['patient001/s0010_re patient001/s0014lre patient001/s0016lre patient002/s0015lre patient003/s0017lre patient004/s0020are patient004/s0020bre patient005/s0021are patient005/s0021bre patient005/s0025lre '];
Pat=[Pat 'patient005/s0031lre patient005/s0101lre patient006/s0022lre patient006/s0027lre patient006/s0064lre patient007/s0026lre patient007/s0029lre patient007/s0038lre patient007/s0078lre patient008/s0028lre '];
Pat=[Pat 'patient008/s0037lre patient008/s0068lre patient009/s0035_re patient010/s0036lre patient010/s0042lre patient010/s0061lre patient011/s0039lre patient011/s0044lre patient011/s0049lre patient011/s0067lre '];
Pat=[Pat 'patient012/s0043lre patient012/s0050lre patient013/s0045lre patient013/s0051lre patient013/s0072lre patient014/s0046lre patient014/s0056lre patient014/s0071lre patient015/s0047lre patient015/s0057lre '];
Pat=[Pat 'patient015/s0152lre patient016/s0052lre patient016/s0060lre patient016/s0076lre patient017/s0053lre patient017/s0055lre patient017/s0063lre patient017/s0075lre patient018/s0054lre patient018/s0059lre '];
Pat=[Pat 'patient018/s0082lre patient019/s0058lre patient019/s0070lre patient019/s0077lre patient020/s0062lre patient020/s0069lre patient020/s0079lre patient021/s0065lre patient021/s0073lre patient021/s0097lre '];
Pat=[Pat 'patient022/s0066lre patient022/s0074lre patient022/s0149lre patient023/s0080lre patient023/s0081lre patient023/s0085lre patient023/s0103lre patient024/s0083lre patient024/s0084lre patient024/s0086lre '];
Pat=[Pat 'patient024/s0094lre patient025/s0087lre patient025/s0091lre patient025/s0150lre patient026/s0088lre patient026/s0095lre patient027/s0089lre patient027/s0096lre patient027/s0151lre patient028/s0090lre '];
Pat=[Pat 'patient028/s0093lre patient028/s0108lre patient029/s0092lre patient029/s0098lre patient029/s0122lre patient030/s0099lre patient030/s0107lre patient030/s0117lre patient030/s0153lre patient031/s0100lre '];
Pat=[Pat 'patient031/s0104lre patient031/s0114lre patient031/s0127lre patient032/s0102lre patient032/s0106lre patient032/s0115lre patient032/s0165lre patient033/s0105lre patient033/s0113lre patient033/s0121lre '];
Pat=[Pat 'patient033/s0157lre patient034/s0109lre patient034/s0118lre patient034/s0123lre patient034/s0158lre patient035/s0110lre patient035/s0119lre patient035/s0124lre patient035/s0145lre patient036/s0111lre '];
Pat=[Pat 'patient036/s0116lre patient036/s0126lre patient037/s0112lre patient037/s0120lre patient038/s0125lre patient038/s0128lre patient038/s0162lre patient039/s0129lre patient039/s0134lre patient039/s0164lre '];
Pat=[Pat 'patient040/s0130lre patient040/s0131lre patient040/s0133lre patient040/s0219lre patient041/s0132lre patient041/s0136lre patient041/s0138lre patient041/s0276lre patient042/s0135lre patient042/s0137lre '];
Pat=[Pat 'patient042/s0140lre patient042/s0347lre patient043/s0141lre patient043/s0144lre patient043/s0278lre patient044/s0142lre patient044/s0143lre patient044/s0146lre patient044/s0159lre patient045/s0147lre '];
Pat=[Pat 'patient045/s0148lre patient045/s0155lre patient045/s0217lre patient046/s0156lre patient046/s0161lre patient046/s0168lre patient046/s0184lre patient047/s0160lre patient047/s0163lre patient047/s0167lre '];
Pat=[Pat 'patient048/s0171lre patient048/s0172lre patient048/s0180lre patient048/s0277lre patient049/s0173lre patient049/s0178lre patient049/s0186lre patient049/s0314lre patient050/s0174lre patient050/s0177lre '];
Pat=[Pat 'patient050/s0185lre patient050/s0215lre patient051/s0179lre patient051/s0181lre patient051/s0187lre patient051/s0213lre patient052/s0190lre patient053/s0191lre patient054/s0192lre patient054/s0195lre '];
Pat=[Pat 'patient054/s0197lre patient054/s0218lre patient055/s0194lre patient056/s0196lre patient057/s0198lre patient058/s0216lre patient059/s0208lre patient060/s0209lre patient061/s0210lre patient062/s0212lre '];
Pat=[Pat 'patient063/s0214lre patient064/s0220lre patient065/s0221lre patient065/s0226lre patient065/s0229lre patient065/s0282lre patient066/s0225lre patient066/s0231lre patient066/s0280lre patient067/s0227lre '];
Pat=[Pat 'patient067/s0230lre patient067/s0283lre patient068/s0228lre patient069/s0232lre patient069/s0233lre patient069/s0234lre patient069/s0284lre patient070/s0235lre patient071/s0236lre patient072/s0237lre '];
Pat=[Pat 'patient072/s0240lre patient072/s0244lre patient072/s0318lre patient073/s0238lre patient073/s0243lre patient073/s0249lre patient073/s0252lre patient074/s0239lre patient074/s0241lre patient074/s0245lre '];
Pat=[Pat 'patient074/s0406lre patient075/s0242lre patient075/s0246lre patient075/s0248lre patient075/s0327lre patient076/s0247lre patient076/s0250lre patient076/s0253lre patient076/s0319lre patient077/s0251lre '];
Pat=[Pat 'patient077/s0254lre patient077/s0258lre patient077/s0285lre patient078/s0255lre patient078/s0259lre patient078/s0262lre patient078/s0317lre patient079/s0256lre patient079/s0257lre patient079/s0263lre '];
Pat=[Pat 'patient079/s0269lre patient080/s0260lre patient080/s0261lre patient080/s0265lre patient080/s0315lre patient081/s0264lre patient081/s0266lre patient081/s0270lre patient081/s0346lre patient082/s0267lre '];
Pat=[Pat 'patient082/s0271lre patient082/s0279lre patient082/s0320lre patient083/s0268lre patient083/s0272lre patient083/s0286lre patient083/s0290lre patient084/s0281lre patient084/s0288lre patient084/s0289lre '];
Pat=[Pat 'patient084/s0313lre patient085/s0296lre patient085/s0297lre patient085/s0298lre patient085/s0345lre patient086/s0316lre patient087/s0321lre patient087/s0326lre patient087/s0330lre patient088/s0339lre '];
Pat=[Pat 'patient088/s0343lre patient088/s0352lre patient088/s0413lre patient089/s0344lre patient089/s0355lre patient089/s0359lre patient089/s0372lre patient090/s0348lre patient090/s0356lre patient090/s0360lre '];
Pat=[Pat 'patient090/s0418lre patient091/s0353lre patient091/s0357lre patient091/s0361lre patient091/s0408lre patient092/s0354lre patient092/s0358lre patient092/s0362lre patient092/s0411lre patient093/s0367lre '];
Pat=[Pat 'patient093/s0371lre patient093/s0375lre patient093/s0378lre patient093/s0396lre patient094/s0368lre patient094/s0370lre patient094/s0376lre patient094/s0412lre patient095/s0369lre patient095/s0373lre '];
Pat=[Pat 'patient095/s0377lre patient095/s0417lre patient096/s0379lre patient096/s0381lre patient096/s0385lre patient096/s0395lre patient097/s0380lre patient097/s0382lre patient097/s0384lre patient097/s0394lre '];
Pat=[Pat 'patient098/s0386lre patient098/s0389lre patient098/s0398lre patient098/s0409lre patient099/s0387lre patient099/s0388lre patient099/s0397lre patient099/s0419lre patient100/s0399lre patient100/s0401lre '];
Pat=[Pat 'patient100/s0407lre patient101/s0400lre patient101/s0410lre patient101/s0414lre patient102/s0416lre patient103/s0332lre patient104/s0306lre patient105/s0303lre patient106/s0030_re patient107/s0199_re '];
Pat=[Pat 'patient108/s0013_re patient109/s0349lre patient110/s0003_re patient111/s0203_re patient112/s0169_re patient113/s0018cre patient113/s0018lre patient114/s0012_re patient115/s0023_re patient116/s0302lre '];
Pat=[Pat 'patient117/s0291lre patient117/s0292lre patient118/s0183_re patient119/s0001_re patient120/s0331lre patient121/s0311lre patient122/s0312lre patient123/s0224_re patient125/s0006_re patient126/s0154_re '];
Pat=[Pat 'patient127/s0342lre patient127/s0383lre patient128/s0182_re patient129/s0189_re patient130/s0166_re patient131/s0273lre patient133/s0393lre patient135/s0334lre patient136/s0205_re patient137/s0392lre '];
Pat=[Pat 'patient138/s0005_re patient139/s0223_re patient140/s0019_re patient141/s0307lre patient142/s0351lre patient143/s0333lre patient144/s0341lre patient145/s0201_re patient146/s0007_re patient147/s0211_re '];
Pat=[Pat 'patient148/s0335lre patient149/s0202are patient149/s0202bre patient150/s0287lre patient151/s0206_re patient152/s0004_re patient153/s0391lre patient154/s0170_re patient155/s0301lre patient156/s0299lre '];
Pat=[Pat 'patient157/s0338lre patient158/s0294lre patient158/s0295lre patient159/s0390lre patient160/s0222_re patient162/s0193_re patient163/s0034_re patient164/s0024are patient164/s0024bre patient165/s0322lre '];
Pat=[Pat 'patient165/s0323lre patient166/s0275lre patient167/s0200_re patient168/s0032_re patient168/s0033_re patient169/s0328lre patient169/s0329lre patient170/s0274lre patient171/s0364lre patient172/s0304lre '];
Pat=[Pat 'patient173/s0305lre patient174/s0300lre patient174/s0324lre patient174/s0325lre patient175/s0009_re patient176/s0188_re patient177/s0366lre patient178/s0011_re patient179/s0176_re patient180/s0374lre '];
Pat=[Pat 'patient180/s0475_re patient180/s0476_re patient180/s0477_re patient180/s0490_re patient180/s0545_re patient180/s0561_re patient181/s0204are patient181/s0204bre patient182/s0308lre patient183/s0175_re '];
Pat=[Pat 'patient184/s0363lre patient185/s0336lre patient186/s0293lre patient187/s0207_re patient188/s0365lre patient189/s0309lre patient190/s0040_re patient190/s0041_re patient191/s0340lre patient192/s0048_re '];
Pat=[Pat 'patient193/s0008_re patient194/s0310lre patient195/s0337lre patient196/s0002_re patient197/s0350lre patient197/s0403lre patient198/s0402lre patient198/s0415lre patient199/s0404lre patient200/s0405lre '];
Pat=[Pat 'patient201/s0420_re patient201/s0423_re patient202/s0421_re patient202/s0422_re patient203/s0424_re patient204/s0425_re patient205/s0426_re patient206/s0427_re patient207/s0428_re patient208/s0429_re '];
Pat=[Pat 'patient208/s0430_re patient209/s0431_re patient210/s0432_re patient211/s0433_re patient212/s0434_re patient213/s0435_re patient214/s0436_re patient215/s0437_re patient216/s0438_re patient217/s0439_re '];
Pat=[Pat 'patient218/s0440_re patient219/s0441_re patient220/s0442_re patient221/s0443_re patient222/s0444_re patient223/s0445_re patient223/s0446_re patient224/s0447_re patient225/s0448_re patient226/s0449_re '];
Pat=[Pat 'patient227/s0450_re patient228/s0451_re patient229/s0452_re patient229/s0453_re patient230/s0454_re patient231/s0455_re patient232/s0456_re patient233/s0457_re patient233/s0458_re patient233/s0459_re '];
Pat=[Pat 'patient233/s0482_re patient233/s0483_re patient234/s0460_re patient235/s0461_re patient236/s0462_re patient236/s0463_re patient236/s0464_re patient237/s0465_re patient238/s0466_re patient239/s0467_re '];
Pat=[Pat 'patient240/s0468_re patient241/s0469_re patient241/s0470_re patient242/s0471_re patient243/s0472_re patient244/s0473_re patient245/s0474_re patient245/s0480_re patient246/s0478_re patient247/s0479_re '];
Pat=[Pat 'patient248/s0481_re patient249/s0484_re patient250/s0485_re patient251/s0486_re patient251/s0503_re patient251/s0506_re patient252/s0487_re patient253/s0488_re patient254/s0489_re patient255/s0491_re '];
Pat=[Pat 'patient256/s0492_re patient257/s0493_re patient258/s0494_re patient259/s0495_re patient260/s0496_re patient261/s0497_re patient262/s0498_re patient263/s0499_re patient264/s0500_re patient265/s0501_re '];
Pat=[Pat 'patient266/s0502_re patient267/s0504_re patient268/s0505_re patient269/s0508_re patient270/s0507_re patient271/s0509_re patient272/s0510_re patient273/s0511_re patient274/s0512_re patient275/s0513_re '];
Pat=[Pat 'patient276/s0526_re patient277/s0527_re patient278/s0528_re patient278/s0529_re patient278/s0530_re patient279/s0531_re patient279/s0532_re patient279/s0533_re patient279/s0534_re patient280/s0535_re '];
Pat=[Pat 'patient281/s0537_re patient282/s0539_re patient283/s0542_re patient284/s0543_re patient284/s0551_re patient284/s0552_re patient285/s0544_re patient286/s0546_re patient287/s0547_re patient287/s0548_re ']; 
Pat=[Pat 'patient288/s0549_re patient289/s0550_re patient290/s0553_re patient291/s0554_re patient292/s0555_re patient292/s0556_re patient293/s0557_re patient293/s0558_re patient294/s0559_re'];


cd c:\Matlab7\bin\Ivo\QT\biosig4octmat-1.68;
biosig_installer;
cd c:\Matlab7\bin\Ivo\QT\CinC2006
path2rc;

% Read the files
for i=1:549;
    i
    if i~=537;          % miss patient285/s0544_re, where no ECG-like tracings were observed
        name=Pat((i-1)*20+1 : i*20-1);
        filename=['C:\cygwin\home\Ivaylo\ptbdb\', name, '.hea'];
        [S,HDR] = phnet2matlab(filename);

        I=S(:,1);      II=S(:,2);     III=S(:,3);
        aVR=S(:,4);    aVL=S(:,5);    aVF=S(:,6);
        V1=S(:,7);     V2=S(:,8);     V3=S(:,9);
        V4=S(:,10);    V5=S(:,11);    V6=S(:,12);
        X=S(:,13);     Y=S(:,14);     Z=S(:,15);
        
        % QRS detection
        d1=II(1:4:length(II)); d2=V2(1:4:length(II));   % 1000Hz -> 250Hz
        [QRS]=QRS_det(d1,d2);
        QRS=QRS*4;                                      % 250Hz -> 1000Hz
        
        % Select beat where RR from both sides is almost equal
        clear RR1; clear RR2;
        RR1(1:length(QRS)-2)=QRS(2:length(QRS)-1)-QRS(1:length(QRS)-2);
        RR2(1:length(QRS)-2)=QRS(3:length(QRS))-QRS(2:length(QRS)-1);
        RRdif=RR2-RR1;
        RRdif=RRdif(1:20);      % take the first 20th beats
        [c1,c2]=min(abs(RRdif));
        
        QRS_best=QRS(c2+1);
        RR=(QRS(c2+2)-QRS(c2+1))/1000;      % RR [s]
        QT=.4*sqrt(RR);
%        QTc=QT/sqrt(RR);     %Bazett's correction
        QT=round(QT*1000);
        a1=300; a2=1300;
        left=QRS_best-a1;   right=QRS_best+a2;
        II=II-II(1);     % zero adjust
        II=II(left:right);
        V2=V2(left:right);
  
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
          
        % Moving averaging
        V2f(length(V2)-11:length(V2))=0;
        V2f(10:m-11)=(V2(1:m-20)+V2(2:m-19)+V2(3:m-18)+V2(4:m-17)+V2(5:m-16)+...
            V2(6:m-15)+V2(7:m-14)+V2(8:m-13)+V2(9:m-12)+V2(10:m-11)+...
            V2(11:m-10)+V2(12:m-9)+V2(13:m-8)+V2(14:m-7)+V2(15:m-6)+...
            V2(16:m-5)+V2(17:m-4)+V2(18:m-3)+V2(19:m-2)+V2(20:m-1))/20 - ...
            (V2(21:m)+V2(1:m-20))/40;
        V2f(1:9)=V2f(10);
        V2f(length(V2)-11:length(V2))=V2f(length(V2)-12);

        % Baseline wander suppression filter
	    V2f=V2f-V2f(1);
        ECG=filter(b,a,V2f);
        ECG=fliplr(ECG);
        ECG=ECG-ECG(1);
        ECG=filter(b,a,ECG);
        ECG=fliplr(ECG);
        
        % Cubic approximation
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
        V2=A;
  
        x=left+50:right-50;
        II=II(1:length(II)-51);
        V2=V2(1:length(V2)-51);

        % Max of the QRS
        QRS_best=QRS_best-x(1);
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
        Q_a(i)=Q_a(i)+x(1);
 

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
        [Mi,mi2]=min(Wing(Sis+round(QT/18):max([Q_a(i)-x(1)+round(QT-QT/8) Sis+30])));
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
        
        %   ---- Check the amplitude of the T wave
        if abs(Tampl)>0.040; Tamp(i)=0;
        else Tamp(i)=1; disp('low ampl') % very low amplitude ?
            
            clear Wing
            s=40;           % 40 ms
            Wing(s:length(V2)-s)=(V2(1:length(V2)-2*s+1)-V2(s:length(V2)-s)).*(V2(s:length(V2)-s)-V2(2*s:length(V2)));
            Wing=Wing(s:length(Wing));

            %	----	Find Tpeak (the min of the 'wing')
            [Mi,Tp]=min(Wing(Sis+round(QT/18):Q_a(i)-x(1)+round(QT-QT/8)));
            Tp=Tp+Sis+round(QT/18)+s-1;

            %	----	Find the steepest slope right from the Tpeak
            [Mi2 mi2]=max(Wing(Tp-s:Tp-s+round(QT/5)));
            Tth=Tp+mi2;

           % Find the inflection point of the T wave
           [Mi2 mi2]=min(Wing(Tth-s:Tth-s+round((QT/5))));
           Tis=Tth+mi2;
       
            %	----	Set a trash hold value = 80% of the amplitude
            Tampl=V2(Tp)-V2(Tis);
            for ii=Tth:Tis;
                if abs(V2(Tp)-V2(ii))>abs(Tampl)*8/10; Ts=ii; break; end;
            end

           % Tangent
            clear angT1; clear angT2;
            s1=10;
            Tis=Tis+s1;     % Tis to be considered
            for j=Ts:Tis;
                angT1(j)=atan((V2(j+s1)-V2(j))*250/s1)*180/pi;	%bigger-less
                angT2(j)=atan((V2(j)-V2(j-s1))*250/s1)*180/pi;	%bigger-less
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
        end
        Tend(i)=T_end+x(1);
                

    end     % if i~=537;

end

save c:\Matlab7\bin\Ivo\QT\CinC2006_2\QT Q_mean Q_a Tend T_mean Pat Tamp
