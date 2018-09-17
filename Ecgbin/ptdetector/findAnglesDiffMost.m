function Q_a = findAnglesDiffMost(II,fs,s,Qflat,Qsl)
%	---- Find QRS onset when two concecutive angles differ most
% clear angQ1; clear angQ2; clear Q;
if Qflat+s>=Qsl-s;
    Qflat=Qflat-s; 
end
Q_a = Qflat;
if Qflat+s<Qsl-s
    for j=Qflat+s:Qsl-s;
        angQ1(j)=atan((II(j+s)-II(j))*fs/s)*180/pi;	%bigger-less
        angQ2(j)=atan((II(j)-II(j-s))*fs/s)*180/pi;	%bigger-less
    end;

    
    angQ=angQ1-angQ2;
    angQ=angQ(Qflat+s:length(angQ));
    [Max1,Q_a]=max(abs(angQ));            % Automatic Q onset
    Q_a=Q_a+(Qflat+s);
end
