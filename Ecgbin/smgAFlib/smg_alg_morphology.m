function [ ecg_m ] = smg_alg_morphology( ecg_f, filt_num, debug )
% ��̬ѧ����
%   ������+������
%   ecgf �˲����ecg�ź�
%   fs ����Ƶ��
% debug = 0;
[len_x, len_y] = size(ecg_f);
ecg_m = zeros(len_x,len_y);
% ecg_m=ecg_f;
data_length = max(len_x,len_y);
if data_length>filt_num
    s1 = round(filt_num/2);
    
    %% ����ͷ����
    if ecg_f(s1)==0
        ecg_f(1:s1)=0;
    end

    if ecg_f(data_length-s1+1)==0
        ecg_f(data_length-s1+1:data_length)=0;
    end

    %% ��ʴ����
    for ii=1+s1:data_length-s1
        ecg_m(ii)=max(ecg_f(ii-s1:ii+s1));
    end
    
    %����
%     ecg_m2 = ecg_m;
%     for ii=1+s1:data_length-s1
%         ecg_m(ii)=min(ecg_m2(ii-s1:ii+s1));
%     end
    
%     %����
%     for ii=1:data_length
%         if ii+filt_num-1>data_length 
%             ecg_m(ii)=0;
%         else
%             ecg_m(ii)=min(ecg_m(ii:ii+filt_num-1));
%         end
%     end
%     
%     %��ʴ����
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

