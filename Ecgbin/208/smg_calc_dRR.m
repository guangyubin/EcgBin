function [ dRRnew ] = smg_calc_dRR( RR, meanRR )

rrlength = length(RR);

count=1;
errcount=0;
for ii = 2:rrlength
    if RR(ii) < 1.8*meanRR && RR(ii-1) < 1.8*meanRR   
        dRRnew(count) = RR(ii)-RR(ii-1);
        count=count+1;
    else
        errcount = errcount+1;
    end
end

if size(dRRnew)==0
    dRRnew = [0];
end

end

