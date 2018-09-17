fs = 1000;
path = 'D:\Database_MIT\ptbdb\';
list = dir([path '\cinc2006\*.txt']);
m = 1;
DATA = [];
POS = [];
for ii = 1: length(list)
    fid = fopen([path '\cinc2006\' list(ii).name],'r');
    tline = fgetl(fid);
    while ischar(tline)
        k = strfind(tline, ' ');
        if length(k)==2
            fname = tline(1:k(1)-1);
            a = sscanf(tline(k(1):end),'%d %d');
            
            fid2 = fopen([path fname '.dat'],'rb');
            data = fread(fid2,[12 inf],'short');
            fclose(fid2);
            istart = a(1)+0.02*fs-0.4*fs+1;
            if istart > 0
                x = data(2,istart:istart+1.4*fs-1);
%                 x = resample(x,250,1000);
                a = a-istart;
                pos = [nan nan nan floor(a(1)) nan nan nan nan floor(a(2)) ];              
                
                
                x1 = data(2,istart:istart+10*fs-1);
                x1 = resample(x1,250,1000);
                [rpos ,~, ~,~] = qrs_detect5_1(x1',0.1,0.5,250,0);
                if length(rpos) >1
                    rr = rpos(2) - rpos(1);                   
                    if rr > 0.3*250 && rr < 2*250
                        DATA(:,m) = x'/2000;
                        POS(:,m) = pos';
                        RR(:,m) = rr*4;
                        m = m+1;                           
                    end
                else
                    a = 1;
                    [rpos ,~, ~,~] = qrs_detect5_1(x',0.3,0.6,250,1);
                end;
                %                 plot_ecg_beat_type(x,pos,'(P)(N)(T)')
            end
        end
        
        tline = fgetl(fid);
    end
    
    
    fclose(fid);
end;