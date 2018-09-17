function m_old = lineralCount(x)
%%
% x = tmp;
x0 = x(1);
ii = 2;
m = 1;
m_old = 1;
while ii  < length(x)
    if x(ii)==x0
        m = m+1;
    else
        if m > m_old 
            m_old = m;
        end   
       
        x0 = x(ii);
        m = 1;
    end
    ii = ii +1;
end
  if m > m_old 
            m_old = m;
        end         