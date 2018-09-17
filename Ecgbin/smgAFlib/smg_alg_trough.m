function [ pk,pk_index ] = smg_alg_trough( datum, direction )
% peak() takes a datum as input and returns a peak index
% when the signal returns to half its peak height, or
datum = datum(:);
data_min = 0;
pk = 0 ;
pk_index = 0;

if direction > 0
     lastDatum=datum(1);
    start_idx = 2;
    step = 1;
    end_idx = length(datum);
else
    lastDatum=datum(end);
    
    start_idx = length(datum)-1;
    step = -1;
    end_idx = 1;
end

stage = 0;  %0：寻找最小值的下降阶段  1 下降阶段找到一个最小值 2 上升阶段 
data_begin = lastDatum;
for ii=start_idx: step : end_idx
    
    if stage <2 && (datum(ii) < lastDatum) && (datum(ii) < data_min)
        data_min = datum(ii) ;
        stage=1;
        pk = data_min ;
        pk_index = ii;
    end
    
    if stage>0
        %第二阶段数据值不能再小
        if stage==2 && ((datum(ii) < lastDatum) || (datum(ii) < data_min))
            pk_index = 0;
            break;
        end
        if (datum(ii) > lastDatum)
            stage = 2;
            %数值小于最大值的一半，即认为找到波谷
            if (datum(ii) > (data_min /2))                
                break;
            end
        end
    end

    lastDatum = datum(ii) ;
end

if direction < 0
pk_index = length(datum)- pk_index +1;
end

end
