function [ ecg_m ] = smg_alg_ecg_morphology( ecg_m, ecg_f, meanRR, fs, debug )
% 形态学运算
%   开运算+闭运算
%   ecgf 滤波后的ecg信号
%   fs 采样频率
% debug = 0;
if meanRR > 0.8
filt_num = round(0.2*fs);
else
filt_num = round(0.1*fs);
end

data_length = length(ecg_f);
% ecg_m = zeros(1,data_length);
if data_length>6
    
    sg = round(fs/80.0);
    s1 = ceil((sg-1)*0.5);
    ecg_f = smooth(ecg_f,fs/35);
    for ii = 1: data_length-s1	
		ecg_f(ii) = ecg_f(ii+s1);
    end

    for ii = 1:data_length	
		if (ii+2*filt_num-2) <= data_length
            ecg_m(ii+2*filt_num-2) = ecg_f(ii);
        end
    end		
	for ii = 1:(2*filt_num-2)	
		ecg_m(ii) = ecg_m(2*filt_num); 
    end
        
    
    %腐蚀运算
    for ii=1:data_length
        if ii+filt_num-1>data_length 
            ecg_m(ii)=0;
        else
            ecg_m(ii)=max(ecg_m(ii:ii+filt_num-1));
        end
    end
    %膨胀
    for ii=1:data_length
        if ii+filt_num-1>data_length 
            ecg_m(ii)=0;
        else
            ecg_m(ii)=min(ecg_m(ii:ii+filt_num-1));
        end
    end
    
    %膨胀
    for ii=1:data_length
        if ii+filt_num-1>data_length 
            ecg_m(ii)=0;
        else
            ecg_m(ii)=min(ecg_m(ii:ii+filt_num-1));
        end
    end
    
    %腐蚀运算
    for ii=1:data_length
        if ii+filt_num-1>data_length 
            ecg_m(ii)=0;
        else
            ecg_m(ii)=max(ecg_m(ii:ii+filt_num-1));
        end
    end

if debug>0
    figure(debug);
    subplot(211);
    plot(ecg_f);
    subplot(212)
    plot(ecg_m);
    ylim([0 100]); 
end
end

