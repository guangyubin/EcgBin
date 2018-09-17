% Descript�� ���PQRST����λ�úͷ���
% Input: 
%  X : ecg signal in mv
%  iqrs: position of R 
%  Fs : sample rate
% Output:
%  POS: position of PQRST
%  AMP: ampliture of PQRST
%  VAL_QT: QT����
%  VAL_QTC�� У�����QT����
%  VAL_QRS�� QRS����
%  AMP_Q�� Q����
%  AMP_R �� R������
%  AMP_S�� S������
%Anthor
%   guangyubin@bjut.edu.cm
%   2017.6.18 

function [POS,AMP,VAL_QT,VAL_QTC,VAL_QRS,AMP_Q,AMP_R,AMP_S,QRSType]=bin_PQRSTdetect1(X,iqrs,Fs,fig)
if nargin < 4
    fig = 0 ;
end;


nqrs = length(iqrs);
 [Xpa,Xpb,D,F,Der]=bin_lynfilt(X,Fs);
%  iqrs= rpeak_correction(Xpa,iqrs,Fs);
% ---- Identification of wave limits and amplitudes ----

Kq=1.5;
Kr=5;
Ks=3;
Krr=5;
Kpb=1.35;
Kpe=2;
Ktb=2;
Kte=3.5;
pco=8;
ns=length(X);
iprimerqrs = 1;
ti = 0;

prewindt = 1;
% ---- Initialization of RR interval ----

if nqrs > 1
    RRm=(iqrs(nqrs)-iqrs(1))/(nqrs-1);
else
   RRm = Fs*0.6;
end

% ---- Initializations ----
ipbeg=zeros(1,nqrs);
ippos=zeros(1,nqrs);
ipend=zeros(1,nqrs);
iqbeg=zeros(1,nqrs);
iqpos=zeros(1,nqrs);
iqend=zeros(1,nqrs);
irpos=zeros(1,nqrs);
ir2pos=zeros(1,nqrs);
isbeg=zeros(1,nqrs);
ispos=zeros(1,nqrs);
isend=zeros(1,nqrs);
itbeg=zeros(1,nqrs);
itpos=zeros(1,nqrs);
it2pos=zeros(1,nqrs);
itend=zeros(1,nqrs);
Qamp=zeros(1,nqrs);
Ramp=zeros(1,nqrs);
Samp=zeros(1,nqrs);
if length(iqrs) > 1
    iRR=diff(iqrs);
    iRR(length(iqrs)) = iRR(end-1);
else
    iRR = Fs;
end;

POS.Ponset(1:nqrs)=NaN;
POS.P(1:nqrs)=NaN;
POS.Poffset(1:nqrs)=NaN;
POS.QRSonset(1:nqrs)=NaN;
POS.Q(1:nqrs)=NaN;
POS.R(1:nqrs)=NaN;
POS.fiducial(1:nqrs)=NaN;
POS.S(1:nqrs)=NaN;
POS.R2(1:nqrs)=NaN;
POS.QRSoffset(1:nqrs)=NaN;
POS.Tonset(1:nqrs)=NaN;
POS.T(1:nqrs)=NaN;
POS.T2(1:nqrs)=NaN;
POS.Toffset(1:nqrs)=NaN;

AMP.P(1:nqrs)=NaN;
AMP.Q(1:nqrs)=NaN;
AMP.R(1:nqrs)=NaN;
AMP.S(1:nqrs)=NaN;
AMP.R2(1:nqrs)=NaN;
AMP.T(1:nqrs)=NaN;
AMP.T2(1:nqrs)=NaN;

POS_QT=zeros(nqrs,1);
VAL_QT=zeros(nqrs,1);
VAL_QTC=zeros(nqrs,1);

POS_QRS=zeros(nqrs,1);
VAL_QRS=zeros(nqrs,1);

n=1;
a=1;
q=1;

