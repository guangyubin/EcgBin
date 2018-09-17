function [val,pos] = min_pos(x,istart,iend)
if istart <=0
    istart = 0 ;
end
if iend > length(x)
    iend = length(x);
end
[a, b ] = min(x(istart:iend));
val = a;
pos = istart +b -1;