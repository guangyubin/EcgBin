function [ rpos_out ] = smg_rmv_noise_qrs( rpos, noise_ecg,noise_thres, fs, meanRR,debug )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
rpos=rpos(:);
rpos_out=rpos;
poss_reg = noise_ecg>(noise_thres);

left  = find(diff([0 poss_reg'])==1);  % remember to zero pad at start
right = find(diff([poss_reg' 0])==-1); % remember to zero pad at end
for ii = 1 : length(left)-1
    if left(ii+1) - right(ii) < 0.05*fs
        poss_reg(right(ii):left(ii+1)) = 1;
    end
end
thresh=meanRR;
%0.2sÐÎÌ¬Ñ§
x = poss_reg;
if meanRR>0.8
    mor_length = round(0.3*fs);
elseif meanRR>0.5
    mor_length = round(0.2*fs);
else
    mor_length = round(0.1*fs);
    thresh=1.5*meanRR;
end

poss_reg=smg_alg_morphology(x,mor_length,0);

left  = find(diff([0 poss_reg'])==1);  % remember to zero pad at start
right = find(diff([poss_reg' 0])==-1); % remember to zero pad at end
for ii = 1 : length(left)
    tmpRR = abs(left(ii) - right(ii))/fs;
    if tmpRR < thresh
        poss_reg(left(ii):right(ii)) = 0;
    end
end


if ~isempty(rpos)&& ~isempty(noise_ecg)
    index123=[];
    
    for ii=1:length(rpos)
        if poss_reg(rpos(ii))>0
            index123=[index123, ii];
        end
    end
    noise_rpos=rpos_out(index123);
    rpos_out(index123)=0;
end

if debug>0 && ~isempty(noise_ecg)
    figure(debug);
    clf;
    %             subplot(311);plot(qrs');
    
    plot(noise_ecg);
    hold on;
    plot(poss_reg*noise_thres);
    plot(rpos,noise_ecg(rpos),'o');
    plot(noise_rpos,noise_ecg(noise_rpos),'x');
    hold off;
    
    
end

end

