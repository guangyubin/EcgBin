%%
clc
m = 1;
z = [];
load POS
for ii = 1:size(POS_REF,1)
    x =squeeze(POS(ii,5,:));
    %     x = sort(x);
    %     if max(x) - min(x) < 2
    %         y(ii) = max(x);
    %     else
    x1 = x((x(1:8)~=0));
    y(ii) = floor(median(x1));
    
    
    %     end
    if abs(y(ii) - POS_REF(ii,5)) > 10
        z(m) = y(ii) - POS_REF(ii,5);
        m = m +1;
        disp([abs(y(ii) - POS_REF(ii,5))  ;x; POS_REF(ii,5)]')
    end;
end;
res= meas_qt(POS_REF(:,5)*4,y'*4);