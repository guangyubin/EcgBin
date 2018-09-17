function [ radius, dRRnew2 ] = smg_calc_radius3( dRR, maxR, meanRR )
%smg_calc_radius Summary of this function goes here
%   Detailed explanation goes here

radius=-1;
dRRnew2 =[0,0];

drrlength = length(dRR);
if drrlength > 1
    dRR = dRR/meanRR;
    dRR=[dRR(2:length(dRR),1) dRR(1:length(dRR)-1,1)];
    
    dRRnew =[];
    count = 1;
    for ii=1:size(dRR,1)
        if (dRR(ii,1)^2+ dRR(ii,2)^2)<=(maxR/meanRR)^2
            dRRnew(count,:) = dRR(ii,:);
            count = count+1;
        end
    end
    
    [dotlength,~] = size(dRRnew);
    if dotlength>0
        
        dRRx2 = dRRnew(:,1).^2;
        dRRy2 = dRRnew(:,2).^2;
        
        dRRr = sqrt(dRRx2+dRRy2);
        
        radius = 0.01;
        %0.55, 0.11: TPR=0.90661 TNR=0.96662 avg=0.93662
        %0.6, 0.11: TPR=0.92348 TNR=0.95459 avg=0.93903
        %0.7, 0.12: TPR=0.93515 TNR=0.93751 avg=0.93633
        %0.8, 0.12: TPR=0.95331 TNR=0.89152 avg=0.92241
        dotThreshhold = floor(dotlength*0.6);
        for radius = 0.01:0.001:maxR/meanRR
            dotSum=0;
            dRRnew2 =[];
            count=1;
            %             for ii=1:dotlength
            %
            %                 if dRRr(ii)<=radius
            %                     dotSum=dotSum+1;
            %                     dRRnew2(count,:)=dRRnew(ii,:);
            %                     count=count+1;
            %                 end
            %
            %             end
            
            index123 = find(dRRr<=radius);
            dRRnew2=dRRnew(index123,:);
            dotSum = size(dRRnew2,1);
            
            if dotSum>=dotThreshhold
                break;
            end
            
        end
        
    end
    
end

