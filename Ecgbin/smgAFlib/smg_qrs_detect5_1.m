% 合并离得太近的两项时，以相似度和时间为准
function [maxloc,qrsheight, qrswidth,sign, noise_qrs] = smg_qrs_detect5_1(ecg,varargin)
% QRS detector based on the P&T method. This is an offline implementation
% of the detector.
%
% inputs
%   ecg:            one ecg channel on which to run the detector (required)
%                   in [mV]
%   varargin
%       THRES:      energy threshold of the detector (default: 0.6)
%                   [arbitrary units]
%       REF_PERIOD: refractory period in sec between two R-peaks (default: 0.250)
%                   in [ms]
%       fs:         sampling frequency (default: 1KHz) [Hz]
%       fid_vec:    if some subsegments should not be used for finding the
%                   optimal threshold of the P&Tthen input the indices of
%                   the corresponding points here
%       SIGN_FORCE: force sign of peaks (positive value/negative value).
%                   Particularly usefull if we do window by window detection and want to
%                   unsure the sign of the peaks to be the same accross
%                   windows (which is necessary to build an FECG template)
%       debug:      1: plot to bebug, 0: do not plot
%
% outputs
%   qrs_pos:        indexes of detected peaks (in samples)
%   sign:           sign of the peaks (a pos or neg number)
%   en_thres:       energy threshold used
%
%
%
% Physionet Challenge 2014, version 1.0
% Released under the GNU General Public License
%
% Copyright (C) 2014  Joachim Behar
% Oxford university, Intelligent Patient Monitoring Group
% joachim.behar@eng.ox.ac.uk
%
% Last updated : 13-09-2014
% - bug on refrac period fixed
% - sombrero hat for prefiltering added
% - code a bit more tidy
% - condition added on flatline detection for overall segment (if flatline
% then returns empty matrices rather than some random stuff)
%
% This program is free software; you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by the
% Free Software Foundation; either version 2 of the License, or (at your
% option) any later version.
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
% Public License for more details.

% == managing inputs
WIN_SAMP_SZ = 7;
REF_PERIOD = 0.250;
THRES = 0.6;
fs = 1000;
fid_vec = [];
SIGN_FORCE = [];
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
r  = [];
qrs = [];
sign = 1;
noise_qrs=[];

[a b] = size(ecg);
if(a>b); NB_SAMP=a; elseif(b>a); NB_SAMP=b; ecg=ecg'; end;
% tm = 1/fs:1/fs:ceil(NB_SAMP/fs);
tm = 1/fs * (1:1:NB_SAMP);

