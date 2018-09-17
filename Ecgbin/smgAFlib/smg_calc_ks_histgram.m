function [ h2, RRrLength ] = smg_calc_ks_histgram( RR, debug )
%%

h2 = [];
RRrLength=0;
if length(RR) > 6    
    
    RRr = smg_calc_RRr( RR )';
    RRrLength = length(RRr);
    
    xx = [0:0.01:2.5];
    h2 = histc (RRr, xx);
    
    h2_sum = sum(h2(:));
    h2=cumsum(h2)/ h2_sum;
    
    if debug > 0
         set(gcf,'visible','on');
        figure(debug);
        clf;
        subplot(211);
        hold on;
        plot(RRr);
        plot(RRr,'bo');
        hold off;
        ylim([0 2*1]);
        ylabel('RR');
        
        subplot(212);
        hold on;
        plot(RRr);
        plot(RRr,'bo');
        hold off;
        ylim([0 2.5]);
        ylabel('RRr');
        
        
        hold on;
        figure(debug+1);
        
        
        plot(xx,h2,'LineWidth',1);
        ylim([0 1]);
        xlim([0 2.5]);
        
        pause();
    end
    
end

