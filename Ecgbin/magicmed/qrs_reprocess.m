% An arrhythmia classification system based on the RR-interval signal
%                      M.G. Tsipourasa, D.I. Fotiadisa,, D. Siderisb

function qrs = qrs_reprocess(qrs)

VV = 4;
VNVN = 3;
VNNV = 2;
VVV = 5;
SVTA = 1;
Pointsofinterest = [];
qrs.qrs(:,3) = 0;
m = 1;
for ii = 1 : length(qrs.time)-2
    if qrs.anntyp(ii) == 'N' && (qrs.qrs(ii,11) > 1*qrs.qrs(ii,12) )
        qrs.anntyp(ii) = ' ';
    end
end

% for ii = 3:length(qrs.time)-3
%     if  qrs.anntyp(ii) == 'N'&& qrs.anntyp(ii-1) == 'V'...
%            && qrs.anntyp(ii+1) == 'V'...
%             &&qrs.qrs(ii,8) < 800 && (qrs.qrs(ii,1) == qrs.qrs(ii+1) || qrs.qrs(ii,1) == qrs.qrs(ii-1))
%          qrs.anntyp(ii) = 'V';
%     end
%     if  qrs.anntyp(ii) == 'N'&& qrs.anntyp(ii-1) == 'V'...
%            && qrs.anntyp(ii-2) == 'V'...
%             &&qrs.qrs(ii,8) < 800 && (qrs.qrs(ii,1) == qrs.qrs(ii-1) || qrs.qrs(ii,1) == qrs.qrs(ii-2))
%          qrs.anntyp(ii) = 'V';
%     end
% end
% return;
    
rr = qrs.qrs(:,8);
svta_flag = 0;
dn = 2;

for ii = 5 : length(qrs.time)-5
    

    rr1 = rr(ii);
    rr2 = rr(ii+1);
    rr3 = rr(ii+2);
    if rr(ii)~=-1 && rr(ii+1)~=-1 && rr(ii+2)~=-1&&...
            qrs.anntyp(ii) ~= 'V'&& qrs.anntyp(ii+1) ~= 'V'&& qrs.anntyp(ii+2) ~= 'V'
         c3 = 1.2*rr2 < rr1 && 1.2*rr2 < rr3 && rr1 < 2000;
         if  c3==1 && qrs.qrs(ii,2) < 40 && qrs.qrs(ii,15) < 100 && qrs.qrs(ii,17)  < 50 ...
            &&abs(qrs.qrs(ii,12) - qrs.qrs(ii+1,12)) < 1000
        %max(qrs.qrs(ii-1:ii+1,12))- min(qrs.qrs(ii-1:ii+1,12)) < 1000
            qrs.anntyp(ii+1) = 'S';
        end

        if ii > dn && ii < length(qrs.time)-dn
            if svta_flag == 0
             
                if isempty(find(qrs.anntyp(ii-dn+1:ii+dn)=='V')) &&...
                        mean(rr(ii-dn+1:ii)) > 1.5*mean(rr(ii+1:ii+dn)) &&...
                        qrs.qrs(ii,2) < 20 && qrs.qrs(ii,15) < 100 && qrs.qrs(ii,17)  < 50&&...
                        max(qrs.qrs(ii-dn+1:ii+dn,12))- min(qrs.qrs(ii-dn+1:ii+dn,12)) < 2000 && ...
                        max(rr(ii+1:ii+dn)) - min(rr(ii+1:ii+dn)) < 300  && mean(rr(ii+1:ii+dn)) < 800 
                 
                  
                    svta_flag = 1;
                    basehr = mean(rr(ii-dn+1:ii)) ;
                    p = ii;
             
                end
            end
        end
    end
    if svta_flag==1 
        if qrs.anntyp(ii)== 'V'
            svta_flag = 0;
        else
            if ii > p+2
                if 1.5*mean(rr(ii-dn+1:ii)) < mean(rr(ii+1:ii+dn)) ...
                        || mean(rr(ii-dn+1:ii)) > basehr*0.9 
                    svta_flag = 0;
                    qrs.anntyp(p+1:ii) = 'S';
                     qrs.qrs(p+1:ii ,3) = SVTA;
                     m = m +1;
%                      disp(['SVT :' num2str(ii - p+1)]);

                end
            end
        end
    end
    
end

st = 1 ;
bigeminy = 0;
trigeminy = 0 ;
nVTCH = 0 ;

for ii = 1 : length(qrs.time)
    anntyp = qrs.anntyp(ii);
    switch st
        case 1
            if anntyp == 'V'
                st = 2;
            else
                st = 1;
            end
            
        case 2
            if anntyp== 'N'
                st = 3;
            else
                if anntyp == 'V'
                    st = 5;
                else
                    st = 1;
                end
                if trigeminy >=2
                    %disp([ num2str(ii) ' :三联律结束']);
                    qrs.qrs(ii - trigeminy*3-2:ii ,3) = VNNV;
                     m = m +1;
                end
                if bigeminy >=2
                    %disp([ num2str(ii) ' :二联律结束']);
                    qrs.qrs(ii - bigeminy*2-2:ii-1 ,3) = VNVN;
                end
                bigeminy  = 0 ;
                trigeminy = 0 ;
            end
        case 3
            if anntyp == 'N'
                st = 4;
                if bigeminy >=2
                    %disp([ num2str(ii) ' :二联律结束']);
                    qrs.qrs(ii - bigeminy*2-2:ii-1 ,3) = VNVN;
                end
                bigeminy  = 0 ;
            else
                if anntyp == 'V'
                    st = 2;
                    bigeminy = bigeminy+1;
                    if bigeminy==2
                        %disp([ num2str(ii) ' :二联律开始']);
                    end
                else
                    st = 1;
                    if bigeminy >=2
                        %disp([ num2str(ii) ' :二联律结束']);
                        qrs.qrs(ii-bigeminy*2-2:ii-1 ,3) = VNVN;
                    end
                    bigeminy  = 0 ;
                end
                if trigeminy >=2
                    %disp([ num2str(ii) ' :三联律结束']);
                    qrs.qrs(ii - trigeminy*3-2:ii ,3) = VNNV;
                end
                trigeminy = 0 ;
            end
        case 4
            if anntyp == 'V'
                st = 2;
                trigeminy = trigeminy+1;
                if trigeminy==2
                    %disp([ num2str(ii) ' :三联律开始']);
                end
            else
                if trigeminy >=2
                    %disp([ num2str(ii) ' :三联律结束']);
                    qrs.qrs(ii - trigeminy*3-3:ii ,3) = VNNV;
                end
                bigeminy  = 0 ;
                trigeminy = 0 ;
                st = 1;
                
            end
        case 5
            if anntyp == 'V'
                st = 6;
                nVTCH = 1;
                %disp([ num2str(ii) ' :室上性心动过速开始']);
                
            else
                st = 1;
                %disp([ num2str(ii) ' :成对PVC']);
                qrs.qrs(ii -2:ii-1 ,3) = VV;
            end
        case 6
            if anntyp == 'V'
                st = 6;
                nVTCH = nVTCH+1;
            else
                st = 1;
                if nVTCH>=1
                    qrs.qrs(ii -nVTCH -2:ii-1 ,3) =VVV;
                    %disp([ num2str(ii) ' :室上性心动过速结束']);
                end
                nVTCH = 0 ;
            end
    end
end

% ;plot(smrr);hold on;plot(rr);

