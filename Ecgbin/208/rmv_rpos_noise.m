 %% 依据RR间期，去除比较短的RR间期
 function [ft_qrs,qrs] = rmv_rpos_noise(ft_qrs1,thr1 ,thr2,fs)

%  if nargin <3 
%      fig = 0 ;
%  end;
 if isempty(ft_qrs1)
     ft_qrs = ft_qrs1;
     qrs = [];
     return;
 end;
 
 ft_qrs = ft_qrs1;
 rpos = ft_qrs(1,:); 
 rr = diff(rpos); 
 ref_rr = median(rr);
 
 
 qrswidth = ft_qrs(2,:);
 qrswidth_avg =  median(qrswidth);
 qrswidth_unit = abs(qrswidth - qrswidth_avg)/qrswidth_avg;
 
 qrsheight = ft_qrs(3,:);
 qrsheight_avg = median(qrsheight);
 qrsheight_unit = abs(qrsheight -qrsheight_avg)/qrsheight_avg;
 


 
 
 sqi = max([qrswidth_unit ;qrsheight_unit; ]);
 
m = 3;
art = [];
while m <= length(rpos)
    if rpos(m) - rpos(m-2) < thr1*ref_rr 
        if abs(rpos(m) - (rpos(m-2)+ref_rr)) < abs(rpos(m-1) - (rpos(m-2)+ref_rr))        
            rpos(m-1) = [];
            sqi(m-1) = [];
            ft_qrs(:,m-1) = [];
        else
            rpos(m) = [];
            sqi(m) = [];
            ft_qrs(:,m) = [];
        end
        art(m-1) = 1;
        art(m-2) = 1;
    else
        art(m) = 0 ;
        m = m +1;       
    end    
end

for ii =  1: size(ft_qrs,2)
    if ft_qrs(2,ii) > thr2*fs
        art(ii) = 1;
    end
    
    if ft_qrs(3,ii) > 3*qrsheight_avg
        art(ii) = 1;
    end;
end;
   ft_qrs = cat(1,ft_qrs,art);
qrs = ft_qrs(1,:);
        


