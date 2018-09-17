function qrs = updata_qrs(fin)
% 把qrs格式转化为mit ate格式


% record = 'D:\MGCDB\mitdb250\100';
qrs = loadmgcqrs(fin);
for ii = 4:length(qrs.time)-4
    x = qrs.qrs(ii-2:ii+2,3);
    y = max(x) - min(x); 
    if y >500 && qrs.anntyp(ii) == 'V'
        qrs.anntyp(ii) = 'Q';
    end
    
%      if qrs.qrs(ii,12) >100 && qrs.anntyp(ii) == 'V'
%         qrs.anntyp(ii) = 'Q';
%      end
%       if qrs.qrs(ii,11) >100 && qrs.anntyp(ii) == 'V'
%         qrs.anntyp(ii) = 'Q';
%     end
end;


morphtype = double(qrs.qrs(:,1));
v = unique(morphtype);
for ii = 1:length(v)
    x = qrs.anntyp(morphtype==v(ii));
    idx = (morphtype==v(ii) & qrs.anntyp=='V');
    if ~isempty(idx) 
        r = sum(idx) / length(x);
        if r < 0.08
            qrs.anntyp(idx) = 'Q';
        end
    end
end