% ---- Beat processing loop ----
while n<= nqrs %&& (ns-iqrs(n))/Fs>0.5
    if n>=iprimerqrs && n<=nqrs
        basel=0;
        
        % ---- Analysis window ----
        bwind=max(iqrs(n)-round(RRm),iqrs(n)-round(Fs));
        if bwind<0 bwind=0; end
        if n<nqrs
            ewind=max(iqrs(n)+round(RRm),iqrs(n+1));
        else ewind=min(iqrs(n)+round(RRm),ns);
        end
        if ewind>length(X)
            ewind=length(X);
        end
        PKni=iqrs(n)-bwind;
        if n<nqrs PKnii=iqrs(n+1)-bwind;
        else PKnii=0;
        end
        if n>=iprimerqrs+1 
            prevt=itend(n-1)-bwind;
        else
            prevt=prewindt-ti-bwind;
        end
        if prevt<=0
            prevt=0; 
        end
        
        
        % ---- Detection of QRS complex position and limits ----
        [QRS1,Qp,Rp,Sp,R2p,QRS2,dermax,Rtype,Sgran]=qrsbound(n,X(bwind+1:ewind),Xpb(bwind+1:ewind),D(bwind+1:ewind),Der(bwind+1:ewind),PKni,prevt,Fs,Kq,Kr,Ks,Krr);
        if ~isempty(QRS1) 
            iqbeg(n)=bwind+QRS1;
        else
                n=n+1;
            continue;
        end;
        if ~isempty(Qp) iqpos(n)=bwind+Qp; end
        if ~isempty(Rp) irpos(n)=bwind+Rp; end
        if ~isempty(Sp) ispos(n)=bwind+Sp; end
        if ~isempty(R2p) ir2pos(n)=bwind+R2p; end
        if ~isempty(QRS2) isend(n)=bwind+QRS2; end
        
        
        % ---- P wave detection ----
        [P1,Pp,P2,Ptype]=pbound(n,X(bwind+1:ewind),Xpb(bwind+1:ewind),...
            F(bwind+1:ewind),PKni,Rp,QRS1,prevt,dermax,Fs,Kpb,Kpe);
        if ~isempty(P1) ipbeg(n)=bwind+P1; end
        if ~isempty(Pp) ippos(n)=bwind+Pp; end
        if ~isempty(P2) ipend(n)=bwind+P2; end
        
        % ---- Baseline estimation ----
        nqui=round(15e-3*Fs);
        ntre=round(30e-3*Fs);
        ntre_q=round(10e-3*Fs);
        nqui_q=round(5e-3*Fs);
        if ~isempty(P2)
            if (QRS1-P2)/Fs>33e-3
                Xaux=X(ipend(n)+nqui:iqbeg(n)-nqui);
                basel=sum(Xaux)/length(Xaux);
            else if (QRS1==P2)
                    basel=X(iqbeg(n));
                else Xaux=X(ipend(n):iqbeg(n));
                    basel=sum(Xaux)/length(Xaux);
                end
            end
        else
            a = max(iqbeg(n)-ntre_q-nqui_q,1);
            b = max(iqbeg(n)-nqui_q,1);
            
            Xaux=X(a:b);
            basel=sum(Xaux)/length(Xaux);
        end
        
        % ---- Q and S wave offset ----
        if ~isempty(Qp) & (Rtype==1|Rtype==3)
            if X(irpos(n))>0
                Xaux=X(iqpos(n):isend(n));
                Q2=thresholdcross(Xaux,basel);
                if isempty(Q2) iqend(n)=irpos(n);
                else iqend(n)=iqpos(n)+Q2-1;
                end
            else iqend(n)=irpos(n);
            end
        end
        if ~isempty(Sp) & (Rtype==1|Rtype==3)
            if X(irpos(n))>0
                Xaux=flipud(X(iqbeg(n):ispos(n)));
                S1=thresholdcross(Xaux,basel);
                if isempty(S1) isbeg(n)=irpos(n);
                else isbeg(n)=Sp-S1+1;
                end
            else isbeg(n)=irpos(n);
            end
        end
        
        % ---- Mean RR interval ----
        RRm=calcrr(RRm,n,Fs,iqrs);
        
        % ---- T wave location and limits ----
        [T1,Tp2,Tp,T2,Ttype]=tbound(n,X(bwind+1:ewind),Xpa(bwind+1:ewind),F(bwind+1:ewind),PKni,Rp,QRS1,QRS2,PKnii,dermax,basel,RRm,Fs,Ktb,Kte,pco);
        
        if ~isempty(T1) itbeg(n)=bwind+T1; end
        if ~isempty(Tp2) it2pos(n)=bwind+Tp2; end
        if ~isempty(Tp) itpos(n)=bwind+Tp; end
        if ~isempty(T2) itend(n)=bwind+T2; end
        
        QRSType(n) = Rtype;
        % ---- Q, R, S and R' wave amplitudes ----
        if (irpos(n)~=0 & Rtype~=4)
            irpos(n)=testpeak(X,irpos(n),Fs,1); %JGM
        elseif (irpos(n)~=0 & Rtype==4)
            irpos(n)=testpeak(X,irpos(n),Fs,0); %JGM
        end
        if ispos(n)~=0
            ispos(n)=testpeak(X,ispos(n),Fs,0); %JGM
        end
        if ir2pos(n)~=0
            ir2pos(n)=testpeak(X,ir2pos(n),Fs,1); %JGM
        end
        
        if ~isempty(Qp)
            Qamp(n)=X(iqpos(n))-basel;
            AMP.Q(n)=Qamp(n);
        end
        if ~isempty(Rp)
            Ramp(n)=X(irpos(n))-basel;
            AMP.R(n)=Ramp(n);
        end
        if ~isempty(Sp)&Rtype~=4
            Samp(n)=X(ispos(n))-basel;
            AMP.S(n)=Samp(n);
        end
        if ~isempty(R2p)
            R2amp(n)=X(ir2pos(n))-basel;
            AMP.R2(n)=R2amp(n);
        end
        
        % ---- P and T wave amplitudes ----
        if ~isempty(Pp)
            AMP.P(n)=X(ippos(n))-basel;
        end
        if ~isempty(Tp2)
            AMP.T2(n)=X(it2pos(n))-basel;
        end
        if ~isempty(Tp)
            AMP.T(n)=X(itpos(n))-basel;
        end
        
        % ---- Saving results ----
        if ipbeg(n)~=0