% == constants
MED_SMOOTH_NB_COEFF = round(fs/100);
INT_NB_COEFF = round(WIN_SAMP_SZ*fs/256); % length is 30 for fs=256Hz
SEARCH_BACK = 1; % perform search back (FIXME: should be in function param)
MAX_FORCE = []; % if you want to force the energy threshold value (FIXME: should be in function param)
MIN_AMP = 0.01; % if the median of the filtered ECG is inferior to MINAMP then it is likely to be a flatline
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
    
    %     [b,a] = butter(3,[10 16]/125,'bandpass');
    b1 = resample(b1,fs,250);
    bpfecg = filtfilt(b1,1,ecg)';
    [b,a] = butter(3,[4 20]/150,'bandpass');
    bpfecg = filtfilt(b,a,ecg)';
    if (sum(abs(ecg-median(ecg))>MIN_AMP)/NB_SAMP)>0.02
        % if 20% of the samples have an absolute amplitude which is higher
        % than MIN_AMP then we are good to go.
        
        % == P&T operations
        dffecg = diff(bpfecg');  % (4) differentiate (one datum shorter)
        sqrecg = dffecg.*dffecg; % (5) square ecg
        intecg = filter(ones(1,INT_NB_COEFF),1,sqrecg); % (6) integrate
        mdfint = medfilt1(intecg,MED_SMOOTH_NB_COEFF);  % (7) smooth
        delay  = ceil(INT_NB_COEFF/2);
        mdfint = circshift(mdfint,-delay); % remove filter delay for scanning back through ECG
        
        % look for some measure of signal quality with signal fid_vec? (FIXME)
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
        
        % 膨胀运算，把相邻的合并
        %         x = poss_reg;
        %         y = x;
        %         dn = 5;
        %         for ii=dn+1:length(x)-dn
        %             y(ii) = max(x(ii-dn:ii+dn));
        %         end;
        %         y1 = y;
        %         for ii=1:length(x)-10
        %             y1(ii) = max(y(ii:ii+10));
        %         end;
        %   figure;subplot(211);plot(mdfint);hold on;plot(0.6*en_thres *poss_reg);hold on;plot(0.6*en_thres *y,'r');
        %   subplot(212);plot(ecg);
        %         poss_reg = y;
        
        
        % in case empty because force threshold and crap in the signal
        if isempty(poss_reg); poss_reg(10) = 1; end;
        
        % == P&T QRS detection & search back
        
        if SEARCH_BACK
           %% 用 0.1秒形态学腐蚀，提高medRRv的准确度
            x = poss_reg;            
            mor_length = round(0.1*fs);
            y=smg_alg_morphology(x,mor_length,0);
            
            %%
%             indAboveThreshold = find(poss_reg); % ind of samples above threshold
            indAboveThreshold = find(y);
            
            RRv = diff(tm(indAboveThreshold));  % compute RRv
            medRRv = median(RRv(RRv>0.01));
            indMissedBeat = find(RRv>1.5*medRRv); % missed a peak?
            % find interval onto which a beat might have been missed
            indStart = indAboveThreshold(indMissedBeat);
            indEnd = indAboveThreshold(indMissedBeat+1);
%              if length(indStart) >=1

%              end
            %             if length(indStart) >=1
            %                 if indAboveThreshold(1) > RRv>1.5*medRRv
            %                     indEnd =   [indStart(1); indEnd];
            %                     indStart = [1; indStart];
            %                 end
            %             end
            if length(indStart) >=1
                if tm(indAboveThreshold(1)) >1.5*medRRv
                    indEnd =   [indAboveThreshold(1); indEnd];
                    indStart = [1; indStart];
                end
%                 if length(mdfint) - indAboveThreshold(end) > 1.5*medRRv*fs
%                     indEnd =   [indEnd ;length(mdfint)];
%                     indStart = [indStart; indStart(end)];
%                 end
            end
            
            for i=1:length(indStart)
                % look for a peak on this interval by lowering the energy threshold
                poss_reg(indStart(i):indEnd(i)) = mdfint(indStart(i):indEnd(i))>(0.3*THRES*en_thres);
            end
        end      
               
        %% smg 去掉开头全1，末尾全1
        poss_length=length(poss_reg);
        if poss_reg(1)==1
            for ii=1:poss_length
                if(poss_reg(ii)==1)
                    poss_reg(ii)=0;
                else
                    break;
                end
            end
        end
        if poss_reg(poss_length)==1
            for ii=poss_length:-1:1
                if(poss_reg(ii)==1)
                    poss_reg(ii)=0;
                else
                    break;
                end
            end
        end
        
        
        
        
        % find indices into boudaries of each segment
        left  = find(diff([0 poss_reg'])==1);  % remember to zero pad at start
        right = find(diff([poss_reg' 0])==-1); % remember to zero pad at end
        %   figure;subplot(211);plot(mdfint);hold on;plot(0.6*en_thres *poss_reg);hold on;plot(0.6*en_thres *y,'r');
        %   subplot(212);plot();
        % 去除特别大的干扰部分
        %          for ii = 1 : length(left)
        %
        %              if max(mdfint(left(ii):right(ii))) > 3*en_thres
        %                  poss_reg((left(ii):right(ii))) = 0 ;
        %              end
        %          end
        
        
        left  = find(diff([0 poss_reg'])==1);  % remember to zero pad at start
        right = find(diff([poss_reg' 0])==-1); % remember to zero pad at end
        for ii = 1 : length(left)-1
            if left(ii+1) - right(ii) < 0.05*fs
                poss_reg(right(ii):left(ii+1)) = 1;
            end
        end
        left  = find(diff([0 poss_reg'])==1);  % remember to zero pad at start
        right = find(diff([poss_reg' 0])==-1); % remember to zero pad at end
        
        %         wd = right - left;
        %         mwd = median(wd);
        %         for ii = 1 : length(left)
        %             if right(ii) - left(ii) > 3 * mwd
        %                 poss_reg(left(ii):right(ii)) = 0;
        %             end
        %         end
        %            left  = find(diff([0 poss_reg'])==1);  % remember to zero pad at start
        %         right = find(diff([poss_reg' 0])==-1); % remember to zero pad at end
        % looking for max/min?
        if SIGN_FORCE
            sign = SIGN_FORCE;
        else
            nb_s = length(left);
            loc  = zeros(1,nb_s);
            for j=1:nb_s
                [~,loc(j)] = max(abs(bpfecg(left(j):right(j))));
                loc(j) = loc(j)-1+left(j);
            end
            sign = median(bpfecg(loc));  % FIXME: change to median?
            if sign>=0
                sign=1;
            else
                sign=-1;
            end
        end
        
        % loop through all possibilities
        compt=1;
        NB_PEAKS = length(left);
        maxval = zeros(1,NB_PEAKS);
        maxdff = zeros(1,NB_PEAKS);
        maxloc = zeros(1,NB_PEAKS);
        qrswidth = zeros(1,NB_PEAKS);
        qrsheight = zeros(1,NB_PEAKS);
        for i=1:NB_PEAKS
            if sign>0
                % if sign is positive then look for positive peaks
                [maxval(compt), maxloc(compt)] = max(ecg(left(i):right(i)));
            else
                % if sign is negative then look for negative peaks
                [maxval(compt), maxloc(compt)] = min(ecg(left(i):right(i)));
                
            end
            [maxdff(compt), a] = max(mdfintFidel(left(i):right(i)));
            maxloc(compt) = maxloc(compt)-1+left(i);
            a = a-1+left(i);
            
            if abs(maxloc(compt)-a) > 0.03*fs
                maxloc(compt) = a;
            end
            
            
            
            qrswidth(compt) = right(i)-left(i);
            qrsheight(compt) = max(ecg(left(i):right(i))) - min(ecg(left(i):right(i)));
            % refractory period - has proved to improve results
            % 把离得靠近中点的保留
     
            
            
            if compt>3 && compt < NB_PEAKS-1
                n0 = abs(maxloc(compt)+maxloc(compt-3)-2*maxloc(compt-1));
                n1 = abs(maxloc(compt)+maxloc(compt-3)-2*maxloc(compt-2));
                if maxloc(compt-1)-maxloc(compt-2)<fs*REF_PERIOD && n0 >n1 %abs(maxdff(compt))<abs(maxdff(compt-1))
                    maxloc(compt-1)=[]; maxdff(compt-1)=[];maxval(compt-1) = [];
                    qrswidth(compt-1)=[];qrsheight(compt-1) = [];
                elseif maxloc(compt-1)-maxloc(compt-2)<fs*REF_PERIOD && n0 < n1 %abs(maxdff(compt))>=abs(maxdff(compt-1))
                    maxloc(compt-2)=[]; maxdff(compt-2)=[];  maxval(compt-2) = [];
                    qrswidth(compt-2)=[];qrsheight(compt-2) = [];
                else
                    compt=compt+1;
                end
                
            elseif  compt < 3 && compt > 1
                if maxloc(compt)-maxloc(compt-1)<fs*REF_PERIOD
                    maxloc(compt-1)=[]; maxdff(compt-1)=[];maxval(compt-1) = [];
                    qrswidth(compt-1)=[];qrsheight(compt-1) = [];
                else
                  compt=compt+1;
                end
            else
                % if first peak then increment
                compt=compt+1;
            end
        end
        
        % r position
        rloc = [];
        m = 1;
        for kk = 1 : length(maxloc)
            n0 = floor(maxloc(kk)-0.05*fs);
            n1 = floor(maxloc(kk)+0.05*fs);
            if n0>=1&& n1 < length(mdfint)
                if sign>0
                    [b ,rloc(m)] = max(ecg(n0:n1));
                    rloc(m) = n0-1+rloc(m);
                else
                    [b ,rloc(m)] = min(ecg(n0:n1));
                    rloc(m) = n0-1+rloc(m);
                end
                m = m +1;
            end
        end
              
           
        
       %% smg if noise too high, dont's judge qrs pos.
        noise_ecg = smg_alg_ecg_morphology(mdfint,mdfint,medRRv,fs,0);       
 


        %%       
        index = find(maxloc > 0.15*fs & maxloc < length(ecg)-0.15*fs);
        maxloc = maxloc(index);
        qrsheight = qrsheight(index);
        qrswidth = qrswidth(index);
        
        %         ft_qrs = cat(1,maxloc(index),qrswidth(index),qrsheight(index));
        %         maxloc = maxloc(index);
        %         qrswidth = qrswidth(index)
        
        
        if sign < 0
            sign = -1;
        end
        if debug==1
            
            subplot(211); plot(ecg); hold on;plot(rloc,ecg(rloc),'.');
            %            plot(left,ecg(left),'.k');
            %            plot(right,ecg(right),'.g');hold off;
            subplot(212); plot(mdfintFidel); hold on;plot(rloc,mdfintFidel(rloc),'.');
            plot(0.6*en_thres *poss_reg);
            
            hold off;
        end
        
        
    else
        qrswidth = [];
        maxloc = [];
        qrsheight = [];
    end
catch ME
    rethrow(ME);
    for enb=1:length(ME.stack); disp(ME.stack(enb)); end;
    sign = 1; 
     qrswidth = [];
        maxloc = [];
        qrsheight = [];
end

% == plots
% if debug
%     figure;
%     FONTSIZE = 20;
%     ax(1) = subplot(4,1,1); plot(tm,ecg); hold on;plot(tm,bpfecg,'r')
%         title('raw ECG (blue) and zero-pahse FIR filtered ECG (red)'); ylabel('ECG');
%         xlim([0 tm(end)]);  hold off;
%     ax(2) = subplot(4,1,2); plot(tm(1:length(mdfint)),mdfint);hold on;
%         plot(tm,max(mdfint)*bpfecg/(2*max(bpfecg)),'r',tm(left),mdfint(left),'og',tm(right),mdfint(right),'om');
%         title('Integrated ecg with scan boundaries over scaled ECG');
%         ylabel('Int ECG'); xlim([0 tm(end)]); hold off;
%     ax(3) = subplot(4,1,3); plot(tm,bpfecg,'r');hold on;
%         plot(R_t,R_amp,'+k');
%         title('ECG with R-peaks (black) and S-points (green) over ECG')
%         ylabel('ECG+R+S'); xlim([0 tm(end)]); hold off;
%     ax(4) = subplot(4,1,4); plot(R_t(1:length(hrv)),hrv,'r+')
%         hold on, title('HR')
%         ylabel('RR (s)'); xlim([0 tm(end)]);
%
%     %linkaxes(ax,'x');
%     set(gca,'FontSize',FONTSIZE);
%     allAxesInFigure = findall(gcf,'type','axes');
%     set(allAxesInFigure,'fontSize',FONTSIZE);
% end


% NOTES
%   Finding the P&T energy threshold: in order to avoid crash due to local
%   huge bumps, threshold is choosen at 98-99% of amplitude distribution.
%   first sec removed for choosing the thres because of filter init lag.
%
%   Search back: look for missed peaks by lowering the threshold in area where the
%   RR interval variability (RRv) is higher than 1.5*medianRRv
%
%   Sign of the QRS (signForce): look for the mean sign of the R-peak over the
%   first 30sec when looking for max of abs value. Then look for the
%   R-peaks over the whole record that have this given sign. This allows to
%   not alternate between positive and negative detections which might
%   happen in some occasion depending on the ECG morphology. It is also
%   better than forcing to look for a max or min systematically.








