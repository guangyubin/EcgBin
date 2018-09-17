function  res = isocheck(x,istart,len,ISO_LIMIT)

tmp = x(istart:istart+len-1);
if max(tmp) - min(tmp) > ISO_LIMIT
    res = 0;
else
    res = 1;
end;
