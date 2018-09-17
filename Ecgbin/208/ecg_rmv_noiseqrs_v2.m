function [type] = ecg_rmv_noiseqrs_v2(ecg,rpos,fs,type1,fig)



% type = zeros(1,length(rpos));
% type(noise_level < 0.6) = 1;
type = double(type1);
rr= [];m = 1;
for ii = 2:length(rpos)
    if type(ii)==1 && type(ii-1)==1
        rr(m) = rpos(ii) - rpos(ii-1);
        m = m +1;
    end
end;
if isempty(rr)
    rr = diff(rpos);
end
a = 1;
mrr = mean(rr(rr >0.3*fs & rr < 2.0*fs ));

left  = find(diff([1 type])==-1);
right = find(diff([type 1])==1);

% if fig==1
% figure;
% subplot(211);plot_ecg_beat_type(ecg,rpos,type)
% end

% OXO类型  决定是否去除X
for ii = 1:length(left)
    
    if left(ii)==right(ii)
        n = left(ii);
        if n-1 >0 && n+1 <=length(type) &&type(n-1) == 1 && type(n+1) == 1&& rpos(n+1) - rpos(n-1) < 1.2*mrr
            type(n) = 0;
        end
%         if n-2 >0 &&  n+1 <=length(type) && type(n-1) == 1 &&  rpos(n) - rpos(n-1)< 0.2*300
%             x1 = (rpos(n-2)+rpos(n+1))/2; 
%             if abs(x1 - rpos(n)) < abs(x1 - rpos(n-1))
%                   type(n-1) = 0 ;
%             else
%                 type(n) = 0 ;
%             end   
%         end 
        if n-1 >0 && n+1 <=length(type) &&type(n-1) == 1 && type(n+1) == 1&& rpos(n+1) - rpos(n-1) >= 1.2*mrr
            type(n) = 11;
        end
        if n==1 &&rpos(n+1)  >= 1.2*mrr
            type(n) = 11;
        end;
        if n==length(type)&& length(ecg) - rpos(n-1)  >= 1.2*mrr
            type(n) = 11;
        end;
    else% OXXXXO类型
        
        x = ecg(left(ii):right(ii));
        if left(ii)-1 >0
            ps = rpos(left(ii)-1);
        elseif right(ii)+1 > length(rpos)
              ps = rpos(right(ii))- mrr* round(rpos(right(ii))/mrr);
        else
            
            ps = rpos(right(ii)+1)- mrr* round(rpos(right(ii)+1)/mrr);
        end
        if right(ii)+1 <= length(rpos)
            pe = rpos(right(ii)+1);
        else
            a = rpos(right(ii));
            pe = a +mrr*round((length(ecg)-a)/mrr);
        end;
        
        n1 = round((pe - ps)/mrr)-1; % 期望的QRS个数
        if n1 == 0
            type(left(ii):right(ii)) = 0;
        else
            if length(x) > (n1)  % 如果找到的QRS个数大于期望的QRS个数   
                px = rpos(left(ii):right(ii)); % 可能的位置
                for mm = 1 : n1 
                    if right(ii)+1 > length(rpos)
                       Epos = ps + mm*mrr; %floor(mm*mrr);
                    else
                       Epos = ps + mm*(pe-ps)/(n1+1); %floor(mm*mrr);
        
                    end
                     [v,idx] = min(abs(px - Epos));
                     type(left(ii)+idx-1) = 21;
                end
            else
                type(left(ii):right(ii)) = 21;
            end;
        end
        
        %         type(left(ii)+idx(nb:end)-1) = 2;
    end
end;
% if fig ==1
% subplot(212);;plot_ecg_beat_type(ecg,rpos,type); hold on;
% plot(rpos,r1,'.');plot(rpos,r2,'*');
% % plot(rpos,ramp,'.r');
% end

