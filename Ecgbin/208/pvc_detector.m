function [npvc,beatinfo] = pvc_detector(ecg,fs,rpos)
a = matmgc(zeros(1,125),250,1);
 ecg= ecg*200;
beatinfo = zeros(length(rpos),9);
rr = diff(rpos);
rr = median(rr);
for ii = 1: length(rpos)
    if rpos(ii) > 0.4*fs && rpos(ii) < length(ecg)-0.6*fs
        x = ecg(rpos(ii)-0.4*fs : rpos(ii)+0.6*fs-1);
        x = resample(x,125,300);
        beatinfo(ii,:)= matmgc(x,rr,0);
        
    end
end
npvc = length(find(beatinfo(:,1)==5));
