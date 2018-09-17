function [Xpa,Xpb,D,F,Der]=bin_lynfilt(x,Fs)

ns = length(x);

Der = Deriv(x,Fs);
Der = 10 * Der / max(abs(Der));

[b ,a] = butter(2,0.1/Fs,'high');
Xpa = filtfilt(b,a,x);
Xpa = 10*Xpa/max(abs(Xpa));

Xpb = filtlp(Xpa,60,Fs);
Xpb = 10*Xpb/max(abs(Xpb));

D = Deriv(Xpb,Fs);
D = 10*D/max(abs(D));


Xpf = filtlp(Xpb,60,Fs);

F= Deriv(Xpf,Fs);
F =10* F/max(abs(F));

% 无相移差分
function  Der = Deriv(x,Fs)
ns = length(x);
Der = filter([1,2,0,-2,-1],1,x);
Der(3)=Fs*(x(2)-x(1));
Der(4)=(Fs/4)*(2*x(3)-2*x(1));
T = 2;
Der(1:ns-(T))=Der(T+1:ns);
Der(ns-(T-1):ns)=zeros(T,1);
% 无相移高通滤波器
function  y = filtlp(x,nb,Fs)
ns = length(x);
mpb=round(Fs/nb);
Bpb=zeros(1,2*mpb+1); Bpb(1)=1; Bpb(mpb+1)=-2; Bpb(2*mpb+1)=1;
Apb=[1,-2,1];
y=filter(Bpb,Apb,x);
Tpb=(mpb-1);T=Tpb+1;                     
y(1:ns-(T))=y(T+1:ns);
y(ns-(T-1):ns)=zeros(T,1);


