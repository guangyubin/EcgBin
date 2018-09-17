function [ diffecg ] = smg_alg_diff10ms( ecg, fs )
%   y[n] = x[n] - x[n - 10ms]
%   Filter delay is DERIV_LENGTH/2

ms10 = round(fs*0.01); %3
ecg = ecg(:);
ecgLen = length(ecg);
diffecg=zeros(1,ecgLen-1);
diffecg(1:ms10-1) = diff(ecg(1:ms10));
for ii=ms10+1:ecgLen
    diffecg(ii-1) = ecg(ii)-ecg(ii-ms10);
end

end

