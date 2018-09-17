function [val, pos ] = max_pos(x,istart,iend)

istart = floor(istart);
iend = floor(iend);
[a ,b ] = max(x(istart:iend));
val = a;
pos = istart +b -1;