% 合并离得太近的两项时，以相似度和时间为准
function [noise_ecg,en_thres] = smg_noise_qrs_detect(ecg,varargin)
% QRS detector based on the P&T method. This is an offline implementation
% of the detector.
%

% == managing inputs
WIN_SAMP_SZ = 7;
REF_PERIOD = 0.250;
THRES = 0.6;
fs = 1000;
debug = 0;

switch nargin
    case 1
        % do nothing
    case 2
        REF_PERIOD=varargin{1};
    case 3
        REF_PERIOD=varargin{1};
        THRES=varargin{2};
    case 4
        REF_PERIOD=varargin{1};
        THRES=varargin{2};
        fs=varargin{3};
    case 5
        REF_PERIOD=varargin{1};
        THRES=varargin{2};
        fs=varargin{3};
        debug=varargin{4};
    case 6
        REF_PERIOD=varargin{1};
        THRES=varargin{2};
        fs=varargin{3};
        fid_vec=varargin{4};
        SIGN_FORCE=varargin{5};
    case 7
        REF_PERIOD=varargin{1};
        THRES=varargin{2};
        fs=varargin{3};
        fid_vec=varargin{4};
        SIGN_FORCE=varargin{5};
        debug=varargin{6};
    case 8
        REF_PERIOD=varargin{1};
        THRES=varargin{2};
        fs=varargin{3};
        fid_vec=varargin{4};
        SIGN_FORCE=varargin{5};
        debug=varargin{6};
        WIN_SAMP_SZ = varargin{7};
    otherwise
        error('qrs_detect: wrong number of input arguments \n');
end

[a b] = size(ecg);
if(a>b); NB_SAMP=a; elseif(b>a); NB_SAMP=b; ecg=ecg'; end;
% tm = 1/fs:1/fs:ceil(NB_SAMP/fs);
tm = 1/fs * (1:1:NB_SAMP);

% == constants
MED_SMOOTH_NB_COEFF = round(fs/100);
AVG_SMOOTH_NB_COEFF = round(fs*8/100); % 80ms

INT_NB_COEFF = round(WIN_SAMP_SZ*fs/256); % length is 30 for fs=256Hz
SEARCH_BACK = 1; % perform search back (FIXME: should be in function param)
MAX_FORCE = []; % if you want to force the energy threshold value (FIXME: should be in function param)
MIN_AMP = 0.1; % if the median of the filtered ECG is inferior to MINAMP then it is likely to be a flatline
% note the importance of the units here for the ECG (mV)
NB_SAMP = length(ecg); % number of input samples

