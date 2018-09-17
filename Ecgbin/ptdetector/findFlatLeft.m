% II ecg data in mV
% Flat  Flat segement length in sample point
% Crit  The cirt of Flat
% ma    start position
% LAT1   Left duration
function Qflat = findFlatLeft(II,fs,Flat,Crit,ma, LAT1,direction)

% Flat= floor(0.020*fs);        % 20 ms
% LAT1 = floor(0.15*fs);
% Crit=0.02*QRSampl;     % mV
if strcmp(direction,'right')
    From=ma+Flat; To= From + LAT1 ; %min([From-LAT1+Flat, 2+Flat]);
%     Flat=floor(0.02*fs);        % 20 ms
%     Crit=0.02*QRSampl;     % mV
%     From=ma+Flat; To=From+floor(0.15*fs);
    Pnt=0; a=0;
    while Pnt==0;
        if a<2;
            a=a+1; 			%increase a
        else
            Crit=Crit+0.001;	%increase Crit with 1 uV
        end
        
        for ii=From:To;
            d(1:Flat)=II(ii:ii+Flat-1)-II(ii+1:ii+Flat);
            if max(abs(d)) < Crit &&...
                    abs(II(ii)-II(ii+Flat+1)) < 4*a*Crit &&...
                    abs(II(ii)-II(ii+floor(Flat/2))) < 3*a*Crit &&...
                    abs(II(ii+Flat)-II(ii+floor(Flat/2))) < 3*a*Crit &&...
                    abs(II(ii))<0.2+Crit;
                Pnt=ii; break
            end
        end
    end
    Qflat=Pnt+Flat;
end
if strcmp(direction,'left')
    From=ma-Flat; To=max([From-LAT1+Flat, 2+Flat]);
    Pnt=0; a=0;
    nloop = 0;
    while Pnt==0;
        if a<=2;
            a=a+1; 			%increase a
        else
            Crit=Crit+0.001;	%increase Crit with 1 uV
%             Crit=Crit+1 ;
        end
        
        for ii=From:-1:To;
            
            d(1:Flat)=II(ii:-1:ii-Flat+1)-II(ii-1:-1:ii-Flat);
            if ...
                    max(abs(d)) < Crit &&...
                    abs(II(ii)-II(ii-Flat-1)) < 4*a*Crit &&...
                    abs(II(ii)-II(ii-floor(Flat/2))) < 3*a*Crit &&...
                    abs(II(ii-Flat)-II(ii-floor(Flat/2))) < 3*a*Crit &&... 
                        (II(ii))< 0.1+Crit;
%                      abs(II(ii) - II(ma))> Crit*8 
%                 

                Pnt=ii; break
            end
        end
        nloop = nloop+1;
    end
    Qflat=Pnt-Flat;
end;


