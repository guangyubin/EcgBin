function [rr] = cal_rr(rpos,type,typelist)


m = 1;
rr= [];
for ii = 2:length(rpos)
    if ~isempty(find(typelist==type(ii))) && ~isempty(find(typelist==type(ii-1)))
%     if type(ii)==typelist && type(ii-1)==typelist
        rr(m) = rpos(ii) - rpos(ii-1);
        m = m +1;
    end
end;