try
    % == Bandpass filtering for ECG signal
    % this sombrero hat has shown to give slightly better results than a
    % standard band-pass filter. Plot the frequency response to convince
    % yourself of what it does
    b1 = [-7.757327341237223e-05  -2.357742589814283e-04 -6.689305101192819e-04 -0.001770119249103 ...
        -0.004364327211358 -0.010013251577232 -0.021344241245400 -0.042182820580118 -0.077080889653194...
        -0.129740392318591 -0.200064921294891 -0.280328573340852 -0.352139052257134 -0.386867664739069 ...
        -0.351974030208595 -0.223363323458050 0 0.286427448595213 0.574058766243311 ...
        0.788100265785590 0.867325070584078 0.788100265785590 0.574058766243311 0.286427448595213 0 ...
        -0.223363323458050 -0.351974030208595 -0.386867664739069 -0.352139052257134...
        -0.280328573340852 -0.200064921294891 -0.129740392318591 -0.077080889653194 -0.042182820580118 ...
        -0.021344241245400 -0.010013251577232 -0.004364327211358 -0.001770119249103 -6.689305101192819e-04...
        -2.357742589814283e-04 -7.757327341237223e-05];
    
    %         b1 = resample(b1,fs,250);
    %         bpfecg = filtfilt(b1,1,ecg)';
    
    % [b,a] = butter(3,[5 11]/150,'bandpass');
    [b,a] = butter(3,[4 20]/150,'bandpass');
    bpfecg = filtfilt(b,a,ecg)';
    
    %%
    if (sum(abs(ecg-median(ecg))>MIN_AMP)/NB_SAMP)>0.02
        % if 20% of the samples have an absolute amplitude which is higher
        % than MIN_AMP then we are good to go.
        
        % == P&T operations
        %          dffecg = diff(bpfecg');  % (4) differentiate (one datum shorter)
        %                  dffecg  = smg_alg_5diff(bpfecg');
        dffecg  =smg_alg_diff10ms(bpfecg,fs)';
        
        sqrecg = dffecg.*dffecg; % (5) square ecg
        %         sqrecg = abs(dffecg);
        
        intecg = filter(ones(1,INT_NB_COEFF),1,sqrecg); % (6) integrate
        %mdfint = medfilt1(intecg,MED_SMOOTH_NB_COEFF);  % (7) smooth 中值滤波
        
        mdfint = smooth(intecg,AVG_SMOOTH_NB_COEFF);
        
        delay  = ceil((INT_NB_COEFF+AVG_SMOOTH_NB_COEFF)/2);
        mdfint = circshift(mdfint,-delay); % remove filter delay for scanning back through ECG
        
        
        %% look for some measure of signal quality with signal fid_vec? (FIXME)
        mdfintFidel = mdfint;
        m = 1;
        seglen = fs;
        for ii=1:seglen:length(mdfint)-seglen
            tmp = mdfint(ii:ii+seglen-1);
            segMax(m) = max(tmp);
            m = m +1;
        end
        avg_segMax = median(segMax);
        %         for ii = 1:length(segMax)
        %             if segMax(ii) > 3*avg_segMax
        % %                 mdfintFidel((ii-1)*seglen+1:ii*seglen) = 0;
        %                 mdfint((ii-1)*seglen+1:ii*seglen) = 0 ;
        %             end
        %         end
        %         mdfint(mdfint > 3*avg_segMax) = 0 ;
        en_thres = avg_segMax;
        %         if isempty(fid_vec);
        %             mdfintFidel = mdfint;
        %         else
        %             mdfintFidel(fid_vec>2) = 0;
        %         end;
        
        % == P&T threshold
        %         if NB_SAMP/fs>90; xs=sort(mdfintFidel(fs:fs*90-fs)); else xs = sort(mdfintFidel(fs:end-fs)); end;
        %
        %         if isempty(MAX_FORCE)
        %            if NB_SAMP/fs>10
        %                 ind_xs = ceil(98/100*length(xs));
        %                 en_thres = xs(ind_xs); % if more than ten seconds of ecg then 98% CI
        %             else
        %                 ind_xs = ceil(99/100*length(xs));
        %                 en_thres = xs(ind_xs); % else 99% CI
        %             end
        %         else
        %            en_thres = MAX_FORCE;
        %         end
        
        % build an array of segments to look into
        poss_reg = mdfint>(THRES*en_thres);        
        
        
        %% in case empty because force threshold and crap in the signal
        if isempty(poss_reg); poss_reg(10) = 1; end;
        
        % == P&T QRS detection & search back
        
        %% 用 0.2秒形态学腐蚀，提高medRRv的准确度
        x = poss_reg;
        y = zeros(length(x),1);
        mor_length = round(0.2*250);
        y=smg_alg_morphology(x,mor_length,0);
        
        indAboveThreshold = find(y); % ind of samples above threshold
        RRv = diff(tm(indAboveThreshold));  % compute RRv
        medRRv = median(RRv(RRv>0.01));
        
        
        
        %% smg if noise too high, dont's judge qrs pos.
        noise_ecg = smg_alg_ecg_morphology(mdfint,mdfint,medRRv,250,0);
        %         noise_ecg = smg_filter_ecg_noise_matlab(ecg,fs,medRRv,4);
        
        %%
        if debug>0
            figure(3);
            clf;
            %             subplot(311);plot(qrs');
            subplot(311);
            
            plot(dffecg);
            %             plot(noise_ecg);
            
            %             hold on;
            %             plot([0 length(noise_ecg)],[en_thres en_thres]);
            %             plot([0 length(noise_ecg)],[0.8*en_thres 0.8*en_thres]);
            %             ylim([0, 1.5*en_thres]);
            %             hold off;
            
            
            subplot(313);
            plot(poss_reg);
            hold on;
            plot(rloc,mdfintFidel(rloc),'.');
            plot(0.6*en_thres *poss_reg);
            hold off;
            
            subplot(312); plot(noise_ecg);
            
            
            %             plot(0.6*en_thres *y);
            %             hold off;
            
            %             figure(4);
            %             subplot(311);plot(ecg);
            %             subplot(312);plot(bpfecg);
            %             subplot(313);plot(dffecg);
        end     
        
        
    else
        % this is a flat line
        noise_ecg = [];
        en_thres = 0.5;
        
    end
catch ME
    rethrow(ME);
    for enb=1:length(ME.stack); disp(ME.stack(enb)); end;
    noise_ecg = []; en_thres = 0.5;
end









