%Determine peak position of QRS.
function  iqrs= rpeak_correction(Xpa,ta,Fs)

n=1;
nqrs=0;
iqrs = ta;
for i=1:length(ta)
    ibe=max(1,ta(i)-round(0.2*Fs));
    ien=ta(i)+round(0.17*Fs);
    if ien<=length(Xpa)
        [ymax,imax]=max(Xpa(ibe:ien)); imax=ibe+imax-1;
        [ymin,imin]=min(Xpa(ibe:ien)); imin=ibe+imin-1;
        %if abs(ymin)>abs(ymax)
        if abs(ymin)>1.3*abs(ymax)  %JGM
            iqrs(n)=imin;
        else
            iqrs(n)=imax;
        end
        nqrs=nqrs+1;
        n=n+1;
    end
    
end
   