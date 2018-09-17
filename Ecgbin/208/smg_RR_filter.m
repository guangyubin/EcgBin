function [ newRR, meanRR ] = smg_RR_filter( RR )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
% [fitresult, gof] = createFit(RR);


[brob,stats] = smg_createFit(RR,0);
newRR = RR(find(stats.w~=0));


% dRR=comp_dRR(RR);
% dRR=smg_pt_calc_dRR(dRR);
% [brob,stats] = smg_createFit(dRR(:,1),3);

% [brob,stats] = smg_createFit_ransac(RR);
% newRR = RR;


meanRR = brob(1)+brob(2)*(length(RR)/2);
 %meanRR = mean(newRR);

end