%             if res==1 
%                 tm=(ipbeg(n)+ti)/1000;
%                 ms=(tm-floor(tm))*1000; ms=round(ms);
%                 s=floor(tm); m=floor(s/60); s=rem(s,60);
%                 fprintf(fid,'   %2d:%02d.%03d     %d     (    0    %d    %d\n',m,s,ms,ipbeg(n)+ti,nl-1,0);
%             end
%             POS_ANNOT(a)=ipbeg(n)+ti;
%             ANNOT(a)='(';
%             SUBTYPEFIELD(a)=0;
%             CHANFIELD(a)=nl-1;
%             NUMFIELD(a)=0; a=a+1;
            POS.Ponset(n)=ipbeg(n)+ti;
        end
        
        if ippos(n)~=0
%             if res==1 tm=(ippos(n)+ti)/1000;
%                 ms=(tm-floor(tm))*1000; ms=round(ms);
%                 s=floor(tm); m=floor(s/60); s=rem(s,60);
%                 fprintf(fid,'   %2d:%02d.%03d     %d     p    0    %d    %d\n',m,s,ms,ippos(n)+ti,nl-1,Ptype);
%             end
%             POS_ANNOT(a)=ippos(n)+ti;
%             ANNOT(a)='p';
%             SUBTYPEFIELD(a)=0;
%             CHANFIELD(a)=nl-1;
%             NUMFIELD(a)=0; a=a+1;
            POS.P(n)=ippos(n)+ti;
        end
        
        if ipend(n)~=0
%             if res==1 tm=(ipend(n)+ti)/1000;
%                 ms=(tm-floor(tm))*1000; ms=round(ms);
%                 s=floor(tm); m=floor(s/60); s=rem(s,60);
%                 fprintf(fid,'   %2d:%02d.%03d     %d     )    0    %d    %d\n',m,s,ms,ipend(n)+ti,nl-1,0);
%             end
%             POS_ANNOT(a)=ipend(n)+ti;
%             ANNOT(a)=')';
%             SUBTYPEFIELD(a)=0;
%             CHANFIELD(a)=nl-1;
%             NUMFIELD(a)=0; a=a+1;
            POS.Poffset(n)=ipend(n)+ti;
        end
        
        if iqbeg(n)~=0
%             if res==1 tm=(iqbeg(n)+ti)/1000;
%                 ms=(tm-floor(tm))*1000; ms=round(ms);
%                 s=floor(tm); m=floor(s/60); s=rem(s,60);
%                 fprintf(fid,'   %2d:%02d.%03d     %d     (    0    %d    %d\n',m,s,ms,iqbeg(n)+ti,nl-1,1);
%             end
%             POS_ANNOT(a)=iqbeg(n)+ti;
%             ANNOT(a)='(';
%             SUBTYPEFIELD(a)=0;
%             CHANFIELD(a)=nl-1;
%             NUMFIELD(a)=1; a=a+1;
            POS.QRSonset(n)=iqbeg(n)+ti;
        end
        
        if iqrs(n)~=0
