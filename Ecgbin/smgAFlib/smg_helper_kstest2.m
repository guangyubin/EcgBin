function [ ks_p1, ks_p2 ] = smg_helper_kstest2( RR, debug )
% Descript: kstest helper function
% Input:
%    RR: RR interval
%    debug : if plot
% Output:
%    ks_p1, ks_p2 : p of kstest2.
% History:
%    Version 1.0.0    2017.7.27   Minggang Shao
% Author:
%     smg@263.net
%     Beijing university of techonolgy
ks_p1=0;
ks_p2=0;
[ hh, RRrLength  ] = smg_calc_ks_histgram( RR,debug );
if RRrLength>6
    load('ksdata3t.mat');
    ksdata4=ksdata3t;
    hh=hh';
    
    maxpp2=0;
    maxpp1=0;
    [x_size,y_size]=size(ksdata4);
    for jj=1:2
        PP = smg_alg_kstest2(ksdata4(jj,:),hh,50000,RRrLength);
        maxpp2=max(maxpp2,PP(2));
        maxpp1=max(maxpp1,PP(1));
    end
    
    ks_p1=maxpp1;
    ks_p2=maxpp2;
    
end

end

