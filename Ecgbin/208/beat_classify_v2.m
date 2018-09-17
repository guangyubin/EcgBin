% An arrhythmia classification system based on the RR-interval signal
%                      M.G. Tsipourasa, D.I. Fotiadisa,, D. Siderisb

function QRSType = beat_classify_v2(ecg,rpos,ramp,noise_level,fs)


rr = diff(rpos)/fs;
smrr = ecg_rr_smooth(rr,5);
smrr = [smrr(1), smrr];
% rr = cal_rr(rpos,SQIType,1  )/fs;
% mrr = median(rr);
noise_thr = 0.6;

mmrr = median(rr);
ii = 2 ;
goc3 = 1;
type = ones(1,length(rpos));
while ii <=length(rpos)
    if ii == 17 
       a =0; 
    end
    type(ii) = 1;
    mrr = smrr(ii);
    if ii == 2
        rr1 = rpos(ii)-rpos(ii-1); rr2 = rpos(ii)-rpos(ii-1); rr3 = rpos(ii+1)-rpos(ii);
        rr1 = rr1/fs;rr2 = rr2/fs; rr3 = rr3/fs;
        noise1 = noise_level(ii-1);
        noise2 = noise_level(ii);
        noise3 = noise_level(ii);
        noise4 = noise_level(ii+1);
        
    elseif ii == length(rpos)
        rr1 = rpos(ii-1)-rpos(ii-2); rr2 = rpos(ii)-rpos(ii-1); rr3 = rpos(ii-1)-rpos(ii-2);;
        rr1 = rr1/fs;rr2 = rr2/fs; rr3 = rr3/fs;
        noise1 = noise_level(ii-2);
        noise2 = noise_level(ii-1);
        noise3 = noise_level(ii);
        noise4 = noise_level(ii);
    else
        rr1 = rpos(ii-1)-rpos(ii-2); rr2 = rpos(ii)-rpos(ii-1); rr3 = rpos(ii+1)-rpos(ii);
        rr1 = rr1/fs;rr2 = rr2/fs; rr3 = rr3/fs;
        noise1 = noise_level(ii-2);
        noise2 = noise_level(ii-1);
        noise3 = noise_level(ii);
        noise4 = noise_level(ii+1);
    end
    c1 = rr2 < 0.6*mrr && 1.8*rr2 < rr1 && rr1 < 3 ;
    if c1==1
        pulse = 1;
        type(ii) = 3;
        kk = ii +1;
        while kk < length(rr-1)
            c2 =  (rr(kk-1) < 0.7*mrr && rr(kk) < 0.7*mrr && rr(kk+1) < 0.7*mrr) || (rr(kk-1)+rr(kk)+rr(kk+1))<1.7*mrr;
            if c2 ==1
                type(kk) = 1;
                kk = kk+1;
                pulse = pulse +1;
            else
                if pulse < 4
                    type(ii:kk) = 1;
                    goc3 = 1;
                else
                    type(ii:kk) = 2;
                    ii = kk;
                end
                break;
            end
        end
    else
        goc3 = 1;
    end;
    
    if goc3
        
        %　长短长
        c3 = 1.2*rr2 < rr1 && 1.3*rr2 < rr3 ; %  &&  2*rr2 > rr3;
        
         % 短短长
        c4 = ii> 2 && abs(rr1 - rr2) < 0.3*mrr && (rr1 < 0.8*mrr || rr2 < 0.8*mrr) && rr3 > 0.6*(rr1+rr2) && rr3 < 2.0;
    
      
        % 长短短
        c5 = abs(rr3 - rr2) < 0.3*mrr && (rr2 < 0.8*mrr || rr3 < 0.8*mrr) && rr1 > 0.6*(rr2+rr3) && rr1 < 2.0; 
     
        c51 = abs(rr3 - rr2) < 0.3*mrr && rr1 > 0.6*(rr2+rr3);
        %         c6 = 2.2*mrr < rr2  && rr2 <3.0*mrr && (abs(rr1 - rr2) < 0.2*mrr  || abs(rr2-rr3) < 0.2*mrr);
        c6 =  1.5 *mmrr< rr2 && rr2 < 3.0*mmrr ;
        c61 = abs(rr1 - rr3) < 0.3*mrr  && rr2 > 0.8*(rr1+rr3);
         c62 = abs(rr1 - rr3) < 0.1  && rr2 > 0.5*(rr1+rr3)+0.25;
        if c3 ==1 && noise1 < noise_thr && noise2 < noise_thr &&noise3 < noise_thr && noise4 < noise_thr  
            type(ii) = 3;
        end
        if c4 ==1 && noise1 < noise_thr && noise2 < noise_thr &&noise3 < noise_thr && noise4 < noise_thr
            type(ii) = 4;
        end
        if c5 ==1 && noise1 < noise_thr && noise2 < noise_thr &&noise3 < noise_thr && noise4 < noise_thr
            type(ii) = 5;
        end
        
  
        if c61==1&& noise1 < noise_thr &&noise2 < noise_thr && noise3 < noise_thr
%             x =  ecg(rpos(ii-1)+0.2*fs:rpos(ii)-0.2*fs);
%             if max(x) - min(x) < 0.5*median(ramp)
                type(ii) = 61;
%             end
        end
        
      if c62==1&& noise1 < noise_thr &&noise2 < noise_thr && noise3 < noise_thr
           type(ii) = 62;
      end
%         if c51==1
%             type(ii) = 51;
%         end
        if c6==1 && noise2 < noise_thr && noise3 < noise_thr 
%              x =  ecg(rpos(ii-1)+0.2*fs:rpos(ii)-0.2*fs);
%             if max(x) - min(x) < 0.5*median(ramp)
                type(ii) = 6;
%             end
            
          
        end
    end
    ii = ii+1;
    
    
end
QRSType = type;
% ;plot(smrr);hold on;plot(rr);