%             an=atyp(n);
%             if res==1 tm=(iqrs(n)+ti)/1000;
%                 ms=(tm-floor(tm))*1000; ms=round(ms);
%                 s=floor(tm); m=floor(s/60); s=rem(s,60);
%                 fprintf(fid,'   %2d:%02d.%03d     %d     %c    0    %d    %d\n',m,s,ms,iqrs(n)+ti,an,nl-1,0);
%             end
%             POS_ANNOT(a)=iqrs(n)+ti;
%             ANNOT(a)=an;
%             SUBTYPEFIELD(a)=0;
%             CHANFIELD(a)=nl-1;
%             NUMFIELD(a)=0; a=a+1;
            POS.fiducial(n)=iqrs(n)+ti;
        end
        
        
        if iqpos(n)~=0
%             POS_ANNOT(a)=iqpos(n)+ti;
%             ANNOT(a)='Q';
%             SUBTYPEFIELD(a)=0;
%             CHANFIELD(a)=nl-1;
%             NUMFIELD(a)=0; a=a+1;
            POS.Q(n)=iqpos(n)+ti;
        end
        
        if irpos(n)~=0
%             POS_ANNOT(a)=irpos(n)+ti;
%             if Rtype==4
%                 ANNOT(a)='S';
%             else ANNOT(a)='R'; end
%             SUBTYPEFIELD(a)=0;
%             CHANFIELD(a)=nl-1;
%             NUMFIELD(a)=0; a=a+1;
            POS.R(n)=irpos(n)+ti;
        end
        
        if ispos(n)~=0
%             POS_ANNOT(a)=ispos(n)+ti;
%             ANNOT(a)='S';
%             SUBTYPEFIELD(a)=0;
%             CHANFIELD(a)=nl-1;
%             NUMFIELD(a)=0; a=a+1;
            POS.S(n)=ispos(n)+ti;
        end
        
        if ir2pos(n)~=0
%             POS_ANNOT(a)=ir2pos(n)+ti;
%             ANNOT(a)='R';
%             SUBTYPEFIELD(a)=0;
%             CHANFIELD(a)=nl-1;
%             NUMFIELD(a)=0; a=a+1;
            POS.R2(n)=ir2pos(n)+ti;
        end
        
        if isend(n)~=0
%             if res==1 tm=(isend(n)+ti)/1000;
%                 ms=(tm-floor(tm))*1000; ms=round(ms);
%                 s=floor(tm); m=floor(s/60); s=rem(s,60);
%                 fprintf(fid,'   %2d:%02d.%03d     %d     )    0    %d    %d\n',m,s,ms,isend(n)+ti,nl-1,1);
%             end
%             POS_ANNOT(a)=isend(n)+ti;
%             ANNOT(a)=')';
%             SUBTYPEFIELD(a)=0;
%             CHANFIELD(a)=nl-1;
%             NUMFIELD(a)=1; a=a+1;
            POS_QRS(n)=iqrs(n)+ti;
            VAL_QRS(n)=isend(n)-iqbeg(n);
            POS.QRSoffset(n)=isend(n)+ti;
        end
        
        if itbeg(n)~=0
%             if res==1 tm=(itbeg(n)+ti)/1000;
%                 ms=(tm-floor(tm))*1000; ms=round(ms);
%                 s=floor(tm); m=floor(s/60); s=rem(s,60);
%                 fprintf(fid,'   %2d:%02d.%03d     %d     (    0    %d    %d\n',m,s,ms,itbeg(n)+ti,nl-1,2);
%             end
%             POS_ANNOT(a)=itbeg(n)+ti;
%             ANNOT(a)='(';
%             SUBTYPEFIELD(a)=0;
%             CHANFIELD(a)=nl-1;
%             NUMFIELD(a)=2; a=a+1;
            POS.Tonset(n)=itbeg(n)+ti;
        end
        
        if it2pos(n)~=0
%             if res==1 tm=(it2pos(n)+ti)/1000;
%                 ms=(tm-floor(tm))*1000; ms=round(ms);
%                 s=floor(tm); m=floor(s/60); s=rem(s,60);
%                 fprintf(fid,'   %2d:%02d.%03d     %d     t    0    %d    %d\n',m,s,ms,it2pos(n)+ti,nl-1,Ttype);
%             end
%             POS_ANNOT(a)=it2pos(n)+ti;
%             ANNOT(a)='t';
%             SUBTYPEFIELD(a)=0;
%             CHANFIELD(a)=nl-1;
%             NUMFIELD(a)=Ttype; a=a+1;
            POS.T2(n)=it2pos(n)+ti;
        end
        
        if itpos(n)~=0
