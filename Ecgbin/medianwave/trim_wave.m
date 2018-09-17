function  trim_wave = trim_wave(wave_median,cacul_wave,ileft,iright)
% x0 median_wave 前后不为0 的部分
% x 与x0对齐的计算的中值波形
    nchan = size(wave_median,2);
    len = size(cacul_wave,1);
    for chan = 1:nchan
        lag = -5:1:5;
        tmp = zeros(len+100,1);
        tmp(51:len+50) = cacul_wave(:,chan);
        x0 = wave_median(ileft:iright,chan);
        for kk = 1:length(lag)          
            x = tmp(ileft+50+lag(kk):iright+50+lag(kk));        
            RR = corrcoef(x0,x);
            R(kk) = RR(1,2);
        end;
        [a, idx] = max(R);
        trim_wave(:,chan) = tmp(ileft+50+lag(idx):iright+50+lag(idx));
    end
end   

%         




%     if length(x0) == size(wave_median,1)
%         trim_wave = cacul_wave;
%     else
%         lag = -5:1:5;
%         for kk = 1:length(lag)          
%             tmp = zeros(len+100,1);
%             tmp(51:len+50) = cacul_wave(:,1);
%             x = tmp(ileft+50+lag(kk):iright+50+lag(kk));        
%             RR = corrcoef(x0,x);
%             R(kk) = RR(1,2);
%         end;
%         [a, idx] = max(R);
%         for chan = 1:nchan
%             tmp_wave = zeros(len+100,1);
%             tmp_wave(51:len+50) = cacul_wave(:,chan);                
%             trim_wave(:,chan) = tmp_wave(ileft+50+lag(idx):iright+50+lag(idx));  
%         end