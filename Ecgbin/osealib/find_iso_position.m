function  [isoStart,iosEnd ] = find_iso_position(x,findmark,fs,ISO_LIMIT)
if nargin <4 
    ISO_LIMIT = 0.1;
end
ISO_LENGTH1 = floor(0.05*fs);
  ISO_LENGTH2 = floor(0.08*fs);
%   ISO_LIMIT = 0.1;
  ii = findmark- ISO_LENGTH2;
  while  ii > 0  && max(x(ii:ii+ISO_LENGTH2)) - min(x(ii:ii+ISO_LENGTH2)) > ISO_LIMIT
      ii = ii - 1;
  end
  if ii == 0
      ii = findmark- ISO_LENGTH1;
      while  ii > 0  && max(x(ii:ii+ISO_LENGTH1)) - min(x(ii:ii+ISO_LENGTH1)) > ISO_LIMIT
          ii = ii - 1;
      end
      isoStart = ii+ISO_LENGTH1;
  else
      isoStart = ii;
      
      ii = isoStart +ISO_LENGTH2;
      % 如果找到了平坦的地方，随后加强平坦条件，在一定范围内继续寻找更优的平坦区域
     while  ii > isoStart   && max(x(ii:ii+ISO_LENGTH1)) - min(x(ii:ii+ISO_LENGTH1)) > ISO_LIMIT/2
        ii = ii - 1;
     end
     if ii == isoStart  
         isoStart = isoStart +ISO_LENGTH2;
     else
         isoStart = ii+ISO_LENGTH1;
     end
  end
  
%   tmp = x(isoStart -  ISO_LENGTH1:isoStart);
%   isovalue = mean(tmp);
%   index = find(tmp < isovalue
ii = findmark;
while  ii < length(x)-ISO_LENGTH1  && max(x(ii:ii+ISO_LENGTH1)) - min(x(ii:ii+ISO_LENGTH1)) > ISO_LIMIT
    ii = ii + 1;
end
iosEnd = ii;
% 如果找到了平坦的地方，随后加强平坦条件，在一定范围内继续寻找更优的平坦区域
while  ii < iosEnd + ISO_LENGTH1 && ii < length(x)-ISO_LENGTH1 && max(x(ii:ii+ISO_LENGTH1)) - min(x(ii:ii+ISO_LENGTH1)) > ISO_LIMIT/2
    ii = ii + 1;
end
if ii ==  iosEnd + ISO_LENGTH1
    iosEnd = iosEnd ;
else
    iosEnd = ii;
end
