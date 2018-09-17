%%  ����С����������Median wave
% ���� segdata �ֶκ���ĵ�����
% ���  Median wave
function x = wavelet_median(segdata)
    c = [];
    for kk = 1:size(segdata,1)
        for jj = 1:size(segdata,3);
            s = segdata(kk,:,jj);
            [c(:,jj),l] = wavedec(s,9,'db3');  
        end;
        c1 = median(c,2);
        c1(1:l(1)) = 0 ;
        x(:,kk)= waverec(c1,l,'db3');
    end
end
  
