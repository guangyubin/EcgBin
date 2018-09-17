function [rpos_out] = smg_rmv_qrs(rpos,type,typelist)

rpos_out = rpos;
for ii = 1:length(rpos_out)
    if isempty(find(typelist==type(ii))) 
        rpos_out(ii) = 0;
    end
end


end