%             if res==1 tm=(itpos(n)+ti)/1000;
%                 ms=(tm-floor(tm))*1000; ms=round(ms);
%                 s=floor(tm); m=floor(s/60); s=rem(s,60);
%                 fprintf(fid,'   %2d:%02d.%03d     %d     t    0    %d    %d\n',m,s,ms,itpos(n)+ti,nl-1,Ttype);
%             end
%             POS_ANNOT(a)=itpos(n)+ti;
%             ANNOT(a)='t';
%             SUBTYPEFIELD(a)=0;
%             CHANFIELD(a)=nl-1;
%             NUMFIELD(a)=Ttype; a=a+1;
            POS.T(n)=itpos(n)+ti;
        end
        
        if itend(n)~=0
%             if res==1 tm=(itend(n)+ti)/1000;
%                 ms=(tm-floor(tm))*1000; ms=round(ms);
%                 s=floor(tm); m=floor(s/60); s=rem(s,60);
%                 fprintf(fid,'   %2d:%02d.%03d     %d     )    0    %d    %d\n',m,s,ms,itend(n)+ti,nl-1,2);
%             end
%             POS_ANNOT(a)=itend(n)+ti;
%             ANNOT(a)=')';
%             SUBTYPEFIELD(a)=0;
%             CHANFIELD(a)=nl-1;
%             NUMFIELD(a)=2; a=a+1;
%             prewindt=itend(n)+ti;
            POS.Toffset(n)=itend(n)+ti;
            
            % ---- QT interval ----
            VAL_QT(q)=itend(n)-iqbeg(n);
            POS_QT(q)=iqrs(n)+ti;
            iRRc(q)=iRR(n)/Fs;
            q=q+1;
        end
        
        
    end
    n=n+1;
end

% I=find(POS_ANNOT~=0);
% if ~isempty(I)
%     POS_ANNOT=POS_ANNOT(I);
%     ANNOT=ANNOT(I);
%     NUMFIELD=NUMFIELD(I);
%     SUBTYPEFIELD=SUBTYPEFIELD(I);
%     CHANFIELD=CHANFIELD(I);
% else POS_ANNOT=[];
%     ANNOT=[];
%     NUMFIELD=[];
%     SUBTYPEFIELD=[];
%     CHANFIELD=[];
% end


I=find(VAL_QT~=0);
if ~isempty(I)
    VAL_QT=VAL_QT(I);
    POS_QT=POS_QT(I);
    VAL_QTC=VAL_QTC(I);
    iRRc=iRRc(I);
    VAL_QT=(VAL_QT./Fs)*1000;  % Value in ms.
    POS_QT=POS_QT./Fs;
    VAL_QTC=VAL_QT./(sqrt(iRRc))';
else VAL_QT=[];
    POS_QT=[];
    VAL_QTC=[];
end

I=find(VAL_QRS~=0);
if ~isempty(I)
    VAL_QRS=VAL_QRS(I);
    POS_QRS=POS_QRS(I);
    POS_QRS=POS_QRS./Fs;
    VAL_QRS=(VAL_QRS./Fs)*1000; % Value in ms.
else VAL_QT=[];
    POS_QRS=[];
end

I=find(Qamp~=0);
if ~isempty(I)
    AMP_Q=Qamp(I)';
    POS_Q=((iqpos(I)+ti)./Fs)';
else AMP_Q=[]; POS_Q=[];
end

I=find(Ramp~=0);
if ~isempty(I)
    if Rtype~=4
        AMP_R=Ramp(I)';
        POS_R=((irpos(I)+ti)./Fs)';
        Is=find(Samp~=0);
        if ~isempty(Is)
            AMP_S=Samp(Is)';
            POS_S=((ispos(Is)+ti)./Fs)';
        else AMP_S=[]; POS_S=[];
        end
    else AMP_S=Ramp(I)';
        POS_S=((irpos(I)+ti)./Fs)';
        AMP_Q=[]; POS_Q=[];
        AMP_R=[]; POS_R=[];
    end
else
    AMP_S=[]; POS_S=[];
    AMP_R=[]; POS_R=[];
end
if fig==1
    P = POS.P(~isnan(POS.P));
Q1 = POS.QRSonset(~isnan(POS.QRSonset));
Q2 = POS.QRSoffset(~isnan(POS.QRSoffset));
R = POS.R(~isnan(POS.R));
T = POS.T(~isnan(POS.T));
 plot(X); hold on;;
plot(Q1,X(Q1),'.k');plot(R,X(R),'*r');plot(Q2,X(Q2),'.k');
try
plot(P,X(P),'o');plot(POS.T,X(POS.T),'*');
end
  hold off;
end