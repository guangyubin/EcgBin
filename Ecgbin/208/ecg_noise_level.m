
function [rpos ,ramp , noise_level,Flag_NoNoise1,Flag_NoNoise2,Flag_NoNoise3] = ecg_noise_level(ecg,POS,AMP,fs,THR_RATIO_AMP, THR_DIFF_NUMS)
%%
if nargin < 5
    THR_RATIO_AMP = 0.1;
    THR_DIFF_NUMS = 8;
end
rpos = POS.R;
ramp = AMP.R;

t1 = POS.QRSonset;
t2 = POS.QRSoffset;

list = ~isnan(rpos) & ~isnan(ramp) &~isnan(t1) &~isnan(t2)  ;
rpos = rpos(list);
ramp = ramp(list);
t1 = t1(list);
t2 = t2(list);
qamp = AMP.Q(list);
qamp(isnan(qamp)) = 0 ;
samp = AMP.S(list);
samp(isnan(samp)) = 0 ;

ecg_hf = filtfilt([1 -2 1]/2,1,ecg);
noise_level = zeros(1,length(rpos));

% QRSonset -0.2s  --- QRSonset
for ii = 1:length(rpos)
   if ii == 1
        rr(ii)  = rpos(2) - rpos(1);
        n0 = max(1,t1(ii)-0.2*fs);
        n1 = t1(ii);
    else
        rr(ii)  = rpos(ii) - rpos(ii-1);
        n01 = t2(ii-1)+0.3*fs ;
        n02 = max(1,t1(ii) - 0.2*fs);
        n1 = t1(ii);
        if n01>=n1
            n01 = t1(ii)-0.2*fs;
        end
        n0 = max(n01,n02);
    end
    n2 = t2(ii);
    n3 = min(length(ecg),t2(ii)+0.2*fs);
%      disp([n0 n1]);
    a = ecg(n0:n1);
    noise_level(ii) = max(a)-min(a);
    a = ramp(ii) - samp(ii);
    b = ramp(ii) - qamp(ii);
    if max(abs(a)) > max(abs(b))
        ramp(ii) = a;
    else
        ramp(ii) = b;
    end
%   disp([ii  t1(ii) rpos(ii) t2(ii)]);
    if t1(ii)< rpos(ii) && rpos(ii) < t2(ii)
        a = max(ecg(t1(ii):rpos(ii))) - min(ecg(t1(ii):rpos(ii)));
        b = max(ecg(rpos(ii):t2(ii))) - min(ecg(rpos(ii):t2(ii))) ;      
      
        if abs(a) > abs(b)
            te2(ii) = abs(b)/abs(a);
        else
            te2(ii) = abs(a) / abs(b);
        end;
        if te2(ii) < THR_RATIO_AMP
            noise_level(ii) = 10;
        end;
    else
        noise_level(ii) = 10;
    end
   
%     if (v1 > v2 && v1 < v3)||(v1<v2 && v1>v3)
%           noise_level(ii) = ramp(ii);
%     end
    % 如果Onset-offset之间，波形变化很大，则认为噪声
     x = ecg(t1(ii) : t2(ii));
    dx = diff(x);
    m  = 0;
    for kk = 1:length(dx)-1
        if (dx(kk)<0  && dx(kk+1)>=0 )|| (dx(kk)>0  && dx(kk+1)<=0 )
            m = m +1;
        end
    end;
    te3(ii) = m;
    if  te3(ii)  > THR_DIFF_NUMS
         noise_level(ii) = 10;
    end
   % end guangyubin
    %     ramp(ii) = max(ecg(n1:n2)) - min(ecg(n1:n2)) ;
end;
% disp(te2);
noise_level = noise_level/median(ramp);
Flag_NoNoise1 = noise_level < 0.6 ;
Flag_NoNoise2 = abs((ramp - median(ramp))) < 2*median(ramp);

Flag_NoNoise3 = ones(1,length(rr));

x = rr(rr > 0.25*fs & rr < 2.0*fs);
for ii = 1:length(rr)
    if  ii > 2 && rr(ii-1)+ rr(ii) < 1.2*median(x)
        Flag_NoNoise3(ii) = 0;
        Flag_NoNoise3(ii-1) = 0;
    end
    if  (rr(ii) < 0.35*median(x)) 
        Flag_NoNoise3(ii) = 0 ;
        if ii-1 > 0
            Flag_NoNoise3(ii-1) = 0 ;
        end
    end
end

% idx = find(Flag_NoNoise3==0);
% if ~isempty(idx)
%      Flag_NoNoise3(idx) = 0;
%      idx = idx - 1;
%     if idx(1) < 1
%         idx(1) = 1;
%     end;
%     Flag_NoNoise3(idx) = 0;
%  
% end
