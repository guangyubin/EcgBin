fs = 250;
path = 'D:\Database_MIT\qtdb';
list = dir([path '\*.dat']);
mm = 1;
for jj = 1: length(list)
    fname = list(jj).name(1:end-4);
    heasig=readheader(['D:\Database_MIT\qtdb\' fname '.hea']);
    ecg = rdsign212(['D:\Database_MIT\qtdb\' fname '.dat'],2,1,heasig.nsamp);
    ann = readannot(['D:\Database_MIT\qtdb\' fname '.q1c']);
    pos = ann.time;
    type = ann.anntyp;
    index = find(type=='N');    
    for ii = 1 : length(index)
        x = nan(1,9);
        label = '(p)(N)(T)';
        p0 = pos(index(ii));
        x(5) = 0.4*fs;        
        if type(index(ii)-1) =='('
            x(4) = pos(index(ii)-1)-p0+ 0.4*fs;
        end
        if type(index(ii)+1) ==')'
            x(6) = pos(index(ii)+1)-p0+ 0.4*fs;
        end
        
        % Õ˘«∞—∞’“T≤®
        
        tt =find(type(index(ii):min(index(ii)+4,length(type)))=='t');
        if ~isempty(tt)
            tt = tt+index(ii)-1;
            x(8) = pos(tt)-p0+ 0.4*fs;
            if type(tt-1) == '('
                x(7) = pos(tt-1) -p0+ 0.4*fs;
            end
            if type(tt+1) == ')'
                x(9) = pos(tt+1) -p0+ 0.4*fs;
            end
        end
        % Õ˘«∞—∞’“P≤®
        tt =find(type(max(1,index(ii)-4):index(ii))=='p');
        if ~isempty(tt)
            tt = tt+index(ii)-4-1;
            x(2) = pos(tt)-p0+ 0.4*fs;
            if type(tt-1) == '('
                x(1) = pos(tt-1) -p0+ 0.4*fs;
            end
            if type(tt+1) == ')'
                x(3) = pos(tt+1) -p0+ 0.4*fs;
            end
        end 
        % QRSŒª÷√
        if p0+10*fs < length(ecg)
            tmp = ecg(p0-0.4*fs+1:p0+10*fs,2);
            
            [rpos ,~, ~,~] = qrs_detect5_1(tmp,0.3,0.6,250,0);
            if length(rpos) > 2
                rr = diff(rpos);;
                RR(:,mm) = 1000*(rpos(2) - rpos(1))/fs;
                if RR(:,mm) > 1500 || RR(:,mm) < 500
%                            [rpos ,~, ~,~] = qrs_detect5_1(tmp,0.3,0.6,250,1);
                end;
                DATA(:,mm) = ecg(p0 - 0.4*fs+1:p0+fs,2);
                POS(:,mm) = x';
                mm = mm +1;
            end
        end
    end;   
end
