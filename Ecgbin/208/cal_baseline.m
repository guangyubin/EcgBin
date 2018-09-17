function basel = cal_baseline(X,P2,QRS1,Fs)

nqui=round(15e-3*Fs);
ntre=round(30e-3*Fs);
ntre_q=round(10e-3*Fs);
nqui_q=round(5e-3*Fs);
if ~isempty(P2)
    if (QRS1-P2)/Fs>33e-3
        Xaux=X(P2+nqui:QRS1-nqui);
        basel=sum(Xaux)/length(Xaux);
    else if (QRS1==P2)
            basel=X(QRS1);
        else Xaux=X(P2:QRS1);
            basel=sum(Xaux)/length(Xaux);
        end
    end
else
    Xaux=X(QRS1-ntre_q-nqui_q:QRS1-nqui_q);
    basel=sum(Xaux)/length(Xaux);
end