%%  ����С����������Median wave
% ���� segment �ֶκ���ĵ�����
% ���  Median wave
function x = wavelete_median(segment)
 x0=segment; 
 c = [];
for ii = 1:size(x0,2);
    s = segment(:,ii);
    [c(:,ii),l] = wavedec(s,9,'db3');  
end;
c1 = median(c,2);
c1(1:l(1)) = 0 ;
x= waverec(c1,l,'db3');
  
