function plot_ecg_beat_type(ecg,rpos,type)


plot(ecg);
hold on;plot(rpos,ecg(rpos),'.');
for kk = 1:length(type)
    if type(kk)~=1
        clr = 'red';
    else
        clr = 'black';
    end;
    text(rpos(kk),ecg(rpos(kk)),num2str(type(kk)),'Color',clr);
end;
hold off;