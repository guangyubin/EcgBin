
function [avg_ecg]= ecg_avg_epoch(ecg,pos,ileft,iright)

m = 1;
for ii = 1:length(pos)
    if pos(ii)-ileft >0 && pos(ii)+iright <= length(ecg)
        x(m,:) = ecg(pos(ii)-ileft:pos(ii)+iright);
        m = m +1;
    end
end
avg_ecg = mean(x,1);

