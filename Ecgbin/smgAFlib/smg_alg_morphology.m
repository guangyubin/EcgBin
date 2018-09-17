function [ ecg_m ] = smg_alg_morphology( ecg_f, filt_num, debug )
% 形态学运算
%   开运算+闭运算
%   ecgf 滤波后的ecg信号
%   fs 采样频率
% debug = 0;
[len_x, len_y] = size(ecg_f);
ecg_m = zeros(len_x,len_y);
% ecg_m=ecg_f;
data_length = max(len_x,len_y);
if data_length>filt_num
    s1 = round(filt_num/2);
    
    %% 把两头清零
    if ecg_f(s1)==0
        ecg_f(1:s1)=0;
    end

    if ecg_f(data_length-s1+1)==0
        ecg_f(data_length-s1+1:data_length)=0;
    end

    %% 腐蚀运算
    for ii=1+s1:data_length-s1
        ecg_m(ii)=max(ecg_f(ii-s1:ii+s1));
    end
    
    %膨胀
%     ecg_m2 = ecg_m;
%     for ii=1+s1:data_length-s1
%         ecg_m(ii)=min(ecg_m2(ii-s1:ii+s1));
%     end
    
%     %膨胀
%     for ii=1:data_length
%         if ii+filt_num-1>data_length 
%             ecg_m(ii)=0;
%         else
%             ecg_m(ii)=min(ecg_m(ii:ii+filt_num-1));
%         end
%     end
%     
%     %腐蚀运算
%     for ii=1:data_length
%         if ii+filt_num-1>data_length 
%             ecg_m(ii)=0;
%         else
%             ecg_m(ii)=max(ecg_m(ii:ii+filt_num-1));
%         end
%     end

end
if debug>0
    figure(debug);
    subplot(211);
    plot(ecg_f);
    subplot(212)
    plot(ecg_m);
 
end
end

