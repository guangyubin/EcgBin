function [ meanRR ] = smg_calc_meanRR( RR )
% [fitresult, gof] = createFit(RR);

RR = RR(:);
RR = RR(RR>0);
if length(RR)>2
    
    [brob,stats] = smg_createFit(RR,0);
    %     newRR = RR(find(stats.w~=0));    
    
    % dRR=comp_dRR(RR);
    % dRR=smg_pt_calc_dRR(dRR);
    % [brob,stats] = smg_createFit(dRR(:,1),3);
    
    % [brob,stats] = smg_createFit_ransac(RR);
    % newRR = RR;
    
    meanRR = brob(1)+brob(2)*(length(RR)/2);
    
elseif length(RR)>1
    meanRR = mean(RR);
else
    meanRR = 0;
end
end

