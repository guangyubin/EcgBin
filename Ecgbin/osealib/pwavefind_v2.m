%%
function [Ponset,Poffset,Ppos,Pamp,y] = pwavefind_v2(x,findmark,fs,fig)
if nargin <4
    fig = 0;
end;
y = [];
WINDWIDTH = 0.06*fs;

for ii = WINDWIDTH+1:findmark-WINDWIDTH-0.01*fs
    tmp = x(ii-WINDWIDTH:ii);
    [a,b] = max(abs(tmp - x(ii)));
    a1 = tmp(b);
    
     tmp = x(ii:ii+WINDWIDTH-0.01*fs);
    [a,b] = max(abs(tmp - x(ii)));
    a2 = tmp(b);
    y(ii) = -( a1+a2 - 2*x(ii))/2;
end;
istart = max(1,findmark-0.25*fs);
[a1,b1 ] = max_pos(abs(y),istart,length(y));
Ppos = b1;
% 如果找到的P波太靠前了，往后寻找更合适的。
if findmark - b1 > 0.2*fs
    [a2,b2] = max_pos(abs(y),b1+0.05*fs,length(y));
    if a2 > 0.4*a1
        Ppos = b2;
    end
end;

% if findmark - b1 < WINDWIDTH+0.02*fs
%     [a2,b2] = max_pos(abs(y),istart,b1-0.05*fs);
%     if a2 > 0.4*a1
%         Ppos = b2;
%     end
% end;
  
Pamp = y(Ppos);
Ponset = Ppos - WINDWIDTH;
Poffset = Ppos+WINDWIDTH;
if fig==1
    subplot(211);plot(y);hold on;plot(Ppos,y(Ppos),'.r');
    subplot(212);plot(x);hold on;plot(Ppos,x(Ppos),'.r');
end