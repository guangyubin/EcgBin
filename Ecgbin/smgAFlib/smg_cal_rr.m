function [rr] = smg_cal_rr(rpos)

rr= [];
for ii = 2:length(rpos)
    if rpos(ii)>0 && rpos(ii-1)>0
        rr = [rr, rpos(ii) - rpos(ii-1)];        
    else
        rr = [rr, 0];
    end
end;
