%%  利用小波方法计算Median wave
% 输入 segdata 分段后的心电数据
% 输出  Median wave
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
  
