function [ RRrnew ] = smg_calc_RRr( RR )

rrlength = length(RR);
RRrnew = [];
count=1;
errcount=0;
for ii = 2:rrlength
    if RR(ii) >0 && RR(ii-1) >0   
        RRrnew(count) = RR(ii)/RR(ii-1);
        count=count+1;
    else
        errcount = errcount+1;
    end
end

if size(RRrnew)==0
    RRrnew = [1];
end

end

