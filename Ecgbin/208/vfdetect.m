function bVF = vfdetect(rpos,ramp)
mmramp = median(ramp);
mmrr = median(diff(rpos));
kk = 0 ;
bVF = zeros(1,length(rpos)) ;
istart = 1;
iend = 1;
bVFstart = 0 ;
for ii = 2:length(rpos)
    if ramp(ii) > 2*mmramp && rpos(ii) - rpos(ii-1) < 0.7*mmrr&& rpos(ii) - rpos(ii-1) > 0.3*mmrr
        if bVFstart == 0
            bVFstart = 1;
            istart = ii;
        else
            iend = ii;
        end         
    else
        if bVFstart == 1
            bVFstart = 0 ;
            if iend - istart >=3 
                bVF(istart:iend) = 1;
            end
        end;    
    end;
end;
bVF = ~isempty(find(bVF ==1));
