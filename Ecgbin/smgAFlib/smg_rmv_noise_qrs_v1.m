function [ QRS ] = smg_rmv_noise_qrs_v1( dffecg, noise_ecg, rloc, en_thres, fs )
% smg_filter_qrs Summary of this function goes here
%   Detailed explanation goes here

QRS = rloc;
MS150 = round(fs*0.150);
MS110 = round(fs*0.11);

noise_thres = en_thres*0.8;
index123 =find( noise_ecg(rloc)>noise_thres)';

%% 根据rloc的位置，检测原始波形是否存在正负差分
index_noise=[];

for ii=1:length(index123)
    %             tmpdiffecg = diff(ecg(rloc(ii)-3:rloc(ii)+3));
    tmpleftBegin = rloc(ii) - MS110;
    if tmpleftBegin<1
        tmpleftBegin = 1;
    end
    tmpleftdiffecg = dffecg(tmpleftBegin:rloc(ii));
    
    tmprightEnd = rloc(ii)+MS110;
    if tmprightEnd>length(dffecg)
        tmprightEnd=length(dffecg);
    end
    tmprightdiffecg = dffecg(rloc(ii):tmprightEnd);
    
    if sign>0
        [tmpmax, tmpmaxIdx] = smg_alg_peek(tmpleftdiffecg,-1);
        [tmpmin, tmpminIdx] = smg_alg_trough(tmprightdiffecg,1);
    elseif sign<0
        [tmpmax, tmpmaxIdx] = smg_alg_peek(tmprightdiffecg,1);
        [tmpmin, tmpminIdx] = smg_alg_trough(tmpleftdiffecg,-1);
    end
    okflag = 0;
    qrs_width_left = 0;
    qrs_width_right = 0;
    if tmpmaxIdx>0 && tmpminIdx>0 && tmpmax > 0  && tmpmin< 0
        tmpmin = -tmpmin;
        if (tmpmax > (tmpmin/8)) && (tmpmin > (tmpmax/8) ...
                && ( (tmpmaxIdx + tmpminIdx) < MS150))
            okflag = 1;
            if sign>0
                qrs_width_left = rloc(ii) - tmpmaxIdx +1;
                qrs_width_right = rloc(ii) + tmpminIdx -1;
            else
                qrs_width_left = rloc(ii) - tmpminIdx +1;
                qrs_width_right = rloc(ii) + tmpmaxIdx -1;
            end
            
        end
    end
    
    if okflag ==0
        index_noise = [index_noise, ii];
    end
    
end

%%
%去掉异常的QRS
QRS(index_noise)=[];

end

