function [ radius ] = smg_calc_radius( dRR, maxR, meanRR, percent )
% smg_calc_radius Summary of this function goes here
%   Detailed explanation goes here

radius=0;

dRR=dRR(:);

if length(dRR) > 1 && meanRR > 0
    dRR = dRR/meanRR;
    
    dRR0=dRR(1:end-1);
    dRR1=dRR(2:end);
    
    dRRx2 = dRR0.^2;
    dRRy2 = dRR1.^2;
    
    index123=[];
    for ii=1:length(dRR0)
        if (dRRx2(ii)+ dRRy2(ii))>(maxR/meanRR)^2
            index123=[index123 ii];
        end
    end
 
    dRRx2(index123)=[];
    dRRy2(index123)=[];
    
    dotlength = length(dRRx2);
    if dotlength>0
        
        dRRr2 = (dRRx2+dRRy2);
        
        radius = 0.01;
        
        dotThreshhold = floor(dotlength*percent);
        for radius = 0.01:0.01:maxR/meanRR
            
            dotSum = length(find( dRRr2 <= radius*radius ));
            
            if dotSum>=dotThreshhold
                break;
            end
            
        end
        
    end
    
end

