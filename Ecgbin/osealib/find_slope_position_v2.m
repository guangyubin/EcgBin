function  [onset, offset] = find_slope_position_v2(x, findmark,fs)
% dx = abs(dx);
% maxSlope = abs(maxSlope);
dx = diff(x);
[maxSlope ,maxSlopeI] = max_pos(dx,findmark -0.1*fs,findmark +0.1*fs);
[minSlope ,minSlopeI]= min_pos(dx,findmark -0.1*fs,findmark +0.1*fs);

if maxSlope > -minSlope 
    maxSlope = -minSlope;
else
    minSlope = -maxSlope;
end;  

INF_CHK_N = 0.04*fs;
if maxSlopeI < minSlopeI
    ii = maxSlopeI;
    % find first dx < maxslope/4
    while ii > 1  && x(ii) - x(ii-1) > maxSlope/4
        ii = ii-1;
    end;
    onset = ii-1;    
     % 往前看，是否有dx> maxslope/4
    while(ii > onset - 0.04*fs &&  x(ii) - x(ii-1)  <  maxSlope/4)
        ii = ii - 1;
    end;
    % 如果有dx > maxslope/4
    if ii > onset - 0.04*fs
        % 继续搜索
        while ii > 1 &&  x(ii) - x(ii-1) > maxSlope/4
            ii = ii-1;
        end
        onset = ii - 1;
    end
    ii = onset+1;
    % check to see if a large negtive slope
    while(ii > onset - 0.04*fs && x(ii-1) - x(ii)< maxSlope/4)
        ii = ii -1;
    end;
    if ii > onset - 0.04*fs

        while ii > 1 && x(ii-1) - x(ii) > maxSlope/4
            ii = ii-1;
        end
        onset = ii - 1;
    end
 %  
    ii = minSlopeI;
    while ii < length(x)&& x(ii) - x(ii-1) < minSlope/4
        ii = ii+1;
    end
    offset = ii;
    while ii < offset + INF_CHK_N && x(ii) - x(ii-1) > minSlope/4 
        ii = ii +1;
    end
    if ii < offset + INF_CHK_N
        while ii<length(x) && x(ii)-x(ii-1) < minSlope/4
            ii = ii +1;
        end
        offset = ii;
    end
    ii = offset;
    while ii < offset + INF_CHK_N  && x(ii-1) - x(ii) > minSlope/4
        ii = ii+1;
    end
    if ii < offset+INF_CHK_N
        while ii < length(x) && x(ii-1)-x(ii) < minSlope/4
            ii = ii +1;
        end
        offset = ii;
        while ii < offset +0.06*fs && x(ii) - x(ii-1) > minSlope/4
            ii = ii +1;
        end;
        if ii < offset +0.06*fs
            while ii < length(x) && x(ii) - x(ii-1) < minSlope/4
                ii = ii+1;
            end
            offset = ii;
        end
    end
else
    ii = minSlopeI;
    while ii > 1 && x(ii) - x(ii-1) < minSlope/4
        ii = ii -1;
    end
    onset = ii ;
    while ii > onset - INF_CHK_N && x(ii) - x(ii-1) >= minSlope/4
        ii = ii -1;
    end
    if ii > onset - INF_CHK_N
        while ii > 1 && x(ii) - x(ii-1) < minSlope/4
            ii = ii-1;
        end
        onset = ii;
    end
    ii = onset;
    while ii > onset - INF_CHK_N && x(ii-1) - x(ii) > minSlope/4
        ii = ii -1;
    end
    if ii > onset - INF_CHK_N
        while ii > 1 && x(ii-1) - x(ii) < minSlope/4
            ii = ii-1;
        end
        onset = ii;
    end
    ii = maxSlopeI;
    while ii < length(x) && x(ii) - x(ii-1) > maxSlope/4
        ii = ii+1;
    end
    offset = ii;
    while ii < offset+INF_CHK_N && x(ii)- x(ii-1) <= maxSlope/4
        ii = ii+1;
    end
    if ii < offset + INF_CHK_N
        while ii < length(x) && x(ii) - x(ii-1) > maxSlope/4
            ii = ii+1;
        end
        offset = ii;
    end
    ii = offset;
    while ii < offset+0.04*fs && x(ii-1) - x(ii) < maxSlope/4
        ii = ii+1;
    end
    if ii < offset +0.04*fs
        while ii < length(x) && x(ii-1) - x(ii) > maxSlope/4
            ii = ii+1;
        end
        offset = ii;
    end
end
    
 