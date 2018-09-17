function qrs = updataqrs(qrs);

nbase = 15;
nhfnoise = 16;
for ii = 4:length(qrs.time)-4
    x = qrs.qrs(ii-2:ii+2,nbase);
    y = max(x) - min(x);
    if y >500 && qrs.anntyp(ii) == 'V'
        qrs.anntyp(ii) = 'Q';
    end
    
%     mrr = median(qrs.qrs(ii-3:ii+3,8));
%     if qrs.qrs(ii,8)+qrs.qrs(ii+1 ,8) < 1.5*mrr && qrs.anntyp(ii) == 'V' ...
%             && qrs.anntyp(ii-1) == 'N' && qrs.anntyp(ii+1) == 'N'...
%          && qrs.qrs(ii,11) >50
%          qrs.anntyp(ii) = 'Q';
%     end
        
    
    %      if qrs.qrs(ii,12) >100 && qrs.anntyp(ii) == 'V'
    %         qrs.anntyp(ii) = 'Q';
    %      end
    if qrs.qrs(ii,nhfnoise) >70 && qrs.anntyp(ii) == 'V'
        qrs.anntyp(ii) = 'Q';
    end
end;


% morphtype = double(qrs.qrs(:,1));
% v = unique(morphtype);
% for ii = 1:length(v)
%     x = qrs.anntyp(morphtype==v(ii));
%     idx = (morphtype==v(ii) & qrs.anntyp=='V');
%     if ~isempty(idx)
%         r = sum(idx) / length(x);
%         if r < 0.08
%             qrs.anntyp(idx) = 'Q';
%         end
%     end
% end