
function [r1,r2] = ecg_corrceof_epoch(ecg,avg_ecg,pos,ileft,iright)

avg_ecg = avg_ecg - mean(avg_ecg);

dx = max(avg_ecg)-min(avg_ecg);
r1 = zeros(1,length(pos));
r2 = zeros(1,length(pos));
for ii = 1:length(pos)
    if pos(ii)-ileft >0 && pos(ii)+iright <= length(ecg)
        x = ecg(pos(ii)-ileft:pos(ii)+iright);

        x = x - mean(x);
        if ii == 10
            a = 0;
        end;
        r2(ii) = 1-max(abs(x' - avg_ecg))/dx;
       p = corrcoef(x,avg_ecg);
       r1(ii) =  p(1,2);
    end
end